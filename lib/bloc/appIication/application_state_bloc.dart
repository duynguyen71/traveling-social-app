import 'dart:async';

import 'package:bloc/bloc.dart';

// import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import '../../models/location.dart';
import '../../services/location_service.dart';

part 'application_state_event.dart';

part 'application_state_state.dart';

class ApplicationStateBloc
    extends Bloc<ApplicationStateEvent, ApplicationStateState> {
  final _locationService = LocationService();

  ApplicationStateBloc() : super(const ApplicationStateState()) {
    //
    on<ForwardLocationEvent>((ForwardLocationEvent event, emit) async {
      emit(state.copyWith(status: ApplicationStatus.loading));
      var query = event.query;
      var locations = await _locationService.forward(query: query);
      emit(ApplicationStateState(
          locations: locations, status: ApplicationStatus.success));
    });

    /// get current user position
    on<GetCurrentLocationEvent>((GetCurrentLocationEvent event, emit) async {
      try {
        emit(state.copyWith(status: ApplicationStatus.loading));
        await _locationService.checkLocationPermission();
        var position = await Geolocator.getCurrentPosition();
        var locations = await _locationService.reverse(
            latitude: position.latitude, longitude: position.longitude);
        var location = locations[0];
        print('current user pos ${location}');
        emit(state.copyWith(
            currentLocation: location, status: ApplicationStatus.success));
      } catch (e) {
        print('Failed to get current user position $e');
      }
    });

    /// reverse Point to Location
    on<ReverseLocationEvent>((ReverseLocationEvent event, emit) async {
      try {
        emit(state.copyWith(status: ApplicationStatus.loading));
        var longitude = event.longitude;
        var latitude = event.latitude;
        List<Location> reverseLocations =
            await _reverseLoc(latitude, longitude);
        print(reverseLocations);
        emit(
          state.copyWith(
            locations: reverseLocations,
            status: ApplicationStatus.success,
          ),
        );
      } catch (e) {
        print('Failed to reverse position $e');
      }
    });

    /// reverse Location to Point
    on<SelectLocationEvent>((SelectLocationEvent event, emit) async {
      var loc = event.location;
      emit(state.copyWith(selectedLocation: loc));
    });
    on<ClearLocationDataEvent>((ClearLocationDataEvent event, emit) async {
      emit(ApplicationStateState(
          selectedLocation: null,
          status: ApplicationStatus.initial,
          locations: state.locations,
          currentLocation: state.currentLocation));
    });

    ///
  }

  Future<List<Location>> _reverseLoc(double latitude, double longitude) async {
    var reverseLocations = await _locationService.reverse(
        latitude: latitude, longitude: longitude);
    return reverseLocations;
  }
}
