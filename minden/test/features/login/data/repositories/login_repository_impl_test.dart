import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/login/data/datasources/user_data_source.dart';
import 'package:minden/features/login/data/model/user_model.dart';
import 'package:minden/features/login/data/repositories/login_repository_impl.dart';
import 'package:minden/features/login/domain/entities/user.dart';
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
      contractor: "�݂�ȁ@�d��",
      accountId: "20190707085551963zhayz",
      wallPaper:
          "https://dq2i58msgjbtb.cloudfront.net/media/1629388524511-nakajo@minden.co.jp-Screenshot_(5).png",
      loginId: "nakajo@minden.co.jp",
      name: "<b>a</b>",
      icon:
          "https://dq2i58msgjbtb.cloudfront.net/media/1629388524511-nakajo@minden.co.jp-Screenshot_(5).png",
      limitedPlantId: "MP2021080805",
      bio: "<html> <b>a</b></html>",
      supports: null,
      contracts: Contracts(contractId: "契約プランID", name: "契約プラン名称"),
      userId: "20190707085551963zhayz",
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
