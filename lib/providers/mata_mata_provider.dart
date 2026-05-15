import 'package:flutter/material.dart';

class MataMataProvider extends ChangeNotifier {
  // Slots 1-32 com os times selecionados
  final Map<int, String> _slots = {};

  Map<int, String> get slots => _slots;

  void setSlot(int slot, String time) {
    _slots[slot] = time;
    notifyListeners();
  }

  void removeSlot(int slot) {
    _slots.remove(slot);
    notifyListeners();
  }

  // Slots 1-16 = lado esquerdo
  List<String?> getLadoEsquerdo() {
    return List.generate(8, (i) {
      final slotA = i * 2 + 1;
      final slotB = i * 2 + 2;
      return '${_slots[slotA] ?? '?'} x ${_slots[slotB] ?? '?'}';
    });
  }

  // Slots 17-32 = lado direito
  List<String?> getLadoDireito() {
    return List.generate(8, (i) {
      final slotA = 17 + i * 2;
      final slotB = 18 + i * 2;
      return '${_slots[slotA] ?? '?'} x ${_slots[slotB] ?? '?'}';
    });
  }
}
