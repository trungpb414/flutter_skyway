import 'package:flutter_skyway/core/architecture/result.dart';
import 'package:flutter_skyway/domain/models/user.dart';
import 'package:flutter_skyway/presentation/home/home.suc.dart';

class HomeSceneUseCaseMock implements HomeSceneUseCaseType {
  @override
  Future<Result<List<User>>> getUsers() {
    return Future.value(const Result.success(data: []));
  }
}