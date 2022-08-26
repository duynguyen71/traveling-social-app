import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:traveling_social_app/services/chat_service.dart';
import 'package:traveling_social_app/services/user_service.dart';

import '../../../constants/api_constants.dart';
import '../../../models/group.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final UserService _chatService = UserService();

  ChatBloc() : super(const ChatState()) {
    on<FetchChatGroup>(_onFetchChatGroup);
    on<FetchMoreChatGroup>(_fetchMoreGroups);
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
      print('get chat group ${resp.length}');
      var copy = [...state.chatGroups];
      copy.addAll(resp);
      var isEmpty = resp.isEmpty;
      emit(state.copyWith(
          status: ChatGroupStatus.success,
          hasReachMax: isEmpty,
          groups: copy,
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
}
