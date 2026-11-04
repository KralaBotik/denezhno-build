enum AppTheme { system, light, dark }

/// The only storage interface needed by the R1 application layer.
abstract interface class PreferencesStore {
  Future<AppTheme> open();
  Future<void> setTheme(AppTheme theme);
  Future<void> close();
}
