part of 'user_tour_bloc.dart';

enum UserTourStateStatus { loading, success, failed, initial }

class UserTourState extends Equatable {
  final int page;
  final bool hasReachMax;
  final UserTourStateStatus status;
  final Tour? createTour;
  final CurrentUserTour? currentTour;

  final List<BaseTour> tours;

  const UserTourState.initial() : this._();

  const UserTourState._(
      {this.tours = const [],
      this.hasReachMax = false,
      this.createTour,
      this.page = 0,
      this.status = UserTourStateStatus.initial,
      this.currentTour});

  UserTourState copyWith(
      {List<BaseTour>? tours,
      int? page,
      UserTourStateStatus? status,
      Tour? createTour,
      CurrentUserTour? c,
      bool? hasReachMax}) {
    return UserTourState._(
      tours: tours ?? this.tours,
      page: page ?? this.page,
      status: status ?? this.status,
      hasReachMax: hasReachMax ?? this.hasReachMax,
      currentTour: c ,
      createTour: createTour ?? this.createTour,
    );
  }

  @override
  List<Object?> get props => [tours, status, createTour, currentTour];
}
