import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:smart_threads/domain/entities/post.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String content,
    required String authorId,
    required String createdAt,
    required int likes,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  const PostModel._();

  Post toEntity() {
    return Post(
      id: id,
      content: content,
      authorId: authorId,
      createdAt: createdAt,
      likes: likes,
    );
  }
}

class PostModelAdapter extends TypeAdapter<PostModel> {
  @override
  final int typeId = 0;

  @override
  PostModel read(BinaryReader reader) {
    return PostModel(
      id: reader.readString(),
      content: reader.readString(),
      authorId: reader.readString(),
      createdAt: reader.readString(),
      likes: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, PostModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.content);
    writer.writeString(obj.authorId);
    writer.writeString(obj.createdAt);
    writer.writeInt(obj.likes);
  }
}
