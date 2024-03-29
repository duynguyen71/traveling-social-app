part of 'story_bloc.dart';

@immutable
abstract class StoryEvent extends Equatable {
  const StoryEvent();
}

@immutable
class FetchStory extends StoryEvent {
  final bool isRefreshing;

  const FetchStory({this.isRefreshing = false});

  @override
  List<Object?> get props => [];
}

@immutable
class UpdateScrollIndex extends StoryEvent {
  final int index;

  const UpdateScrollIndex(this.index);

  @override
  List<Object?> get props => [index];
}

@immutable
class ResetStoryState extends StoryEvent {
  @override
  List<Object?> get props => [];
}

@immutable
class AddStory extends StoryEvent {
  final Post story;

  const AddStory(this.story);

  @override
  List<Object?> get props => [];
}

@immutable
class RemoveStory extends StoryEvent {
  final int id;

  const RemoveStory(this.id);

  @override
  List<Object?> get props => [];
}
