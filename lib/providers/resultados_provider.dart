// import 'package:flutter/material.dart';

// class ResultadosProvider extends ChangeNotifier {
//   // Resultados: chave = "slotA_slotB" -> {'home': placarA, 'away': placarB}
//   final Map<String, Map<String, int>> _resultados = {};

//   void setResultado(int slotA, int slotB, int homeScore, int awayScore) {
//     final key = '${slotA}_$slotB';
//     _resultados[key] = {'home': homeScore, 'away': awayScore};
//     notifyListeners();
//   }

//   Map<String, int>? getResultado(int slotA, int slotB) {
//     final key = '${slotA}_$slotB';
//     return _resultados[key];
//   }

//   String? getVencedor(int slotA, int slotB, Map<int, String> slots) {
//     final r = getResultado(slotA, slotB);
//     if (r == null) return null;
//     if (r['home']! > r['away']!) return slots[slotA];
//     if (r['away']! > r['home']!) return slots[slotB];
//     return null;
//   }
// }

import 'package:flutter/material.dart';

class ResultadosProvider extends ChangeNotifier {
  final Map<String, Map<String, int>> _resultados = {};
  final Map<int, String> _avancos = {};

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
}
