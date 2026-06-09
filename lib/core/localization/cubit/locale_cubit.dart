import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_state.dart';

const String _languageKey = 'LANGUAGE_KEY';

class LocaleCubit extends Cubit<LocaleState> {
  final SharedPreferences sharedPreferences;

  LocaleCubit({required this.sharedPreferences}) : super(const LocaleState(Locale('ar'))) {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final cachedLanguageCode = sharedPreferences.getString(_languageKey);
    if (cachedLanguageCode != null) {
      emit(LocaleState(Locale(cachedLanguageCode)));
    } else {
      // Default to Arabic
      emit(const LocaleState(Locale('ar')));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    await sharedPreferences.setString(_languageKey, languageCode);
    emit(LocaleState(Locale(languageCode)));
  }
}
