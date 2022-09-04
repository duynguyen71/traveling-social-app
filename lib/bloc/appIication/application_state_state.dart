part of 'application_state_bloc.dart';

enum ApplicationStatus { loading, success, failed, initial }

@immutable
class ApplicationStateState {
  final Location? currentLocation;
  final Location? selectedLocation;
  final List<Location> locations;
  final ApplicationStatus status;

  const ApplicationStateState(
      {this.locations = const [],
      this.status = ApplicationStatus.initial,
      this.currentLocation,
      this.selectedLocation});

  ApplicationStateState copyWith({
    List<Location>? locations,
    ApplicationStatus? status,
    Location? currentLocation,
    Location? selectedLocation,
  }) {
    return ApplicationStateState(
        locations: locations ?? this.locations,
        status: status ?? this.status,
        selectedLocation: selectedLocation ?? this.selectedLocation,
        currentLocation: currentLocation ?? this.currentLocation);
  }
}
