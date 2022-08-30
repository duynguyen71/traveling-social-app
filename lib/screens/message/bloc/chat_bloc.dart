import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:traveling_social_app/services/user_service.dart';

import '../../../models/group.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserService _chatService = UserService();

  ChatBloc() : super(const ChatState()) {
    on<FetchChatGroup>(_onFetchChatGroup);
    on<FetchMoreChatGroup>(_fetchMoreGroups);
    on<LeaveGroup>(_leaveGroup);
    on<Filter>(_filter);
  }

  _onFetchChatGroup(FetchChatGroup event, Emitter<ChatState> emit) async {
    try {
      //loading
      emit(state.copyWith(status: ChatGroupStatus.loading));
      List<Group> chatGroups = await _fetchChatGroups(page: 0);
      var newPage = state.page + 1;
      return emit(
        state.copyWith(
            groups: chatGroups,
            status: ChatGroupStatus.success,
            filtered: chatGroups,
            page: newPage,
            hasReachMax: chatGroups.isEmpty),
      );
    } catch (_) {
      emit(state.copyWith(status: ChatGroupStatus.failure));
    } finally {}
  }

  _fetchMoreGroups(event, emit) async {
    if (state.hasReachMax) return;
    try {
      emit(state.copyWith(status: ChatGroupStatus.loading));
      var resp = await _fetchChatGroups(page: state.page);
      var copy = [...state.chatGroups];
      copy.addAll(resp);
      var isEmpty = resp.isEmpty;
      emit(state.copyWith(
          status: ChatGroupStatus.success,
          hasReachMax: isEmpty,
          groups: copy,
          filtered: copy,
          page: state.page + 1));
    } catch (_) {
      emit(state.copyWith(status: ChatGroupStatus.failure));
    }
  }

  Future<List<Group>> _fetchChatGroups({int? page}) async {
    List<Group> chatGroups =
        await _chatService.getChatGroups(page: page, pageSize: 10);
    return chatGroups;
  }

  _leaveGroup(LeaveGroup event, emit) async {
    var groupId = event.groupId;
    var success = await _chatService.leaveGroup(groupId: groupId);
    if (success) {
      print('leave group id: ${event.groupId}');
      var copy = [...state.chatGroups];
      copy.removeWhere((element) => element.id == groupId);
      emit(
        state.copyWith(
          groups: [...copy],
          filtered: [...copy],
        ),
      );
    }
  }

  _filter(Filter event, emit) {
    var keyWord = event.keyWord;
    if (keyWord == null || keyWord.isEmpty) {
      emit(state.copyWith(filtered: [...state.chatGroups]));
    } else {
      var copy = [...state.chatGroups];
      var filtered = copy.where((element) =>
          (element.name.toLowerCase().contains(keyWord) ||
              (element.lastMessage != null &&
                  element.lastMessage!.message != null &&
                  element.lastMessage!.message!.contains(keyWord))));
      emit(state.copyWith(filtered: [...filtered]));
    }
  }
}
