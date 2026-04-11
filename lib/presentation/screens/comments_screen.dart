import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/data/datasourses/local_comment_data_source.dart';
import 'package:smart_threads/data/respositories/comment_repository_impl.dart';
import 'package:smart_threads/domain/entities/post.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_cubit.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_state.dart';
import 'package:smart_threads/presentation/widgets/comment_input.dart';
import 'package:smart_threads/presentation/widgets/comment_tile.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key, required this.post});

  final Post post;

  static Future<void> show(BuildContext context, Post post) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => CommentsCubit(
            CommentRepositoryImpl(LocalCommentDataSource()),
            post.id,
          ),
          child: CommentsScreen(post: post),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 10),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(16, 0, 8, 8),
            child: Row(
              children: [
                Text(
                  "Комментарий",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey),
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black,
                  child: Text(post.id.isNotEmpty ? post.authorId[0] : 'Я'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorId,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey),
          Expanded(
            child: BlocBuilder<CommentsCubit, CommentsState>(
              builder: (context, state) {
                if (state.status == CommentsStatus.loading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state.comment.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.mode_comment_outlined,
                          size: 48,
                          color: Colors.white,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Пока нет ответов',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 9),
                  itemCount: state.comment.length,
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, color: Colors.grey),
                  itemBuilder: (context, index) {
                    return CommentTile(comment: state.comment[index]);
                  },
                );
              },
            ),
          ),

          Divider(height: 1, color: Colors.grey),
          CommentInput(),
        ],
      ),
    );
  }
}
