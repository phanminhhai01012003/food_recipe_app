import 'dart:io';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_recipe_app/common/configure/convert.dart';
import 'package:food_recipe_app/common/constants/firebase_constants.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/views/main/chatbot/chat_body.dart';
import 'package:food_recipe_app/widget/bottom_sheet/show_image_picker.dart';

class AIChatbotPage extends StatefulWidget {
  const AIChatbotPage({super.key});

  @override
  State<AIChatbotPage> createState() => _AIChatbotPageState();
}

class _AIChatbotPageState extends State<AIChatbotPage> {
  final openAI = OpenAI.instance.build(
    token: dotenv.env['CHAT_GPT_API_KEY'],
    baseOption: HttpSetup(receiveTimeout: Duration(seconds: 5)),
    enableLog: true
  );
  final _currentUser = ChatUser(
    id: currentUser.uid,
    profileImage: currentUser.photoURL,
    firstName: (currentUser.displayName ?? "").split(" ").first,
    lastName: (currentUser.displayName ?? "").split(" ").last
  );
  final _aiChat = ChatUser(
    id: generateRandomString(10),
    profileImage: chatbotImages,
    firstName: "Food",
    lastName: "AI"
  );
  String roleChat(Role role){
    return switch(role) {
      Role.user => "user",
      Role.assistant => "assistant",
      _ => ""
    };
  }
  List<ChatMessage> _messages = [];
  List<ChatUser> typingUsers = [];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        title: Column(
          children: [
            Text(
              "helloAI".tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              "helpYou".tr(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              size: 20,
            )
          ),
        ),
      ),
      body: ChatBody(
        chatCurrentUser: _currentUser,
        typingUsers: typingUsers, 
        messages: _messages, 
        onPressed: () => chatMediaResponse(), 
        onSend: (m) => chatResponse(m)
      ),
    );
  }
  Future chatResponse(ChatMessage m) async{
    setState(() {
      _messages.insert(0, m);
      typingUsers.add(_aiChat);
    });
    String role = m.user == _currentUser ? roleChat(Role.user) : roleChat(Role.assistant);
    String content = m.text;
    List<Map<String, dynamic>> _messHistory = _messages.reversed.map((m){
      return {
        "role": role,
        "content": content
      };
    }).toList();
    final request = ChatCompleteText(
      model: Gpt40631ChatModel(), 
      messages: _messHistory,
      maxToken: 200
    );
    final response = await openAI.onChatCompletion(request: request);
    for (var e in response!.choices) {
      if (e.message != null) {
        setState(() {
          _messages.insert(0, ChatMessage(
            user: _aiChat, 
            createdAt: DateTime.now(),
            text: e.message!.content,
          ));
        });
      }
    }
    setState(() {
      typingUsers.remove(_aiChat);
    });
  }
  Future chatMediaResponse() async {
    final file = await showImagePickerModal(context, true);
    if (file != null) {
      ChatMessage message = ChatMessage(
        user: _currentUser, 
        createdAt: DateTime.now(),
        text: "helpToMake".tr(),
        medias: [
          ChatMedia(
            url: file.path, 
            fileName: "", 
            type: MediaType.image,
            uploadedDate: DateTime.now()
          ),
          ChatMedia(
            url: file.path, 
            fileName: "", 
            type: MediaType.video,
            uploadedDate: DateTime.now()
          )
        ]
      );
      chatResponse(message);
    }
  }
}