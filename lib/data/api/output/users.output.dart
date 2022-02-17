import 'package:flutter_skyway/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'users.output.freezed.dart';
part 'users.output.g.dart';

@freezed
abstract class GetUsersOutput with _$GetUsersOutput {
  const factory GetUsersOutput({
    required List<User> data,
    required int total,
    required int page,
    required int limit,
  }) = _GetUsersOutput;

  factory GetUsersOutput.fromJson(Map<String, dynamic> json) => _$GetUsersOutputFromJson(json);
}