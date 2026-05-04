class GameModel {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String phase; // 'group', 'roundOf32', 'roundOf16', 'quarter', 'semi', 'thirdPlace', 'final'
  final String? group; // 'A', 'B', 'C'... (só fase de grupos)
  final int matchNumber;
  final DateTime date;
  final String status; // 'open', 'closed', 'finished'
  final String? stadium;

  GameModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    required this.phase,
    this.group,
    required this.matchNumber,
    required this.date,
    this.status = 'open',
    this.stadium,
  });

  Map<String, dynamic> toMap() {
    return {
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'phase': phase,
      'group': group,
      'matchNumber': matchNumber,
      'date': date,
      'status': status,
      'stadium': stadium,
    };
  }

  factory GameModel.fromMap(String id, Map<String, dynamic> map) {
    return GameModel(
      id: id,
      homeTeam: map['homeTeam'] ?? '',
      awayTeam: map['awayTeam'] ?? '',
      homeScore: map['homeScore'],
      awayScore: map['awayScore'],
      phase: map['phase'] ?? '',
      group: map['group'],
      matchNumber: map['matchNumber'] ?? 0,
      date: map['date']?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'open',
      stadium: map['stadium'],
    );
  }
}