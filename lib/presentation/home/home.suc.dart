import 'package:flutter_skyway/core/architecture/result.dart';
import 'package:flutter_skyway/domain/entities/user.dart';
import 'package:flutter_skyway/domain/use_case/user.uc.dart';

abstract class HomeSceneUseCaseType {
  Future<Result<List<User>>> getUsers();
}

class HomeSceneUseCase with UserUseCase implements HomeSceneUseCaseType {}
