import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/chats_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/contacts_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/user_profile_screen.dart';
import '../screens/notifications_settings_screen.dart';
import '../models/chat.dart';
import '../models/user.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/chat/:chatId',
        name: 'chat',
        builder: (context, state) {
          final chatId = state.pathParameters['chatId']!;
          final chat = state.extra as Chat?;
          if (chat != null) {
            return ChatScreen(chat: chat);
          }
          return ChatScreen(
            chat: Chat(
              id: chatId,
              name: 'Чат',
              participants: [],
              createdAt: DateTime.now(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/user-profile/:userId',
        name: 'user-profile',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          final user = state.extra as User?;
          if (user != null) {
            return UserProfileScreen(user: user);
          }
          return UserProfileScreen(
            user: User(
              id: userId,
              name: 'Пользователь',
              email: '',
              lastSeen: DateTime.now(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) {
          final user = state.extra as User?;
          if (user != null) {
            return EditProfileScreen(user: user);
          }
          return EditProfileScreen(
            user: User(
              id: '0',
              name: 'Пользователь',
              email: '',
              lastSeen: DateTime.now(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/notifications-settings',
        name: 'notifications-settings',
        builder: (context, state) => const NotificationsSettingsScreen(),
      ),
    ],
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ChatsScreen(),
    const ContactsScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Чаты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Контакты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}

