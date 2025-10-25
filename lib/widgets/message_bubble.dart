import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool showAvatar;
  final VoidCallback? onImageTap;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showAvatar = false,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar)
            CircleAvatar(
              radius: 12,
              backgroundImage: message.sender.avatarUrl != null
                  ? NetworkImage(message.sender.avatarUrl!)
                  : null,
              child: message.sender.avatarUrl == null
                  ? Text(
                message.sender.name.isNotEmpty
                    ? message.sender.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              )
                  : null,
            )
          else if (!isMe)
            const SizedBox(width: 24),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMe
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
                ),
              ),
              child: _buildMessageContent(theme),
            ),
          ),
          if (isMe)
            const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildMessageContent(ThemeData theme) {
    final hasImage = message.imageUrl != null && message.imageUrl!.isNotEmpty;
    final hasText = message.content.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe && showAvatar)
          Text(
            message.sender.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        if (!isMe && showAvatar)
          const SizedBox(height: 2),

        if (hasImage)
          Column(
            children: [
              GestureDetector(
                onTap: onImageTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.dividerColor.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _buildImageWidget(),
                  ),
                ),
              ),
              if (hasText) const SizedBox(height: 8),
            ],
          ),

        if (hasText)
          Text(
            message.content,
            style: TextStyle(
              color: isMe
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),

        if (hasText || hasImage)
          const SizedBox(height: 4),
        _buildTimestamp(theme),
      ],
    );
  }

  Widget _buildImageWidget() {
    return Image.network(
      message.imageUrl!,
      width: 200,
      height: 150,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: 200,
          height: 150,
          color: Colors.grey[100],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 200,
          height: 150,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                color: Colors.grey[400],
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                'Не удалось загрузить\nизображение',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimestamp(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatTime(message.timestamp),
          style: TextStyle(
            fontSize: 11,
            color: isMe
                ? theme.colorScheme.onPrimary.withOpacity(0.7)
                : theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: 4),
          Icon(
            message.isRead ? Icons.done_all : Icons.done,
            size: 14,
            color: message.isRead
                ? theme.colorScheme.onPrimary.withOpacity(0.7)
                : theme.colorScheme.onPrimary.withOpacity(0.5),
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}