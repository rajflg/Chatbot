import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:dio/dio.dart'; // Import the dio package
import 'package:flutter/material.dart';
import 'package:rajdarvai/pages/const.dart';

class ChatPage2 extends StatefulWidget {
  const ChatPage2({Key? key}) : super(key: key);

  @override
  State<ChatPage2> createState() => _ChatPage2State();
}

class _ChatPage2State extends State<ChatPage2> {
  final _openAI = OpenAI.instance.build(
    token: OPEN_API_KEY,
    baseOption: HttpSetup(receiveTimeout: Duration(seconds: 5)),
    enableLog: true,
  );

  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'Raj', lastName: 'Darvai');
  final ChatUser _gptChatUser = ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');

  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
        title: Text(
          'Chat GPT',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: DashChat(
        currentUser: _currentUser,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Color.fromRGBO(0, 166, 126, 1),
          textColor: Colors.white,
        ),
        onSend: (ChatMessage message) {
          getChatResponse(message);
        },
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage message) async {
    try {
      setState(() {
        _messages.insert(0, message);
      });

      List<Messages> messagesHistory = _messages.reversed.map((m) {
        return Messages(
          role: m.user == _currentUser ? Role.user : Role.assistant,
          content: m.text,
        );
      }).toList();

      final request = ChatCompleteText(
        model: GptTurbo0301ChatModel(),
        messages: messagesHistory,
        maxToken: 200,
      );

      final response = await _openAI.onChatCompletion(request: request);

      for (var choice in response?.choices ?? []) {
        if (choice.message != null) {
          setState(() {
            _messages.insert(
              0,
              ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: choice.message!.content,
              ),
            );
          });
        }
      }
    } catch (e) {
      // Handle Dio exceptions
      if (e is DioError) {
        print('DioError: ${e.message}');
        // Handle specific DioError types if needed
        if (e.type == DioErrorType.connectionTimeout) {
          // Handle connect timeout
        } else if (e.type == DioErrorType.receiveTimeout) {
          // Handle response error
        }
      } else {
        // Handle other types of exceptions
        print('Error: $e');
      }
    }
  }
}
