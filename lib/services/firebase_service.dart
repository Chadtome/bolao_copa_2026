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
  Future<UserModel?> register(String name, String email, String password, {String? whatsapp, String? pix}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      UserModel newUser = UserModel(id: userCredential.user!.uid, name: name, email: email, isAdmin: false, whatsapp: whatsapp, pix: pix);

      await _firestore.collection('users').doc(userCredential.user!.uid).set(newUser.toMap());

      return newUser;
    } catch (e) {
      print('Erro ao registrar: $e');
      return null;
    }
  }

  // Login
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();

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
    return _firestore.collection('games').orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => GameModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  // Buscar jogos por fase
  Stream<List<GameModel>> getGamesByPhase(String phase) {
    return _firestore.collection('games').where('phase', isEqualTo: phase).orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => GameModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  // Atualizar resultado do jogo (ADM)
  Future<void> updateGameResult(String gameId, int homeScore, int awayScore) async {
    await _firestore.collection('games').doc(gameId).update({'homeScore': homeScore, 'awayScore': awayScore, 'status': 'finished'});
  }

  // ========== PALPITES ==========

  // Salvar palpite
  Future<void> saveBet({
  required String userId,
  required String gameId,
  required int homeBet,
  required int awayBet,
}) async {
  // Verifica se já existe palpite
  QuerySnapshot existing = await _firestore
      .collection('bets')
      .where('userId', isEqualTo: userId)
      .where('gameId', isEqualTo: gameId)
      .get();

  if (existing.docs.isNotEmpty) {
    // Atualiza
    await _firestore.collection('bets').doc(existing.docs.first.id).update({
      'homeBet': homeBet,
      'awayBet': awayBet,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  } else {
    // Cria novo
    await _firestore.collection('bets').add({
      'userId': userId,
      'gameId': gameId,
      'homeBet': homeBet,
      'awayBet': awayBet,
      'points': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
  // Buscar palpites do usuário
  Stream<List<BetModel>> getUserBets(String userId) {
    return _firestore.collection('bets').where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BetModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  // Buscar todos os palpites de um jogo específico
  Stream<List<BetModel>> getBetsByGame(String gameId) {
    return _firestore.collection('bets').where('gameId', isEqualTo: gameId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BetModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  // ========== USUÁRIOS ==========

  // Buscar todos os usuários
  Stream<List<UserModel>> getUsers() {
    return _firestore.collection('users').orderBy('totalPoints', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  // Deletar usuário (ADM)
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  // ========== PONTUAÇÃO ==========

  // Calcular pontos após resultado inserido
  Future<void> calculatePoints(String gameId, int homeScore, int awayScore) async {
    QuerySnapshot betsSnapshot = await _firestore.collection('bets').where('gameId', isEqualTo: gameId).get();

    for (var doc in betsSnapshot.docs) {
      BetModel bet = BetModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);

      int points = 0;
      String result = 'wrong';

      if (bet.homeBet == homeScore && bet.awayBet == awayScore) {
        points = 3;
        result = 'exact';
      } else if ((homeScore > awayScore && bet.homeBet > bet.awayBet) ||
          (homeScore < awayScore && bet.homeBet < bet.awayBet) ||
          (homeScore == awayScore && bet.homeBet == bet.awayBet)) {
        points = 1;
        result = 'winner';
      }

      await _firestore.collection('bets').doc(doc.id).update({'points': points, 'result': result});

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

  // ========== RECUPERAR SENHA ==========
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Buscar todos os usuários (Stream)
Stream<QuerySnapshot> getUsersStream() {
  return _firestore
    .collection('users')
    .where('isAdmin', isEqualTo: false)
    .orderBy('totalPoints', descending: true)
    .snapshots();
}

// Buscar palpites do usuário por gameId (Stream)
Stream<QuerySnapshot> getUserBetsStream(String userId) {
  return _firestore
      .collection('bets')
      .where('userId', isEqualTo: userId)
      .snapshots();
}

// Buscar lista de palpites do usuário
Future<List<Map<String, dynamic>>?> getUserBetsList(String userId) async {
  try {
    final snapshot = await _firestore
        .collection('bets')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'gameId': data['gameId'] ?? '',
        'homeBet': data['homeBet'] ?? 0,
        'awayBet': data['awayBet'] ?? 0,
      };
    }).toList();
  } catch (e) {
    print('Erro ao buscar palpites: $e');
    return null;
  }
}

// Calcular pontos para um jogo específico
Future<void> calculatePointsForGame(String gameId, int homeScore, int awayScore) async {
  QuerySnapshot betsSnapshot = await _firestore
      .collection('bets')
      .where('gameId', isEqualTo: gameId)
      .get();

  for (var doc in betsSnapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final homeBet = (data['homeBet'] as num?)?.toInt() ?? 0;
    final awayBet = (data['awayBet'] as num?)?.toInt() ?? 0;
    final userId = data['userId'] as String;

    int points = 0;
    String result = 'wrong';

    if (homeBet == homeScore && awayBet == awayScore) {
      points = 3;
      result = 'exact';
    } else if ((homeScore > awayScore && homeBet > awayBet) ||
               (homeScore < awayScore && homeBet < awayBet) ||
               (homeScore == awayScore && homeBet == awayBet)) {
      points = 1;
      result = 'winner';
    }

    // Pontos antigos (antes da edição)
    final oldPoints = (data['points'] as num?)?.toInt() ?? 0;
    final oldResult = data['result'] as String? ?? '';

    // Atualiza o palpite com a nova pontuação
    await _firestore.collection('bets').doc(doc.id).update({
      'points': points,
      'result': result,
    });

    // Atualiza pontuação do usuário
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (userDoc.exists) {
      int currentPoints = (userDoc['totalPoints'] as num?)?.toInt() ?? 0;
      int exactScores = (userDoc['exactScores'] as num?)?.toInt() ?? 0;
      int winners = (userDoc['winners'] as num?)?.toInt() ?? 0;

      // Remove pontos antigos
      currentPoints -= oldPoints;
      if (oldResult == 'exact' && exactScores > 0) exactScores--;
      if (oldResult == 'winner' && winners > 0) winners--;

      // Adiciona novos pontos
      currentPoints += points;
      if (result == 'exact') exactScores++;
      if (result == 'winner') winners++;

      await userRef.update({
        'totalPoints': currentPoints,
        'exactScores': exactScores,
        'winners': winners,
      });
    }
  }
}

// Salvar palpite do campeão
Future<void> salvarCampeaoPalpite(String userId, String campeao) async {
  await _firestore.collection('users').doc(userId).update({
    'campeaoPalpite': campeao,
  });
}

// Verificar palpite do campeão (10 pontos)
Future<void> verificarCampeaoPalpite(String campeao) async {
  final snapshot = await _firestore
      .collection('users')
      .where('campeaoPalpite', isEqualTo: campeao)
      .get();

  for (var doc in snapshot.docs) {
    final currentPoints = (doc['totalPoints'] as num?)?.toInt() ?? 0;
    await doc.reference.update({'totalPoints': currentPoints + 10});
  }
}

}
