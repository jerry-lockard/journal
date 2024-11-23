import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../services/settings_service.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<void>>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  return SettingsNotifier(settingsService, ref);
});

class SettingsNotifier extends StateNotifier<AsyncValue<void>> {
  final SettingsService _settingsService;
  final Ref _ref;

  SettingsNotifier(this._settingsService, this._ref) : super(const AsyncValue.data(null));

  Future<void> logout() async {
    try {
      state = const AsyncValue.loading();
      await _ref.read(authProvider.notifier).signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}