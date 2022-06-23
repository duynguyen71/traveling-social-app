import 'package:equatable/equatable.dart';
import 'package:traveling_social_app/repository/authentication_repository/authentication_repository.dart';
import 'package:traveling_social_app/repository/authentication_repository/user.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final User user;

  const AuthenticationState._(
      {this.status = AuthenticationStatus.unknown,
      this.user = User.empty});

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.userInfoChanged(User user)
      : this._(user: user);

  @override
  List<Object?> get props => [user, status];
}
