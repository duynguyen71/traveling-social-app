part of 'application_state_bloc.dart';

enum ApplicationStatus { loading, success, failed, initial }

@immutable
class ApplicationStateState {
  final List<Location> locations;
  final ApplicationStatus status;

  const ApplicationStateState(
      {this.locations = const [], this.status = ApplicationStatus.initial});

  ApplicationStateState copyWith(
      {List<Location>? locations, ApplicationStatus? status}) {
    return ApplicationStateState(
        locations: locations ?? this.locations, status: status ?? this.status);
  }
}
