import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/user.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../widgets/contact_list_item.dart';
import '../providers/app_state_providers.dart';
import '../services/service_locator.dart';
import '../services/chat_service.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final List<User> _contacts = _generateMockContacts();
  final TextEditingController _searchController = TextEditingController();
  List<User> _filteredContacts = [];

  late ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = getIt<ChatService>();
    _filteredContacts = _contacts;
    _searchController.addListener(_filterContacts);
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
               contact.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Контакты'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              _showAddContactDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск контактов...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return ContactListItem(
                  contact: contact,
                  onTap: () {
                    _showContactDetails(contact);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddContactDialog();
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить контакт'),
        content: const Text('Функция добавления контакта будет реализована позже'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showContactDetails(User contact) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final currentUser = ref.read(currentUserProvider);
        return AlertDialog(
          title: Text(contact.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (contact.avatarUrl != null)
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(contact.avatarUrl!),
                  ),
                )
              else
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    child: Text(
                      contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text('Email: ${contact.email}'),
              const SizedBox(height: 8),
              Text('Статус: ${contact.isOnline ? 'В сети' : 'Не в сети'}'),
              const SizedBox(height: 8),
              Text('Последний раз в сети: ${_formatLastSeen(contact.lastSeen)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                dialogContext.pop();
                final newChat = Chat(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: contact.name,
                  participants: [currentUser, contact],
                  createdAt: DateTime.now(),
                  type: ChatType.direct,
                );
                _chatService.addChat(newChat);
                ref.read(chatsProvider.notifier).addChat(newChat);
                context.push('/chat/${newChat.id}', extra: newChat);
              },
              child: const Text('Написать'),
            ),
          ],
        );
      },
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inDays > 0) {
      return '${difference.inDays} дней назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} часов назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} минут назад';
    } else {
      return 'только что';
    }
  }

  static List<User> _generateMockContacts() {
    return [
      User(
        id: '1',
        name: 'Владимир Владимирович',
        email: 'putinVV@example.com',
        lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
        isOnline: true,
      ),
      User(
        id: '2',
        name: 'Дональд Трамп',
        email: 'trump@example.com',
        lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
        isOnline: true,
      ),
    ];
  }
}