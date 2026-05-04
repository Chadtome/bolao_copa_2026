class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final int totalPoints;
  final int exactScores;
  final int winners;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.isAdmin = false,
    this.totalPoints = 0,
    this.exactScores = 0,
    this.winners = 0,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'totalPoints': totalPoints,
      'exactScores': exactScores,
      'winners': winners,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      totalPoints: map['totalPoints'] ?? 0,
      exactScores: map['exactScores'] ?? 0,
      winners: map['winners'] ?? 0,
      createdAt: map['createdAt']?.toDate(),
    );
  }
}