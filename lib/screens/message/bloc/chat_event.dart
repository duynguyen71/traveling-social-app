part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class FetchChatGroup extends ChatEvent {
  const FetchChatGroup();

  @override
  List<Object?> get props => [];
}

class FetchMoreChatGroup extends ChatEvent {
  const FetchMoreChatGroup();

  @override
  List<Object?> get props => [];
}

class LeaveGroup extends ChatEvent {
  final int groupId;

  const LeaveGroup(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class Filter extends ChatEvent {
  final String? keyWord;

  const Filter(this.keyWord);

  @override
  List<Object?> get props => [keyWord];
}
