class BetModel {
  final String id;
  final String userId;
  final String gameId;
  final int homeBet;
  final int awayBet;
  final int points; // 0, 1 ou 3
  final String? result; // 'exact', 'winner', 'wrong' ou null
  final DateTime? createdAt;

  BetModel({
    required this.id,
    required this.userId,
    required this.gameId,
    required this.homeBet,
    required this.awayBet,
    this.points = 0,
    this.result,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'gameId': gameId,
      'homeBet': homeBet,
      'awayBet': awayBet,
      'points': points,
      'result': result,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  factory BetModel.fromMap(String id, Map<String, dynamic> map) {
    return BetModel(
      id: id,
      userId: map['userId'] ?? '',
      gameId: map['gameId'] ?? '',
      homeBet: map['homeBet'] ?? 0,
      awayBet: map['awayBet'] ?? 0,
      points: map['points'] ?? 0,
      result: map['result'],
      createdAt: map['createdAt']?.toDate(),
    );
  }
}