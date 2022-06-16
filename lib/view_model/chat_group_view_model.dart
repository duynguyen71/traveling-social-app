import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/chat_group_model.dart';

import '../services/chat_service.dart';

class ChatGroupViewModel with ChangeNotifier {

  final ChatService _chatService = ChatService();

  List<ChatGroup> chatGroups = [];

  getChatGroups() async {
    chatGroups = await _chatService.getChatGroups();
    notifyListeners();
  }
}
