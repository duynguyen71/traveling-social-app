import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/location.dart';
import '../../services/location_service.dart';

part 'application_state_event.dart';

part 'application_state_state.dart';

class ApplicationStateBloc
    extends Bloc<ApplicationStateEvent, ApplicationStateState> {
  final _locationService = LocationService();

  ApplicationStateBloc() : super(const ApplicationStateState()) {
    on<ForwardLocationEvent>((ForwardLocationEvent event, emit) async {
      emit(state.copyWith(status: ApplicationStatus.loading));
      var query = event.query;
      var locations = await _locationService.forwardLocation(query: query);
      emit(ApplicationStateState(
          locations: locations, status: ApplicationStatus.success));
    });
  }
}
