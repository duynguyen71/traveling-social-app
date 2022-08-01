part of 'story_bloc.dart';

abstract class StoryState extends Equatable {
  const StoryState();
}

class StoryInitial extends StoryState {
  @override
  List<Object> get props => [];
}
