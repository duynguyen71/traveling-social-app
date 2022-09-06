import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:traveling_social_app/models/base_tour.dart';
import 'package:traveling_social_app/services/post_service.dart';
import 'package:traveling_social_app/widgets/tour.dart';

import '../../models/current_user_tour.dart';
import '../../models/tour_user.dart';

part 'user_tour_event.dart';

part 'user_tour_state.dart';

class UserTourBloc extends Bloc<UserTourEvent, UserTourState> {
  final _postService = PostService();

  UserTourBloc() : super(const UserTourState.initial()) {
    on<UserTourEvent>((UserTourEvent event, emit) async {
      if (state.status == UserTourStateStatus.loading) {
        return;
      }
      if (event is InitialTourEvent) {
        print("INIT TOUR");
        emit(state.copyWith(status: UserTourStateStatus.loading));
        var tours = await _postService.getCurrentUserTours(page: 0);
        print(tours.length);
        emit(state.copyWith(
            hasReachMax: false,
            page: 0,
            tours: tours,
            status: UserTourStateStatus.success));
      } else if (event is FetchTourEvent) {
        print("FETCH TOUR");
        emit(state.copyWith(status: UserTourStateStatus.loading));
        var tours = await _postService.getCurrentUserTours(page: state.page);
        emit(state.copyWith(
            status: UserTourStateStatus.success,
            tours: tours,
            page: state.page + 1,
            hasReachMax: tours.isEmpty));
      } else if (event is UpdateEditingTourEvent) {
        emit(state.copyWith(createTour: event.tour));
      } else if (event is UpdateTourRequestEvent) {
        emit(state.copyWith(status: UserTourStateStatus.loading));
        var id = event.id;
        var tour = await _postService.getMyTourDetail(id);
        emit(state.copyWith(
            createTour: tour, status: UserTourStateStatus.success));
      } else if (event is GetCurrentTourEvent) {
        print('get current user tour');
        emit(state.copyWith(status: UserTourStateStatus.loading));
        final currentTour = await _postService.getCurrentTour();
        print('current tour ${currentTour}');
        emit(state.copyWith(
            c: currentTour,
            status: UserTourStateStatus.success,
            createTour: Tour.empty()));
      } else if (event is UpdateCurrentUserTour) {
        final newTour = event.currentUserTour;
        emit(state.copyWith(c: newTour));
      } else if (event is RejectUser) {
        var currentTour = state.currentTour;
        var rejectTourUserId = event.rejectTourUserId;
        if (currentTour != null) {
          var joinedMembers = [...currentTour.tourUsers];
          List<TourUser> newJoinedMembers = joinedMembers
              .where((element) => element.id != rejectTourUserId)
              .toList();
          var numOfRequest = currentTour!.numOfRequest ?? 0;
          emit(state.copyWith(
              c: currentTour.copyWith(
                  numOfRequest: numOfRequest <= 0 ? 0 : (numOfRequest - 1),
                  tourUsers: newJoinedMembers)));
        } // filtered = copy;

      } else if (event is AcceptTourUserEvent) {
        var currentTour = state.currentTour;
        var tourUser = event.tourUser;
        var joinedMembers = [...?currentTour?.tourUsers];
        var numOfRequest = currentTour?.numOfRequest ?? 1;
        joinedMembers.add(tourUser);
        emit(state.copyWith(
            c: currentTour?.copyWith(
                numOfRequest: numOfRequest <= 0 ? 0 : (numOfRequest - 1),
                tourUsers: joinedMembers)));
      } else if (event is CloseCurrentTour) {
        _postService.closeTour(event.id);
        emit(state.copyWith(createTour: Tour.empty()));
      } else if (event is CompleteTourEvent) {
        _postService.complete(event.id);
        emit(state.copyWith(createTour: Tour.empty()));
      } else if (event is LeaveTour) {
        var currentTour = state.currentTour;
        if (currentTour != null) {
          await _postService.leave(currentTour.id!);
          emit(state.copyWith(createTour: Tour.empty(), c: null));
        }
      }
    });
  }
}
