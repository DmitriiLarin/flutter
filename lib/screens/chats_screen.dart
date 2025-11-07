import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/chat.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../widgets/chat_list_item.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final List<Chat> _chats = _generateMockChats();

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

  static List<Chat> _generateMockChats() {
    final users = [
      User(
        id: '1',
        name: 'Владимир Владимирович',
        email: 'putinVV@example.com',
        lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
        isOnline: true,
      ),
    ];

    final currentUser = User(
      id: '0',
      name: 'Вы',
      email: 'you@example.com',
      lastSeen: DateTime.now(),
      isOnline: true,
    );

    return [
      Chat(
        id: '1',
        name: 'Владимир Владимирович',
        participants: [currentUser, users[0]],
        lastMessage: Message(
          id: '1',
          chatId: '1',
          sender: users[0],
          content: 'Привет! А ты уже скачал MAX?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        unreadCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        type: ChatType.direct,
      ),
    ];
  }
}

