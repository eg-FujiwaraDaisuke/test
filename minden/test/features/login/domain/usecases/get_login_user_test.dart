import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/login/domain/repositories/login_repository.dart';
import 'package:minden/features/login/domain/usecases/login_usecase.dart';
import 'package:minden/features/user/domain/entities/profile.dart';
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
      // key: "20190707085551963zhayz",
      loginId: "nakajo@minden.co.jp",
      accountId: "",
      limitedPlantId: "",
      supportableNumber: 1,
      contractor: "",
      profile: const Profile(
        bio: '',
        name: '',
        userId: '',
        wallPaper: '',
        tags: [],
        icon: '',
      )
      // userId : "",
      // name: "�݂�ȁ@�d��",
      // secret: "20000102",
      // provider: "MINDEN",
      // service: "portal",
      // email: "nakajo@minden.co.jp",
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
