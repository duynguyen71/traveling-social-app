part of 'chat_bloc.dart';

enum ChatGroupStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  final List<Group> chatGroups;
  final ChatGroupStatus status;
  final bool hasReachMax;

  const ChatState(
      {this.chatGroups = const <Group>[],
      this.status = ChatGroupStatus.initial,
      this.hasReachMax = false});

  ChatState copyWith(
      {List<Group>? groups, ChatGroupStatus? status, bool? hasReachMax}) {
    return ChatState(
        chatGroups: groups ?? chatGroups,
        status: status ?? this.status,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }

  @override
  List<Object> get props => [chatGroups, status, hasReachMax];

  @override
  bool get stringify {
    return true;
  }
}
