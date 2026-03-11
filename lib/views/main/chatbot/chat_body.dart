import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';

class ChatBody extends StatelessWidget {
  final ChatUser chatCurrentUser;
  final List<ChatUser>? typingUsers;
  final List<ChatMessage> messages;
  final void Function(ChatMessage) onSend;
  final VoidCallback onPressed;
  const ChatBody({
    super.key, 
    required this.chatCurrentUser,
    required this.messages, 
    this.typingUsers,
    required this.onPressed,
    required this.onSend
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DashChat(
      currentUser: chatCurrentUser, 
      onSend: onSend, 
      messages: messages,
      messageOptions: MessageOptions(
        currentUserContainerColor: AppColors.green,
        timeFontSize: 12,
        timeTextColor: AppColors.grey,
        currentUserTextColor: AppColors.white,
        containerColor: AppColors.grey,
        textColor: AppColors.black
      ),
      inputOptions: InputOptions(
        inputTextStyle: TextStyle(
          color: theme.colorScheme.secondary,
          fontSize: 14,
          fontWeight: FontWeight.w700
        ),
        leading: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.image,
              color: theme.colorScheme.secondary,
            ),
          )
        ],
        cursorStyle: CursorStyle(
          color: AppColors.blue,
          width: 2.5
        ),
        sendButtonBuilder: (send) {
          return IconButton(
            onPressed: send,
            icon: Icon(
              Icons.send,
              color: theme.colorScheme.secondary,
            ),
          );
        },
        inputDecoration: InputDecoration(
          hintText: "messageInput".tr(),
          hintStyle: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 14,
            fontWeight: FontWeight.w700
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.secondary)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.green)
          )
        )
      ), 
    );
  }
}