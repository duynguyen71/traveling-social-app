import 'package:equatable/equatable.dart';

import '../../repository/authentication_repository/authentication_repository.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}

class UserInfoChanged extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
