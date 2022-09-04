part of 'application_state_bloc.dart';

@immutable
abstract class ApplicationStateEvent {
  const ApplicationStateEvent();
}

class ForwardLocationEvent extends ApplicationStateEvent {
  final String query;

  const ForwardLocationEvent(this.query) : super();
}
class SelectLocationEvent extends ApplicationStateEvent {
  final Location? location;

  const SelectLocationEvent(this.location) : super();
}

class GetCurrentLocationEvent extends ApplicationStateEvent {
  const GetCurrentLocationEvent() : super();
}

class ReverseLocationEvent extends ApplicationStateEvent {
  final double latitude;
  final double longitude;

  const ReverseLocationEvent({required this.latitude, required this.longitude});
}

class ClearLocationDataEvent extends ApplicationStateEvent{
  const ClearLocationDataEvent();
}