part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class FetchChatGroup extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class InitialChatGroup extends ChatEvent {
  @override
  List<Object?> get props => [];
}
