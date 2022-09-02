part of 'application_state_bloc.dart';

@immutable
abstract class ApplicationStateEvent {
  const ApplicationStateEvent();
}

class ForwardLocationEvent extends ApplicationStateEvent {
  final String query;

  const ForwardLocationEvent(this.query) : super();
}
