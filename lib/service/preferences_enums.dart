enum StringPreferencesKey { def }

extension PreferencesKeyExtension on StringPreferencesKey {
  String get name {
    switch (this) {
      case StringPreferencesKey.def:
        return 'def';
    }
  }

  String get defaultValue {
    switch (this) {
      case StringPreferencesKey.def:
        return 'def';
    }
  }
}

enum BoolPreferencesKey {
  shutdownEnabled,
  shutdownNegativesWillBeClosed,
  shutdownNeutralsWillConsume,
}

extension BoolPreferencesKeyExtension on BoolPreferencesKey {
  String get name {
    switch (this) {
      case BoolPreferencesKey.shutdownEnabled:
        return 'isShutdownEnabled';
      case BoolPreferencesKey.shutdownNegativesWillBeClosed:
        return 'shutdownNegativesWillBeClosed';
      case BoolPreferencesKey.shutdownNeutralsWillConsume:
        return 'shutdownNEutralsWillConsume';
    }
  }

  bool get defaultValue {
    switch (this) {
      case BoolPreferencesKey.shutdownEnabled:
        return false;
      case BoolPreferencesKey.shutdownNegativesWillBeClosed:
        return true;
      case BoolPreferencesKey.shutdownNeutralsWillConsume:
        return false;
    }
  }
}
