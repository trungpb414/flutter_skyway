import 'package:flutter_skyway/core/architecture/result.dart';
import 'package:flutter_skyway/data/api/news_data_source.dart';
import 'package:flutter_skyway/data/repositories/user_repository.dart';
import 'package:flutter_skyway/domain/models/user.dart';
import 'package:get/get.dart';

class UserUseCase {
  final _repository = Get.find<UserRepository>();

  Future<Result<List<User>>> getUsers() => _repository.getUsers();
}