import 'package:flutter/material.dart';

class PalpitesProvider extends ChangeNotifier {
  final Map<String, Map<String, int>> _palpites = {};

  Map<String, Map<String, int>> get palpites => _palpites;

  void setPalpite(String gameId, int home, int away) {
    _palpites[gameId] = {'home': home, 'away': away};
    notifyListeners();
  }

  void removePalpite(String gameId) {
    _palpites.remove(gameId);
    notifyListeners();
  }

  void carregarDoFirebase(List<Map<String, dynamic>> bets) {
    for (var bet in bets) {
      _palpites[bet['gameId']] = {'home': bet['homeBet'], 'away': bet['awayBet']};
    }
    notifyListeners();
  }

  void limpar() {
    _palpites.clear();
    notifyListeners();
  }
}