import 'package:flutter_skyway/core/architecture/result.dart';
import 'package:flutter_skyway/domain/models/user.dart';
import 'package:flutter_skyway/domain/usecase/user.uc.dart';

abstract class HomeSceneUseCaseType {
  Future<Result<List<User>>> getUsers();
}

class HomeSceneUseCase with UserUseCase implements HomeSceneUseCaseType {}