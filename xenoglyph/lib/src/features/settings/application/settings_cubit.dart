import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/settings_model.dart';
import '../infrastructure/settings_repository.dart';

class SettingsCubit extends Cubit<SettingsModel> {
  final SettingsRepository repo;
  SettingsCubit(this.repo) : super(const SettingsModel(timerEnabled: true, soundEnabled: true));

  void load() {
    emit(repo.read());
  }

  Future<void> toggleTimer(bool value) async {
    emit(state.copyWith(timerEnabled: value));
    await repo.save(state);
  }

  Future<void> toggleSound(bool value) async {
    emit(state.copyWith(soundEnabled: value));
    await repo.save(state);
  }
}
