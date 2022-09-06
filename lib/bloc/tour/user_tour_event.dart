part of 'user_tour_bloc.dart';

@immutable
abstract class UserTourEvent {
  const UserTourEvent();
}

class InitialTourEvent extends UserTourEvent {}

class FetchTourEvent extends UserTourEvent {}

class CloseTourEvent extends UserTourEvent {}

class AcceptRequestEvent extends UserTourEvent {}

class RejectRequestEvent extends UserTourEvent {}

class UpdateEditingTourEvent extends UserTourEvent {
  final Tour tour;

  const UpdateEditingTourEvent(this.tour);
}

class UpdateTourRequestEvent extends UserTourEvent {
  final int id;

  const UpdateTourRequestEvent(this.id);
}

class GetCurrentTourEvent extends UserTourEvent {
  const GetCurrentTourEvent();
}

class UpdateCurrentUserTour extends UserTourEvent {
  final CurrentUserTour currentUserTour;

  const UpdateCurrentUserTour(this.currentUserTour);
}

class RejectUser extends UserTourEvent {
  final int rejectTourUserId;

  const RejectUser(this.rejectTourUserId);
}

class AcceptTourUserEvent extends UserTourEvent {
  final TourUser tourUser;

  const AcceptTourUserEvent(this.tourUser);
}
