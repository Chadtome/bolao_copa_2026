import 'package:flutter/material.dart';

class ResultadosProvider extends ChangeNotifier {
  // Mata-mata: slots numéricos
  final Map<String, Map<String, int>> _resultados = {};
  final Map<int, String> _avancos = {};

  // Fase de grupos: chave "homeTeam_awayTeam"
  final Map<String, Map<String, dynamic>> _resultadosGrupos = {};

  // ========== MATA-MATA ==========
  void setResultado(int slotA, int slotB, int homeScore, int awayScore) {
    final key = '${slotA}_$slotB';
    _resultados[key] = {'home': homeScore, 'away': awayScore};
    notifyListeners();
  }

  Map<String, int>? getResultado(int slotA, int slotB) {
    final key = '${slotA}_$slotB';
    return _resultados[key];
  }

  void setAvancou(int slotDestino, String time) {
    _avancos[slotDestino] = time;
    notifyListeners();
  }

  String? getTime(int slot) {
    return _avancos[slot];
  }

  // ========== FASE DE GRUPOS ==========
  void setResultadoGrupo(String homeTeam, String awayTeam, int homeScore, int awayScore) {
    final key = '${homeTeam}_$awayTeam';
    _resultadosGrupos[key] = {
      'home': homeScore,
      'away': awayScore,
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
    };
    notifyListeners();
  }

  Map<String, dynamic>? getResultadoGrupo(String homeTeam, String awayTeam) {
    final key = '${homeTeam}_$awayTeam';
    return _resultadosGrupos[key];
  }

  Map<String, Map<String, dynamic>> get todosResultadosGrupos => _resultadosGrupos;
}