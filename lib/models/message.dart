import 'user.dart';

class Message {
  final String id;
  final String chatId;
  final User sender;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final bool isRead;
  final String? replyToMessageId;
  final String? imageUrl;

  const Message({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.isRead = false,
    this.replyToMessageId,
    this.imageUrl,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chatId'],
      sender: User.fromJson(json['sender']),
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.firstWhere(
            (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      isRead: json['isRead'] ?? false,
      replyToMessageId: json['replyToMessageId'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'sender': sender.toJson(),
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'isRead': isRead,
      'replyToMessageId': replyToMessageId,
      'imageUrl': imageUrl,
    };
  }

  Message copyWith({
    String? id,
    String? chatId,
    User? sender,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    bool? isRead,
    String? replyToMessageId,
    String? imageUrl,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

enum MessageType {
  text,
  image,
  file,
  voice,
  video,
}