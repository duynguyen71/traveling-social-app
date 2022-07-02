import 'package:flutter/cupertino.dart';
import 'package:traveling_social_app/models/group.dart';

import '../services/chat_service.dart';

class ChatRoomViewModel with ChangeNotifier {

  final ChatService _chatService = ChatService();

  bool isLoading = true;

  List<Group> _chatGroups = [];

  getChatGroups() async {
    try {
      _chatGroups = await _chatService.getChatGroups();
    } on Exception catch (e) {
      _chatGroups = [];
      print("Failed to get chat group $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  refresh() async {
    isLoading = true;
    notifyListeners();
    _chatGroups = await _chatService.getChatGroups();
    isLoading = false;
    notifyListeners();
  }

  get chatGroups => _chatGroups;
}
