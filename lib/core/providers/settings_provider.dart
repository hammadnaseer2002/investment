import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in ProviderScope');
});

class AppSettings {
  final String currency;
  final String measurementUnit;
  final String defaultLocation;

  const AppSettings({
    this.currency = 'PKR',
    this.measurementUnit = 'Marla',
    this.defaultLocation = 'Lahore',
  });

  AppSettings copyWith({
    String? currency,
    String? measurementUnit,
    String? defaultLocation,
  }) {
    return AppSettings(
      currency: currency ?? this.currency,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      defaultLocation: defaultLocation ?? this.defaultLocation,
    );
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends Notifier<AppSettings> {
  static const _currencyKey = 'setting_currency';
  static const _unitKey = 'setting_unit';
  static const _locationKey = 'setting_location';

  late SharedPreferences _prefs;

  @override
  AppSettings build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return AppSettings(
      currency: _prefs.getString(_currencyKey) ?? 'PKR',
      measurementUnit: _prefs.getString(_unitKey) ?? 'Marla',
      defaultLocation: _prefs.getString(_locationKey) ?? 'Lahore',
    );
  }

  Future<void> updateCurrency(String currency) async {
    await _prefs.setString(_currencyKey, currency);
    state = state.copyWith(currency: currency);
  }

  Future<void> updateUnit(String unit) async {
    await _prefs.setString(_unitKey, unit);
    state = state.copyWith(measurementUnit: unit);
  }

  Future<void> updateLocation(String location) async {
    await _prefs.setString(_locationKey, location);
    state = state.copyWith(defaultLocation: location);
  }
}
