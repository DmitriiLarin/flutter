import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/user.dart';
import '../widgets/app_state_provider.dart';
import '../services/service_locator.dart';
import '../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserService _userService = getIt<UserService>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final initialUser = widget.user;
    _nameController = TextEditingController(text: initialUser.name);
    _emailController = TextEditingController(text: initialUser.email);
  }

  User _getUser(BuildContext context) {
    final user = AppStateProvider.currentUserOf(context);
    return user ?? widget.user;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile(BuildContext context) {
    final currentUser = _getUser(context);
    final updatedUser = currentUser.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );
    
    _userService.updateUser(updatedUser);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль обновлен')),
    );
    
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _saveProfile(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveProfile(context),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

