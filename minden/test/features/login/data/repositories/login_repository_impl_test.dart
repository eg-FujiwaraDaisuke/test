import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/login/data/datasources/user_data_source.dart';
import 'package:minden/features/login/data/model/user_model.dart';
import 'package:minden/features/login/data/repositories/login_repository_impl.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/user/data/model/profile_model.dart';
import 'package:mockito/mockito.dart';

class MockUserDataSource extends Mock implements UserDataSource {}

void main() {
  late LoginRepositoryImpl loginRepositoryImpl;
  late MockUserDataSource mockUserDataSource;

  setUp(() {
    mockUserDataSource = MockUserDataSource();
    loginRepositoryImpl =
        LoginRepositoryImpl(userDataSource: mockUserDataSource);
  });

  group('getLoginUser', () {
    final tId = 'nakajo@minden.co.jp';
    final tPassword = '1234qwer';
    final tUserModel = UserModel(
      // key: "20190707085551963zhayz",
      loginId: "nakajo@minden.co.jp",
      accountId: "",
      limitedPlantId: "",
      contractor: "",
      profile: ProfileModel.fromJson({}),

      // userId: "",
      // name: "�݂�ȁ@�d��",
      // secret: "20000102",
      // provider: "MINDEN",
      // service: "portal",
      // email: "nakajo@minden.co.jp",
      // profile: Profile.fromJson({}),
    );

    final User tUser = tUserModel;

    test('should return remote data', () async {
      when(mockUserDataSource.getLoginUser(tId, tPassword))
          .thenAnswer((_) async => tUserModel);

      final result = await loginRepositoryImpl.getLoginUser(tId, tPassword);
      verify(mockUserDataSource.getLoginUser(tId, tPassword));
      expect(result, equals(Right(tUser)));
    });

    test('should return server failure', () async {
      when(loginRepositoryImpl.getLoginUser(tId, tPassword))
          .thenThrow(ServerException());

      final result = await loginRepositoryImpl.getLoginUser(tId, tPassword);
      verify(mockUserDataSource.getLoginUser(tId, tPassword));
      expect(result, equals(Left(LoginFailure())));
    });
  });
}
