import 'group_phase_games.dart';

class ClassifiedTeams {
  // Retorna todos os 1º colocados de cada grupo
  static List<String> getFirstPlaces() {
    final firsts = <String>[];
    for (var group in GroupPhaseGames.groups) {
      final games = group['games'] as List;
      final teams = _extractTeams(games);
      firsts.add(teams[0]); // 1º colocado
    }
    return firsts;
  }

  // Retorna todos os 2º colocados de cada grupo
  static List<String> getSecondPlaces() {
    final seconds = <String>[];
    for (var group in GroupPhaseGames.groups) {
      final games = group['games'] as List;
      final teams = _extractTeams(games);
      seconds.add(teams[1]); // 2º colocado
    }
    return seconds;
  }

  // Retorna todos os 3º colocados de cada grupo
  static List<String> getThirdPlaces() {
    final thirds = <String>[];
    for (var group in GroupPhaseGames.groups) {
      final games = group['games'] as List;
      final teams = _extractTeams(games);
      thirds.add(teams[2]); // 3º colocado
    }
    return thirds;
  }

  // Retorna os 8 melhores terceiros (mock: os 8 primeiros)
  static List<String> getBestThirds() {
    final allThirds = getThirdPlaces();
    return allThirds.take(8).toList();
  }

  // Extrai times únicos na ordem dos jogos
  static List<String> _extractTeams(List games) {
    final teams = <String>[];
    for (var game in games) {
      if (!teams.contains(game['homeTeam'])) teams.add(game['homeTeam']);
      if (!teams.contains(game['awayTeam'])) teams.add(game['awayTeam']);
    }
    return teams;
  }
}
