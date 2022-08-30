part of 'chat_bloc.dart';

enum ChatGroupStatus { initial, loading, success, failure }

class ChatState extends Equatable {
  final List<Group> chatGroups;
  final List<Group> filtered;
  final ChatGroupStatus status;
  final bool hasReachMax;
  final int page;

  final int pageSize = 10;

  const ChatState(
      {this.chatGroups = const <Group>[],
      this.filtered = const <Group>[],
      this.page = 0,
      this.status = ChatGroupStatus.initial,
      this.hasReachMax = false});

  ChatState copyWith({
    List<Group>? groups,
    List<Group>? filtered,
    ChatGroupStatus? status,
    bool? hasReachMax,
    int? page,
  }) {
    return ChatState(
        chatGroups: groups ?? chatGroups,
        status: status ?? this.status,
        page: page ?? this.page,
        filtered: filtered??this.filtered,
        hasReachMax: hasReachMax ?? this.hasReachMax);
  }

  @override
  List<Object> get props => [chatGroups, status, hasReachMax,filtered];

  @override
  bool get stringify => true;
}
