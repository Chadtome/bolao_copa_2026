import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultadosProvider extends ChangeNotifier {
  final Map<String, Map<String, int>> _resultados = {};
  final Map<int, String> _avancos = {};
  final Map<String, Map<String, dynamic>> _resultadosGrupos = {};

  // ========== MATA-MATA ==========
  void setResultado(int slotA, int slotB, int homeScore, int awayScore) {
    final key = '${slotA}_$slotB';
    _resultados[key] = {'home': homeScore, 'away': awayScore};
    _salvarNoFirestore();
    notifyListeners();
  }

  Map<String, int>? getResultado(int slotA, int slotB) {
    final key = '${slotA}_$slotB';
    return _resultados[key];
  }

  void setAvancou(int slotDestino, String time) {
    _avancos[slotDestino] = time;
    _salvarNoFirestore();
    notifyListeners();
  }

  String? getTime(int slot) => _avancos[slot];

  // ========== FASE DE GRUPOS ==========
  void setResultadoGrupo(String homeTeam, String awayTeam, int homeScore, int awayScore) {
    final key = '${homeTeam}_$awayTeam';
    _resultadosGrupos[key] = {'home': homeScore, 'away': awayScore, 'homeTeam': homeTeam, 'awayTeam': awayTeam};
    _salvarNoFirestore();
    notifyListeners();
  }

  Map<String, dynamic>? getResultadoGrupo(String homeTeam, String awayTeam) {
    final key = '${homeTeam}_$awayTeam';
    return _resultadosGrupos[key];
  }

  Map<String, Map<String, dynamic>> get todosResultadosGrupos => _resultadosGrupos;

  // ========== FIREBASE ==========
  Future<void> _salvarNoFirestore() async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      _resultadosGrupos.forEach((key, value) {
        batch.set(FirebaseFirestore.instance.collection('resultados').doc(key), value, SetOptions(merge: true));
      });
      _resultados.forEach((key, value) {
        batch.set(FirebaseFirestore.instance.collection('resultados').doc('slot_$key'), value, SetOptions(merge: true));
      });
      final avancosData = <String, String>{};
      _avancos.forEach((key, value) => avancosData['slot_$key'] = value);
      if (avancosData.isNotEmpty) {
        batch.set(FirebaseFirestore.instance.collection('resultados').doc('avancos'), avancosData, SetOptions(merge: true));
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Erro ao salvar resultados: $e');
    }
  }

  Future<void> carregarDoFirestore() async {
  try {
    _resultados.clear();
    _resultadosGrupos.clear();
    _avancos.clear();

    final snapshot = await FirebaseFirestore.instance.collection('resultados').get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (doc.id.startsWith('slot_')) {
        final key = doc.id.replaceAll('slot_', '');
        _resultados[key] = Map<String, int>.from(data.map((k, v) => MapEntry(k, (v as num).toInt())));
      } else if (doc.id == 'avancos') {
        data.forEach((k, v) {
          if (k.startsWith('slot_')) {
            _avancos[int.parse(k.replaceAll('slot_', ''))] = v as String;
          }
        });
      } else {
        _resultadosGrupos[doc.id] = data.map((k, v) => MapEntry(k, v));
      }
    }
    notifyListeners();
  } catch (e) {
    debugPrint('Erro ao carregar resultados: $e');
  }
}

  // Future<void> carregarDoFirestore() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance.collection('resultados').get();
  //     for (var doc in snapshot.docs) {
  //       final data = doc.data();
  //       if (doc.id.startsWith('slot_')) {
  //         final key = doc.id.replaceAll('slot_', '');
  //         _resultados[key] = Map<String, int>.from(data.map((k, v) => MapEntry(k, (v as num).toInt())));
  //       } else if (doc.id == 'avancos') {
  //         data.forEach((k, v) {
  //           if (k.startsWith('slot_')) {
  //             _avancos[int.parse(k.replaceAll('slot_', ''))] = v as String;
  //           }
  //         });
  //       } else {
  //         _resultadosGrupos[doc.id] = data.map((k, v) => MapEntry(k, v));
  //       }
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('Erro ao carregar resultados: $e');
  //   }
  // }
}