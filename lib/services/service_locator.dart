import 'package:get_it/get_it.dart';
import 'user_service.dart';
import 'chat_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<UserService>(UserService());

  getIt.registerSingleton<ChatService>(ChatService());

  final userService = getIt<UserService>();
  final chatService = getIt<ChatService>();
  chatService.initializeMockData(userService.currentUser);
}

