import 'package:flutter/material.dart';
import 'package:genchat/Screens/chat_screen.dart';

class GenChat extends StatelessWidget {
  const GenChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GenChat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xffe73895),
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(title: 'GenChat'),
    );
  }
}
