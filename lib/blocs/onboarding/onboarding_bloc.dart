import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_dating_app/models/models.dart';
import 'package:flutter_dating_app/models/user_model.dart';

import 'package:flutter_dating_app/repositories/databases/database_repository.dart';
import 'package:flutter_dating_app/repositories/storage/storage_repository.dart';
import 'package:image_picker/image_picker.dart';
part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;

  OnboardingBloc({
    required DatabaseRepository databaseRepository,
    required StorageRepository storageRepository,
  })  : _databaseRepository = databaseRepository,
        _storageRepository = storageRepository,
        super(OnboardingLoading()) {
    on<StartOnboarding>(_onStartOnboarding);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserImages>(_onUpdateUserImages);
  }

  void _onStartOnboarding(
    StartOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    await _databaseRepository.createUser(event.user);
    emit(OnboardingLoaded(user: event.user));
  }

  void _onUpdateUser(
    UpdateUser event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingLoaded) {
      emit(OnboardingLoading()); // Emit OnboardingLoading state
      final currentState = state as OnboardingLoaded;
      final updatedUser = currentState.user.copyWith(gender: event.user.gender);
      await _databaseRepository
          .updateUser(updatedUser); // Wait for the user to be updated
      emit(OnboardingLoaded(user: updatedUser)); // Emit OnboardingLoaded state
    }
  }

  void _onUpdateUserImages(
    UpdateUserImages event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingLoaded) {
      User user = (state as OnboardingLoaded).user;
      await _storageRepository.uploadImage(user, event.image);
      _databaseRepository.getUser(user.uid!).listen((user) {
        add(UpdateUser(user: user));
      });
    }
  }
}
