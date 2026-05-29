import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MataMataProvider extends ChangeNotifier {
  final Map<int, String> _slots = {};

  Map<int, String> get slots => _slots;

  void setSlot(int slot, String time) {
    _slots[slot] = time;
    _salvarNoFirestore();
    notifyListeners();
  }

  void removeSlot(int slot) {
    _slots.remove(slot);
    notifyListeners();
  }

  List<String?> getLadoEsquerdo() {
    return List.generate(8, (i) {
      final slotA = i * 2 + 1;
      final slotB = i * 2 + 2;
      return '${_slots[slotA] ?? '?'} x ${_slots[slotB] ?? '?'}';
    });
  }

  List<String?> getLadoDireito() {
    return List.generate(8, (i) {
      final slotA = 17 + i * 2;
      final slotB = 18 + i * 2;
      return '${_slots[slotA] ?? '?'} x ${_slots[slotB] ?? '?'}';
    });
  }

  // ========== FIREBASE ==========
  Future<void> _salvarNoFirestore() async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      _slots.forEach((key, value) {
        batch.set(
          FirebaseFirestore.instance.collection('mata_mata').doc('slot_$key'),
          {'time': value},
          SetOptions(merge: true),
        );
      });
      await batch.commit();
    } catch (e) {
      debugPrint('Erro ao salvar mata-mata: $e');
    }
  }

  Future<void> carregarDoFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('mata_mata').get();
      _slots.clear();
      for (var doc in snapshot.docs) {
        final key = int.parse(doc.id.replaceAll('slot_', ''));
        _slots[key] = doc['time'] as String;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar mata-mata: $e');
    }
  }
}