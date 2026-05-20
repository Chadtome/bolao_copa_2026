
import '../providers/resultados_provider.dart';
import '../services/group_classifier.dart';
import 'group_phase_games.dart';

class ClassifiedTeams {
  /// Retorna todos os 1º, 2º e 8 melhores 3º colocados REAIS
  static List<String> getAllClassified(ResultadosProvider resultados) {
    final firsts = getFirstPlaces(resultados);
    final seconds = getSecondPlaces(resultados);
    final bestThirds = getBestThirds(resultados);
    return [...firsts, ...seconds, ...bestThirds];
  }

  static List<String> getFirstPlaces(ResultadosProvider resultados) {
    final firsts = <String>[];
    for (int i = 0; i < 12; i++) {
      final teams = _getClassifiedTeams(i, resultados);
      firsts.add(teams[0]);
    }
    return firsts;
  }

  static List<String> getSecondPlaces(ResultadosProvider resultados) {
    final seconds = <String>[];
    for (int i = 0; i < 12; i++) {
      final teams = _getClassifiedTeams(i, resultados);
      seconds.add(teams[1]);
    }
    return seconds;
  }

  static List<String> getBestThirds(ResultadosProvider resultados) {
    // Pega todos os 3º colocados com seus dados
    final allThirds = <Map<String, dynamic>>[];
    for (int i = 0; i < 12; i++) {
      final teams = _getClassifiedTeams(i, resultados);
      final thirdTeam = teams[2];
      
      // Calcula dados do 3º colocado
      final data = _getTeamData(thirdTeam, i, resultados);
      allThirds.add({'time': thirdTeam, ...data});
    }

    // Ordena por pontos, saldo, gols
    allThirds.sort((a, b) {
      if (a['P'] != b['P']) return (b['P'] as int).compareTo(a['P'] as int);
      if (a['SG'] != b['SG']) return (b['SG'] as int).compareTo(a['SG'] as int);
      return (b['GP'] as int).compareTo(a['GP'] as int);
    });

    // Retorna os 8 melhores
    return allThirds.take(8).map((t) => t['time'] as String).toList();
  }

  static List<String> _getClassifiedTeams(int groupIndex, ResultadosProvider resultados) {
    final group = GroupPhaseGames.groups[groupIndex];
    final games = group['games'] as List;

    final resultadosMap = <String, Map<String, dynamic>>{};
    for (var game in games) {
      final r = resultados.getResultadoGrupo(game['homeTeam'], game['awayTeam']);
      if (r != null) {
        resultadosMap['${game['homeTeam']}_${game['awayTeam']}'] = r;
      }
    }

    final classifier = GroupClassifier(resultadosMap);
    return classifier.classificar(groupIndex);
  }

  static Map<String, int> _getTeamData(String team, int groupIndex, ResultadosProvider resultados) {
    int pontos = 0, jogos = 0, vitorias = 0, empates = 0, derrotas = 0, gp = 0, gc = 0;

    final group = GroupPhaseGames.groups[groupIndex];
    final games = group['games'] as List;

    for (var game in games) {
      final r = resultados.getResultadoGrupo(game['homeTeam'], game['awayTeam']);
      if (r == null) continue;

      final home = (r['home'] as num).toInt();
      final away = (r['away'] as num).toInt();

      if (game['homeTeam'] == team) {
        jogos++; gp += home; gc += away;
        if (home > away) { pontos += 3; vitorias++; }
        else if (home == away) { pontos += 1; empates++; }
        else derrotas++;
      } else if (game['awayTeam'] == team) {
        jogos++; gp += away; gc += home;
        if (away > home) { pontos += 3; vitorias++; }
        else if (home == away) { pontos += 1; empates++; }
        else derrotas++;
      }
    }

    return {'P': pontos, 'J': jogos, 'V': vitorias, 'E': empates, 'D': derrotas, 'GP': gp, 'GC': gc, 'SG': gp - gc};
  }
}