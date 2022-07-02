import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_event.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_state.dart';
import 'package:traveling_social_app/repository/authentication_repository/user.dart';

import '../../repository/authentication_repository/authentication_repository.dart';
import '../../repository/user_repository/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    //handle authentication status change
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    //handle logout request
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    //handle user info on change
    on<UserInfoChanged>(_onUserInfoChange);
    //listen for authentication status changed
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  @override
  void onChange(Change<AuthenticationState> change) {
    super.onChange(change);
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  // handle authentication status changed
  _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        return emit(user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated());
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  //handle user info change [avt,backgroundImage,bio]
  _onUserInfoChange(
      UserInfoChanged event, Emitter<AuthenticationState> emit) async {
    final user = await _tryGetUser();
    return emit(user != null
        ? AuthenticationState.userInfoChanged(user)
        : const AuthenticationState.unauthenticated());
  }

  //handle user logout
  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
  }

  //try get user
  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }
}
