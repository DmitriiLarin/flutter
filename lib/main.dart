import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'services/service_locator.dart';
import 'services/user_service.dart';
import 'services/chat_service.dart';
import 'widgets/app_state_provider.dart';

void main() {
  setupServiceLocator();
  
  runApp(const MessengerApp());
}

class MessengerApp extends StatelessWidget {
  const MessengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = getIt<UserService>();
    final chatService = getIt<ChatService>();

    return AppStateScope(
      initialUser: userService.currentUser,
      initialChats: chatService.chats,
      child: MaterialApp.router(
        title: 'Мессенджер',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
