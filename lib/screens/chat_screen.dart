import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../widgets/message_bubble.dart';
import '../widgets/app_state_provider.dart';
import '../services/service_locator.dart';
import '../services/user_service.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];

  final UserService _userService = getIt<UserService>();
  final ChatService _chatService = getIt<ChatService>();

  User get _currentUserFromService => _userService.currentUser;

  User _getCurrentUser(BuildContext context) {
    final user = AppStateProvider.currentUserOf(context);
    return user ?? _userService.currentUser;
  }

  final List<String> _imageUrls = [
    'https://i.pinimg.com/videos/thumbnails/originals/b8/3f/e1/b83fe15d51ecb3f5f15b85361bd67119.0000000.jpg',
    'https://avatars.mds.yandex.net/i?id=24bb0ea447c807287c172e5cdb679614_l-4628144-images-thumbs&n=13',
    'https://avatars.mds.yandex.net/i?id=6eee8575c67c88bb6918514c5a34e9cc_l-13285290-images-thumbs&n=13',
    'https://rusvesna.su/sites/default/files/styles/orign_wm/public/tramp_51.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/%D0%92%D0%BB%D0%B0%D0%B4%D0%B8%D0%BC%D0%B8%D1%80_%D0%9F%D1%83%D1%82%D0%B8%D0%BD_%2831-12-2021%29.jpg/1200px-%D0%92%D0%BB%D0%B0%D0%B4%D0%B8%D0%BC%D0%B8%D1%80_%D0%9F%D1%83%D1%82%D0%B8%D0%BD_%2831-12-2021%29.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    final currentUser = _currentUserFromService;
    final otherUser = widget.chat.participants.firstWhere(
      (user) => user.id != currentUser.id,
    );

    setState(() {
      _messages.addAll([
        Message(
          id: '1',
          chatId: widget.chat.id,
          sender: otherUser,
          content: 'Привет! А ты уже скачал MAX?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
        Message(
          id: '2',
          chatId: widget.chat.id,
          sender: otherUser,
          content: '',
          imageUrl: _imageUrls[0],
          timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
        ),
        Message(
          id: '3',
          chatId: widget.chat.id,
          sender: currentUser,
          content: '',
          imageUrl: _imageUrls[1],
          timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
        ),
        Message(
          id: '4',
          chatId: widget.chat.id,
          sender: currentUser,
          content: '',
          imageUrl: _imageUrls[2],
          timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
        ),
        Message(
          id: '5',
          chatId: widget.chat.id,
          sender: currentUser,
          content: '',
          imageUrl: _imageUrls[3],
          timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
        ),
        Message(
          id: '6',
          chatId: widget.chat.id,
          sender: otherUser,
          content: '',
          imageUrl: _imageUrls[4],
          timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
        ),
      ]);
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final currentUser = _currentUserFromService;
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: widget.chat.id,
      sender: currentUser,
      content: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
    });

    _chatService.addMessageToChat(widget.chat.id, message);

    _messageController.clear();
    _scrollToBottom();
  }

  void _sendImage(String imageUrl) {
    final currentUser = _currentUserFromService;
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: widget.chat.id,
      sender: currentUser,
      content: '',
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
    });

    _chatService.addMessageToChat(widget.chat.id, message);
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 40,
              right: 40,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Выберите картинку',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imageUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _sendImage(_imageUrls[index]);
                      context.pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _imageUrls[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _getCurrentUser(context);
    
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            if (widget.chat.type == ChatType.direct) {
              final otherUser = widget.chat.participants.firstWhere(
                (user) => user.id != currentUser.id,
              );

              context.push('/user-profile/${otherUser.id}', extra: otherUser);
            }
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
                ),
                child: widget.chat.avatarUrl == null
                    ? Text(
                  widget.chat.name.isNotEmpty ? widget.chat.name[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    if (widget.chat.type == ChatType.direct)
                      Text(
                        widget.chat.participants
                            .firstWhere((user) => user.id != currentUser.id)
                            .isOnline
                            ? 'В сети'
                            : 'Был(а) в сети недавно',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // TODO: Implement video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              // TODO: Implement voice call
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.sender.id == currentUser.id;
                final showAvatar = index == _messages.length - 1 ||
                    _messages[index + 1].sender.id != message.sender.id;

                return GestureDetector(
                  onTap: message.imageUrl != null
                      ? () => _showImageDialog(message.imageUrl!)
                      : null,
                  child: MessageBubble(
                    message: message,
                    isMe: isMe,
                    showAvatar: showAvatar,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _showImagePicker,
                ),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: _showImagePicker,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Введите сообщение...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}