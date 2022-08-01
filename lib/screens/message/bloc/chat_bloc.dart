import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:traveling_social_app/services/chat_service.dart';

import '../../../constants/api_constants.dart';
import '../../../models/group.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService = ChatService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late StompClient _stompClient;

  ChatBloc() : super(const ChatState()) {
    on<FetchChatGroup>(_onFetchPost);
    on<InitialChatGroup>(
      (event, emit) {
        emit(const ChatState(
            hasReachMax: false,
            status: ChatGroupStatus.initial,
            chatGroups: []));
      },
    );
  }

  _onFetchPost(ChatEvent event, Emitter<ChatState> emit) async {
    if (state.hasReachMax) return;
    try {
      //loading
      if (state.status == ChatGroupStatus.initial) {
        emit(state.copyWith(status: ChatGroupStatus.loading));
        //client
        // _stompClient = StompClient(
        //   config: StompConfig(
        //     url: kSocketUrl,
        //     stompConnectHeaders: {
        //       "Authorization":
        //           'Bearer ${await _storage.read(key: 'accessToken')}'
        //     },
        //     onConnect: (StompFrame frame) {
        //       _stompClient.subscribe(
        //           destination: "/users/{userId}/messages",
        //           callback: (StompFrame frame) {
        //             if (frame.body != null) {
        //               print(jsonDecode(frame.body!));
        //             }
        //           });
        //     },
        //     onWebSocketError: (_) {
        //       print('failed connect web socket channel on chat bloc $_');
        //     },
        //   ),
        // );
        // _stompClient.activate();
        //client
        //fetch chat groups
        List<Group> chatGroups = await _fetchChatGroups();
        return emit(state.copyWith(
            groups: chatGroups, status: ChatGroupStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: ChatGroupStatus.failure));
    } finally {
      emit(state.copyWith(status: ChatGroupStatus.success));
    }
  }

  // dispose()async{
  // emit(state.copyWith(status: ChatGroupStatus.failure));
  // emit(const ChatState(chatGroups: [],hasReachMax: false,status: ChatGroupStatus.initial));
  // }

  _fetchChatGroups() async {
    List<Group> chatGroups = await _chatService.getChatGroups();
    return chatGroups;
  }
}
