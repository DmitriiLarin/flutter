import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/chat.dart';
import '../services/service_locator.dart';
import '../services/user_service.dart';
import '../services/chat_service.dart';

class AppStateProvider extends InheritedWidget {
  final User currentUser;
  final List<Chat> chats;
  final VoidCallback? onUserUpdated;
  final VoidCallback? onChatsUpdated;

  const AppStateProvider({
    super.key,
    required this.currentUser,
    required this.chats,
    required super.child,
    this.onUserUpdated,
    this.onChatsUpdated,
  });

  static AppStateProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
  }

  static User? currentUserOf(BuildContext context) {
    return of(context)?.currentUser;
  }

  static List<Chat>? chatsOf(BuildContext context) {
    return of(context)?.chats;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) {
    return currentUser != oldWidget.currentUser ||
        chats != oldWidget.chats;
  }
}

class AppStateScope extends StatefulWidget {
  final Widget child;
  final User initialUser;
  final List<Chat> initialChats;

  const AppStateScope({
    super.key,
    required this.child,
    required this.initialUser,
    required this.initialChats,
  });

  @override
  State<AppStateScope> createState() => _AppStateScopeState();
}

class _AppStateScopeState extends State<AppStateScope> {
  late User _currentUser;
  late List<Chat> _chats;
  late UserService _userService;
  late ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _userService = getIt<UserService>();
    _chatService = getIt<ChatService>();
    
    _currentUser = widget.initialUser;
    _chats = List.from(widget.initialChats);
  }

  void _syncUserFromService() {
    final user = _userService.currentUser;
    if (user != _currentUser) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  void _syncChatsFromService() {
    final chats = _chatService.chats;
    if (chats != _chats) {
      setState(() {
        _chats = List.from(chats);
      });
    }
  }

  void updateUser(User user) {
    setState(() {
      _currentUser = user;
    });
  }

  void updateChats(List<Chat> chats) {
    setState(() {
      _chats = List.from(chats);
    });
  }

  @override
  Widget build(BuildContext context) {
    _syncUserFromService();
    _syncChatsFromService();
    
    return AppStateProvider(
      currentUser: _currentUser,
      chats: _chats,
      onUserUpdated: () => _syncUserFromService(),
      onChatsUpdated: () => _syncChatsFromService(),
      child: widget.child,
    );
  }
}

