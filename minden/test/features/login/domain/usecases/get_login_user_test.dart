import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/login/domain/repositories/login_repository.dart';
import 'package:minden/features/login/domain/usecases/get_login_user.dart';
import 'package:mockito/mockito.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late GetLoginUser usecase;
  late MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = GetLoginUser(mockLoginRepository);
  });

  final tId = 'nakajo@minden.co.jp';
  final tPassword = '1234qwer';
  final tUser = User(
    contractor: "�݂�ȁ@�d��",
    accountId: "20190707085551963zhayz",
    wallPaper:
        "https://dq2i58msgjbtb.cloudfront.net/media/1629388524511-nakajo@minden.co.jp-Screenshot_(5).png",
    loginId: "nakajo@minden.co.jp",
    name: "huyen",
    icon:
        "https://dq2i58msgjbtb.cloudfront.net/media/1629388524511-nakajo@minden.co.jp-Screenshot_(5).png",
    limitedPlantId: "limitedPlantIdxxx",
    bio: "<html> <b>a</b></html>",
    supports:
        Supports(yearMonth: "2021-08", plantId: "plantIdxxx", status: "3"),
    contracts: Contracts(contractId: "契約プランID", name: "契約プラン名称"),
    userId: "20190707085551963zhayz",
  );

  test('should get user', () async {
    when(mockLoginRepository.getLoginUser(tId, tPassword))
        .thenAnswer((_) async => Right(tUser));

    final result = await usecase(Params(id: tId, password: tPassword));

    expect(result, Right(tUser));
    verify(mockLoginRepository.getLoginUser(tId, tPassword));
    verifyNoMoreInteractions(mockLoginRepository);
  });
}
