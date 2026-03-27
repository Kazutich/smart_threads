import 'package:flutter/material.dart';
import 'package:smart_threads/domain/entities/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, this.onLike});

  final Post post;
  final VoidCallback? onLike;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20, child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Text(
                  post.authorId,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(post.content, style: TextStyle(fontSize: 15)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(
                            post.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20,
                            color: post.isLiked
                                ? const Color(0xFF7C3AED)
                                : null,
                          ),
                          const SizedBox(width: 4),
                          if (post.likes > 0)
                            Text(
                              '${post.likes}',
                              style: TextStyle(
                                fontSize: 13,
                                color: post.isLiked
                                    ? const Color(0xFF7C3AED)
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.mode_comment_outlined, size: 20),
                    const SizedBox(width: 20),
                    const Icon(Icons.repeat, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
