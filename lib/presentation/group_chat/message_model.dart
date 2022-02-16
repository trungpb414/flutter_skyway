import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.g.dart';
part 'message_model.freezed.dart';

@freezed
class MessageModel with _$MessageModel {
  factory MessageModel({int? id, String? content, DateTime? time, int? userSentId}) =
      _Message;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
