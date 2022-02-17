import 'package:flutter_skyway/core/architecture/result.dart';
import 'package:flutter_skyway/data/repositories/user.repository.dart';
import 'package:flutter_skyway/domain/entities/user.dart';
import 'package:get/get.dart';

class UserUseCase {
  final _repository = Get.find<UserRepository>();

  Future<Result<List<User>>> getUsers() => _repository.getUsers();
}