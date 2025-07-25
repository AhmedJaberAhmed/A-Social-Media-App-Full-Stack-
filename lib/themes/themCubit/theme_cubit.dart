import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../dark_mode.dart';
import '../light_mode.dart';

class ThemeCubit extends Cubit<ThemeData> {
  bool _isDarkMode = false;

  ThemeCubit() : super(lightMode);

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    if (_isDarkMode) {
      emit(darkMode);
    } else {
      emit(lightMode);
    }
  }
}