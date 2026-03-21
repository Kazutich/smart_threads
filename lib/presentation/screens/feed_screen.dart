import 'package:flutter/material.dart';
import 'package:smart_threads/presentation/widgets/post_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_cubit.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_state.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Threads',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if (state.status == FeedStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FeedStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Error'));
          }

          if (state.posts.isEmpty) {
            return const Center(child: Text('No posts'));
          }

          return ListView.separated(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return PostCard(post: post);
            },
            separatorBuilder: (_, _) => const Divider(height: 1),
          );
        },
      ),
    );
  }
}
