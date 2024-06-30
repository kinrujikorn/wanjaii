import 'package:equatable/equatable.dart';

import 'models.dart';

class UserMatch extends Equatable {
  final int id;
  final int userId;
  final User matchUser;
  //final List<Chat>? chat;

  const UserMatch(
      {required this.id, required this.userId, required this.matchUser});

  @override
  List<Object?> get props => [id, userId, matchUser];
}
