part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class StartOnboarding extends OnboardingEvent {
  final User user;
  StartOnboarding({
    this.user = const User(
      uid: '',
      name: '',
      age: 0,
      gender: '',
      imageUrls: '',
      jobTitle: '',
      interests: [],
      bio: '',
      city: '',
      country: '',
      state: '',
      profileAbout: '',
      email: '',
      dob: '',
      phoneNumber: '',
      language: '',
    ),
  });

  @override
  List<Object?> get props => [user];
}

class UpdateUser extends OnboardingEvent {
  final User user;

  const UpdateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserImages extends OnboardingEvent {
  final User? user;
  final XFile image;

  UpdateUserImages({this.user, required this.image});

  @override
  List<Object?> get props => [user, image];
}
