import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/domain/entities/comment.dart';
import 'package:smart_threads/domain/repositories/comment_repository.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommentRepository _repository;
  final String _postId;

  CommentsCubit(this._repository, this._postId) : super(const CommentsState());

  // load comments
  Future<void> loadComments() async {
    emit(state.copyWith(status: CommentsStatus.loading, errorMessage: null));

    try {
      final comments = await _repository.getComments(_postId);
      emit(state.copyWith(status: CommentsStatus.success, comment: comments));
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentsStatus.failure,
          errorMessage: 'Не удалось загрузить комментарии',
        ),
      );
    }
  }

  // addComment
  Future<void> addComment() async {
    if (!state.canSubmit) return;

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: _postId,
      authorId: 'me',
      content: state.inputText.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      await _repository.addComment(newComment);
      emit(state.copyWith(inputText: ''));
      await loadComments();
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentsStatus.failure,
          errorMessage: 'Не удалось добавить комментарий',
        ),
      );
    }
  }

  // input changed
  void inputChanged(String value) {
    emit(state.copyWith(inputText: value));
  }
}
