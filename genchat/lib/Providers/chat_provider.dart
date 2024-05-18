import 'package:flutter/foundation.dart';
import 'package:genchat/Client/client.dart';
import 'package:genchat/Models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  static final ChatProvider _chatProvider = ChatProvider._internal();
  ChatProvider._internal();

  factory ChatProvider() {
    return _chatProvider;
  }

  bool loading = false;
  List<Message> chatLog = [Message("Hello! Welcome to the future..", false)];
  String? errorMessage;
  int? lastIndex;

  void receiveChat(String message) {
    loading = false;
    chatLog.add(Message(message, false));
    notifyListeners();
  }

  Future<void> sendChat(String message) async {
    loading = true;
    notifyListeners();
    try {
      chatLog.add(Message(message, true));
      client.writeln(message);
      notifyListeners();
    } catch (error) {
      errorMessage = 'Error: $error';
      notifyListeners();
    }
  }
}
