import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/game_model.dart';
import '../models/bet_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== AUTENTICAÇÃO ==========

  // Registrar novo usuário
  Future<UserModel?> register(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        isAdmin: false,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());

      return newUser;
    } catch (e) {
      print('Erro ao registrar: $e');
      return null;
    }
  }

  // Login
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Buscar dados do usuário logado
  Future<UserModel?> getCurrentUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // ========== JOGOS ==========

  // Buscar todos os jogos
  Stream<List<GameModel>> getGames() {
    return _firestore
        .collection('games')
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => GameModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Buscar jogos por fase
  Stream<List<GameModel>> getGamesByPhase(String phase) {
    return _firestore
        .collection('games')
        .where('phase', isEqualTo: phase)
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => GameModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Atualizar resultado do jogo (ADM)
  Future<void> updateGameResult(String gameId, int homeScore, int awayScore) async {
    await _firestore.collection('games').doc(gameId).update({
      'homeScore': homeScore,
      'awayScore': awayScore,
      'status': 'finished',
    });
  }

  // ========== PALPITES ==========

  // Salvar palpite
  Future<void> saveBet(BetModel bet) async {
    // Verifica se já existe palpite desse usuário para esse jogo
    QuerySnapshot existing = await _firestore
        .collection('bets')
        .where('userId', isEqualTo: bet.userId)
        .where('gameId', isEqualTo: bet.gameId)
        .get();

    if (existing.docs.isNotEmpty) {
      // Atualiza palpite existente
      await _firestore.collection('bets').doc(existing.docs.first.id).update({
        'homeBet': bet.homeBet,
        'awayBet': bet.awayBet,
      });
    } else {
      // Cria novo palpite
      await _firestore.collection('bets').add(bet.toMap());
    }
  }

  // Buscar palpites do usuário
  Stream<List<BetModel>> getUserBets(String userId) {
    return _firestore
        .collection('bets')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BetModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Buscar todos os palpites de um jogo específico
  Stream<List<BetModel>> getBetsByGame(String gameId) {
    return _firestore
        .collection('bets')
        .where('gameId', isEqualTo: gameId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BetModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // ========== USUÁRIOS ==========

  // Buscar todos os usuários
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection('users')
        .orderBy('totalPoints', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Deletar usuário (ADM)
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  // ========== PONTUAÇÃO ==========

  // Calcular pontos após resultado inserido
  Future<void> calculatePoints(String gameId, int homeScore, int awayScore) async {
    QuerySnapshot betsSnapshot = await _firestore
        .collection('bets')
        .where('gameId', isEqualTo: gameId)
        .get();

    for (var doc in betsSnapshot.docs) {
      BetModel bet = BetModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      
      int points = 0;
      String result = 'wrong';

      // Acertou placar exato
      if (bet.homeBet == homeScore && bet.awayBet == awayScore) {
        points = 3;
        result = 'exact';
      }
      // Acertou vencedor ou empate
      else if ((homeScore > awayScore && bet.homeBet > bet.awayBet) ||
               (homeScore < awayScore && bet.homeBet < bet.awayBet) ||
               (homeScore == awayScore && bet.homeBet == bet.awayBet)) {
        points = 1;
        result = 'winner';
      }

      // Atualiza o palpite com a pontuação
      await _firestore.collection('bets').doc(doc.id).update({
        'points': points,
        'result': result,
      });

      // Atualiza pontuação do usuário
      if (points > 0) {
        DocumentReference userRef = _firestore.collection('users').doc(bet.userId);
        DocumentSnapshot userDoc = await userRef.get();
        
        if (userDoc.exists) {
          int currentPoints = userDoc['totalPoints'] ?? 0;
          int exactScores = userDoc['exactScores'] ?? 0;
          int winners = userDoc['winners'] ?? 0;

          await userRef.update({
            'totalPoints': currentPoints + points,
            'exactScores': result == 'exact' ? exactScores + 1 : exactScores,
            'winners': result == 'winner' ? winners + 1 : winners,
          });
        }
      }
    }
  }
}