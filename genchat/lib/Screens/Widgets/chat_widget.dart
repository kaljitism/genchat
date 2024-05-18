import 'package:flutter/material.dart';
import 'package:genchat/Models/message_model.dart';
import 'package:genchat/Providers/chat_provider.dart';
import 'package:genchat/Screens/Widgets/message_widget.dart';
import 'package:provider/provider.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  late List<Message> messages;

  @override
  void initState() {
    super.initState();

    Provider.of<ChatProvider>(context, listen: false).addListener(_onMessage);
  }

  void _onMessage() {
    messages = context.read<ChatProvider>().chatLog;
    setState(() {
      _scrollDown();
    });
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 500,
        ),
        curve: Curves.easeOutCirc,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _onMessage();
    final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(8),
      hintText: 'Enter message...',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                final content = messages[index];
                return MessageWidget(
                  text: content.text,
                  isFromUser: content.fromUser,
                );
              },
              itemCount: messages.length,
            ),
          ),
          buildMessageField(textFieldDecoration, context),
        ],
      ),
    );
  }

  Padding buildMessageField(
    InputDecoration textFieldDecoration,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              focusNode: _textFieldFocus,
              decoration: textFieldDecoration,
              controller: _textController,
              onSubmitted: _sendChatMessage,
            ),
          ),
          const SizedBox.square(dimension: 10),
          Consumer<ChatProvider>(
            builder: (context, provider, child) {
              return provider.loading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      onPressed: () async {
                        _sendChatMessage(_textController.text);
                        provider.errorMessage == null
                            ? Intent.doNothing
                            : _showError(provider.errorMessage!);
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    _textController.clear();
    if (message.trim().isNotEmpty) {
      context.read<ChatProvider>().sendChat(message);
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong!'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<ChatProvider>().errorMessage = null;
                Navigator.of(context).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }
}
