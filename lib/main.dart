import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dating_app/repositories/auth/auth_repository.dart';
import 'package:flutter_dating_app/repositories/user_repository.dart';
import 'blocs/onboarding/onboarding_bloc.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dating_app/config/app_router.dart';
import 'package:flutter_dating_app/config/theme.dart';
import 'package:flutter_dating_app/screens/screens.dart';
import 'repositories/databases/database_repository.dart';
import 'repositories/storage/storage_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository(); // Create user repository instance

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OnboardingBloc>(
            create: (_) => OnboardingBloc(
              databaseRepository: DatabaseRepository(),
              storageRepository: StorageRepository(),
            )..add(
                StartOnboarding(),
              ),
          ),
        ],
        child: MaterialApp(
          title: 'Dating App',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}
