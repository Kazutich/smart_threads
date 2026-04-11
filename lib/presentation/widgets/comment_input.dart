import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_cubit.dart';
import 'package:smart_threads/presentation/bloc/comments/comments_state.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({super.key});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsCubit, CommentsState>(
      listener: (context, state) {
        if (state.inputText.isEmpty && _controller.text.isNotEmpty) {
          _controller.clear();
        }
      },
      builder: (context, state) {
        final cubit = context.read<CommentsCubit>();

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 8,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 8 : 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: Text(
                    'M',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    onChanged: cubit.inputChanged,
                    textInputAction: TextInputAction.send,
                    onFieldSubmitted: (_) {
                      if (state.canSubmit) cubit.addComment();
                    },
                    decoration: InputDecoration(
                      hintText: 'Добавить комментарий...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: TextStyle(fontSize: 15),
                    maxLines: null,
                  ),
                ),

                AnimatedOpacity(
                  opacity: state.canSubmit ? 1.0 : 0.3,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    onPressed: state.canSubmit ? cubit.addComment : null,
                    icon: const Icon(Icons.send_rounded),
                    color: Colors.black,
                    splashRadius: 20,
                    tooltip: 'Отправить',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
