import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/chat.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/app_state_provider.dart';
import '../services/service_locator.dart';
import '../services/chat_service.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final ChatService _chatService = getIt<ChatService>();

  List<Chat> get _chats {
    final chats = AppStateProvider.chatsOf(context);
    return chats ?? _chatService.chats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Чаты'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ChatListItem(
            chat: chat,
            onTap: () {

              context.push('/chat/${chat.id}', extra: chat);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new chat creation
          _showNewChatDialog();
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новый чат'),
        content: const Text('Функция создания нового чата будет реализована позже'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

