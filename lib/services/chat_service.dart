import '../models/chat.dart';
import '../models/user.dart';
import '../models/message.dart';

class ChatService {
  final List<Chat> _chats = [];

  List<Chat> get chats => List.unmodifiable(_chats);

  void initializeMockData(User currentUser) {
    if (_chats.isNotEmpty) return;

    final users = [
      User(
        id: '1',
        name: 'Владимир Владимирович',
        email: 'putinVV@example.com',
        lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
        isOnline: true,
      ),
    ];

    _chats.addAll([
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
    ]);
  }

  Chat? getChatById(String chatId) {
    try {
      return _chats.firstWhere((chat) => chat.id == chatId);
    } catch (e) {
      return null;
    }
  }

  void addChat(Chat chat) {
    _chats.add(chat);
  }

  void updateChat(Chat updatedChat) {
    final index = _chats.indexWhere((chat) => chat.id == updatedChat.id);
    if (index != -1) {
      _chats[index] = updatedChat;
    }
  }

  void addMessageToChat(String chatId, Message message) {
    final chat = getChatById(chatId);
    if (chat != null) {
      final updatedChat = chat.copyWith(
        lastMessage: message,
        unreadCount: chat.unreadCount + 1,
      );
      updateChat(updatedChat);
    }
  }

  void removeChat(String chatId) {
    _chats.removeWhere((chat) => chat.id == chatId);
  }
}

