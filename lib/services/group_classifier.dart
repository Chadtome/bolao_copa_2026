import '../data/group_phase_games.dart';

class GroupClassifier {
  final Map<String, Map<String, dynamic>> _resultados;

  GroupClassifier(this._resultados);

  List<String> classificar(int groupIndex) {
    final group = GroupPhaseGames.groups[groupIndex];
    final games = group['games'] as List;

    final teams = <String>[];
    for (var game in games) {
      if (!teams.contains(game['homeTeam'])) teams.add(game['homeTeam']);
      if (!teams.contains(game['awayTeam'])) teams.add(game['awayTeam']);
    }

    teams.sort((a, b) => _compararTimes(a, b, games));
    return teams;
  }

  int _compararTimes(String a, String b, List games) {
    // 1. Pontos
    final ptsA = _calcularPontos(a, games);
    final ptsB = _calcularPontos(b, games);
    if (ptsA != ptsB) return ptsB.compareTo(ptsA);

    // Verifica se há empate triplo
    final todosPontos = _todosPontos(games);
    final empatados = todosPontos.where((t) => t['pontos'] == ptsA).length;

    // Só aplica confronto direto se for empate duplo
    if (empatados <= 2) {
      final confronto = _buscarConfronto(a, b, games);
      if (confronto != null) {
        final ptsDirA = _pontosNoConfronto(a, confronto);
        final ptsDirB = _pontosNoConfronto(b, confronto);
        if (ptsDirA != ptsDirB) return ptsDirB.compareTo(ptsDirA);

        final sgDirA = _saldoGolsNoConfronto(a, confronto);
        final sgDirB = _saldoGolsNoConfronto(b, confronto);
        if (sgDirA != sgDirB) return sgDirB.compareTo(sgDirA);

        final gpDirA = _golsMarcadosNoConfronto(a, confronto);
        final gpDirB = _golsMarcadosNoConfronto(b, confronto);
        if (gpDirA != gpDirB) return gpDirB.compareTo(gpDirA);
      }
    }

    // Saldo de gols geral
    final sgA = _saldoGols(a, games);
    final sgB = _saldoGols(b, games);
    if (sgA != sgB) return sgB.compareTo(sgA);

    // Gols marcados
    final gpA = _golsMarcados(a, games);
    final gpB = _golsMarcados(b, games);
    if (gpA != gpB) return gpB.compareTo(gpA);

    return 0;
  }

  List<Map<String, dynamic>> _todosPontos(List games) {
    final teams = <String>{};
    for (var game in games) {
      teams.add(game['homeTeam']);
      teams.add(game['awayTeam']);
    }
    return teams.map((t) => {'time': t, 'pontos': _calcularPontos(t, games)}).toList();
  }

  int _calcularPontos(String team, List games) {
    int pontos = 0;
    for (var game in games) {
      final resultado = _resultados['${game['homeTeam']}_${game['awayTeam']}'];
      if (resultado == null) continue;
      final home = resultado['home'] as int;
      final away = resultado['away'] as int;
      if (game['homeTeam'] == team) {
        if (home > away) pontos += 3;
        if (home == away) pontos += 1;
      } else if (game['awayTeam'] == team) {
        if (away > home) pontos += 3;
        if (home == away) pontos += 1;
      }
    }
    return pontos;
  }

  int _saldoGols(String team, List games) {
    return _golsMarcados(team, games) - _golsSofridos(team, games);
  }

  int _golsMarcados(String team, List games) {
    int gols = 0;
    for (var game in games) {
      final resultado = _resultados['${game['homeTeam']}_${game['awayTeam']}'];
      if (resultado == null) continue;
      if (game['homeTeam'] == team) gols += resultado['home'] as int;
      if (game['awayTeam'] == team) gols += resultado['away'] as int;
    }
    return gols;
  }

  int _golsSofridos(String team, List games) {
    int gols = 0;
    for (var game in games) {
      final resultado = _resultados['${game['homeTeam']}_${game['awayTeam']}'];
      if (resultado == null) continue;
      if (game['homeTeam'] == team) gols += resultado['away'] as int;
      if (game['awayTeam'] == team) gols += resultado['home'] as int;
    }
    return gols;
  }

  Map<String, dynamic>? _buscarConfronto(String a, String b, List games) {
    for (var game in games) {
      if ((game['homeTeam'] == a && game['awayTeam'] == b) ||
          (game['homeTeam'] == b && game['awayTeam'] == a)) {
        final key = '${game['homeTeam']}_${game['awayTeam']}';
        return _resultados[key];
      }
    }
    return null;
  }

  int _pontosNoConfronto(String team, Map<String, dynamic> confronto) {
    final homeTeam = confronto['homeTeam'] as String;
    final home = confronto['home'] as int;
    final away = confronto['away'] as int;
    if (home > away) return team == homeTeam ? 3 : 0;
    if (away > home) return team != homeTeam ? 3 : 0;
    return 1;
  }

  int _saldoGolsNoConfronto(String team, Map<String, dynamic> confronto) {
    return _golsMarcadosNoConfronto(team, confronto) - _golsSofridosNoConfronto(team, confronto);
  }

  int _golsMarcadosNoConfronto(String team, Map<String, dynamic> confronto) {
    final homeTeam = confronto['homeTeam'] as String;
    if (team == homeTeam) return confronto['home'] as int;
    return confronto['away'] as int;
  }

  int _golsSofridosNoConfronto(String team, Map<String, dynamic> confronto) {
    final homeTeam = confronto['homeTeam'] as String;
    if (team == homeTeam) return confronto['away'] as int;
    return confronto['home'] as int;
  }
}