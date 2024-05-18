import 'dart:io';

import 'package:flutter/material.dart';
import 'package:genchat/Client/client.dart';
import 'package:genchat/Providers/chat_provider.dart';
import 'package:genchat/genchat.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  client = await Socket.connect(serverIp, serverPort);

  client.listen(
    (data) {
      ChatProvider().receiveChat(String.fromCharCodes(data));
    },
    onError: (error) {
      ChatProvider().errorMessage = 'Error: $error';
    },
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const GenChat(),
    ),
  );
}
