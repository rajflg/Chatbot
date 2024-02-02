import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:rajdarvai/pages/menu&id.dart';

import 'const.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: OPEN_API_KEY,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    enableLog: true,
  );

  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Raj', lastName: 'Darvai');
  final ChatUser _gptChatUser =
      ChatUser(id: '2', firstName: 'GPT', lastName: 'Chat');

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
        color: Colors.white30
        ),
        child: DashChat(
          currentUser: _currentUser,
          messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.black,
            containerColor: Colors.black,
            textColor: Colors.white,
          ),
          onSend: _handleSendMessage,
          messages: _messages,
        ),
      ),
    );
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    try {
      setState(() {
        _messages.insert(0, message);
        _typingUsers.add(_gptChatUser);
      });

      final messagesHistory = _messages.reversed.map((msg) {
        return Messages(
          role: msg.user == _currentUser ? Role.user : Role.assistant,
          content: msg.text,
        );
      }).toList();

      final request = ChatCompleteText(
        model: GptTurbo0301ChatModel(),
        messages: messagesHistory,
      );

      final response = await _openAI.onChatCompletion(request: request);

      if (response != null && response.choices.isNotEmpty) {
        for (var element in response.choices) {
          setState(() {
            _messages.insert(
              0,
              ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: element.message!.content,
              ),
            );
          });
        }
      } else {
      }
    } catch (e) {
      // Handle the error as needed
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComingSoon()),
              );
            },
            child: const Icon(Icons.menu, size: 25, color: Colors.black),
          ),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComingSoon()),
                  );
                },
                child: Icon(Icons.person_outline, size: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}