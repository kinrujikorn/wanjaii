import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dating_app/models/models.dart';
import 'package:flutter_dating_app/screens/home/home_no_bloc.dart';
import 'package:flutter_dating_app/screens/screens.dart';
import 'package:flutter_dating_app/screens/user/edit_profile.dart';
import 'package:flutter_dating_app/services/auth_service.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('The Route is: ${settings.name}');

    switch (settings.name) {
      case '/':
        return HomeScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();

      case HomeScreen.routeName:
        return HomeScreen.route();
      case MatchesScreen.routeName:
        return MatchesScreen.route();

      case UserScreen.routeName:
        return UserScreen.route();
      case EditProfileScreen.routeName:
        return EditProfileScreen.route();
      case ChatScreen.routeName:
        return ChatScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: Text('error'))),
      settings: RouteSettings(name: '/error'),
    );
  }
}
