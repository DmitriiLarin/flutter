import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/chat.dart';
import '../services/service_locator.dart';
import '../services/user_service.dart';
import '../services/chat_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return getIt<UserService>();
});

final chatServiceProvider = Provider<ChatService>((ref) {
  return getIt<ChatService>();
});

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User>((ref) {
  final userService = ref.watch(userServiceProvider);
  return CurrentUserNotifier(userService);
});

final chatsProvider = StateNotifierProvider<ChatsNotifier, List<Chat>>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return ChatsNotifier(chatService);
});

class CurrentUserNotifier extends StateNotifier<User> {
  final UserService _userService;

  CurrentUserNotifier(this._userService) : super(_userService.currentUser) {

  }

  void updateUser(User user) {
    state = user;
  }

  void refresh() {
    state = _userService.currentUser;
  }
}

class ChatsNotifier extends StateNotifier<List<Chat>> {
  final ChatService _chatService;

  ChatsNotifier(this._chatService) : super(_chatService.chats) {

  }

  void updateChats(List<Chat> chats) {
    state = List.from(chats);
  }

  void addChat(Chat chat) {
    state = [...state, chat];
  }

  void removeChat(String chatId) {
    state = state.where((chat) => chat.id != chatId).toList();
  }

  void updateChat(Chat updatedChat) {
    state = state.map((chat) {
      return chat.id == updatedChat.id ? updatedChat : chat;
    }).toList();
  }

  void refresh() {
    state = List.from(_chatService.chats);
  }
}

