import '../models/user.dart';


class UserService {
  User _currentUser = User(
    id: '0',
    name: 'Иван Петров',
    email: 'ivan@example.com',
    lastSeen: DateTime.now(),
    isOnline: true,
  );

  User get currentUser => _currentUser;

  void updateUser(User user) {
    _currentUser = user;
  }

  void updateName(String name) {
    _currentUser = _currentUser.copyWith(name: name);
  }

  void updateEmail(String email) {
    _currentUser = _currentUser.copyWith(email: email);
  }

  void updateOnlineStatus(bool isOnline) {
    _currentUser = _currentUser.copyWith(isOnline: isOnline);
  }

  void updateAvatar(String? avatarUrl) {
    _currentUser = _currentUser.copyWith(avatarUrl: avatarUrl);
  }
}

