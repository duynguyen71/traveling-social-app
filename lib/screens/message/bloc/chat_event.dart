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

// class InitialChatGroup extends ChatEvent {
//   @override
//   List<Object?> get props => [];
// }
