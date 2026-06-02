import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isLoading => _isLoading;

  UserProvider() {
    _checkAuthState();
  }

  void _checkAuthState() {
  print('🔄 LISTENER DO AUTH INICIADO');
  
  FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {
    print('📢 USUÁRIO MUDOU: ${firebaseUser?.email ?? "NULO"}');
    
    if (firebaseUser != null) {
      _isLoading = true;
      notifyListeners();
      
      try {
        final firebaseService = FirebaseService();
        final userModel = await firebaseService.getCurrentUserData();
        print('✅ USUÁRIO CARREGADO: ${userModel?.name}');
        _user = userModel;
      } catch (e) {
        print('❌ ERRO: $e');
        _user = null;
      }
      
      _isLoading = false;
      notifyListeners();
    } else {
      print('❌ USUÁRIO NULO - DESLOGADO');
      _user = null;
      _isLoading = false;
      notifyListeners();
    }
  });
}

  // void _checkAuthState() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {
  //     if (firebaseUser != null) {
  //       _isLoading = true;
  //       notifyListeners();
        
  //       try {
  //         final firebaseService = FirebaseService();
  //         final userModel = await firebaseService.getCurrentUserData();
  //         _user = userModel;
  //       } catch (e) {
  //         _user = null;
  //       }
        
  //       _isLoading = false;
  //       notifyListeners();
  //     } else {
  //       _user = null;
  //       _isLoading = false;
  //       notifyListeners();
  //     }
  //   });
  // }

  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}