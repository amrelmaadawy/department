import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'app_theme_mode';

  ThemeCubit({required this.sharedPreferences}) : super(const ThemeState(ThemeMode.system)) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeString = sharedPreferences.getString(_themeKey);
    if (themeString != null) {
      if (themeString == 'light') {
        emit(const ThemeState(ThemeMode.light));
      } else if (themeString == 'dark') {
        emit(const ThemeState(ThemeMode.dark));
      } else {
        emit(const ThemeState(ThemeMode.system));
      }
    }
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    String themeString = 'system';
    if (themeMode == ThemeMode.light) {
      themeString = 'light';
    } else if (themeMode == ThemeMode.dark) {
      themeString = 'dark';
    }

    await sharedPreferences.setString(_themeKey, themeString);
    emit(ThemeState(themeMode));
  }
}
