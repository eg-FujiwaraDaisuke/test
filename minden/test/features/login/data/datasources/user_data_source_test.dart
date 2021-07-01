import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/login/data/datasources/user_data_source.dart';
import 'package:minden/features/login/data/model/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late UserDataSourceImpl dataSourceImpl;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = UserDataSourceImpl(client: mockHttpClient);
  });

  group('getLoginUser', () {
    final tId = 'nakajo@minden.co.jp';
    final tPassword = '1234qwer';
    final tBody = json.encode({'loginId': tId, 'password': tPassword});
    final tUserModel =
        UserModel.fromJson(json.decode(fixture('login_data.json')));
    test('should preform a Post request', () {
      when(
        mockHttpClient.post(any, headers: anyNamed('header'), body: tBody),
      ).thenAnswer(
        (_) async => http.Response(fixture('login_data.json'), 200),
      );

      dataSourceImpl.getLoginUser(tId, tPassword);
      verify(
        mockHttpClient.post(
          'https://bgzprevlv9.execute-api.ap-northeast-1.amazonaws.com/dev/auth',
          headers: {
            'content-type': 'application/json',
            'x-client-id': '5vf80b3tln2q7ge87af1vtcutc'
          },
          body: tBody,
        ),
      );
    });

    // test('response code is 200', () async {
    //   when(mockHttpClient.post(any, headers: anyNamed('headers'), body: tBody))
    //       .thenAnswer(
    //     (_) async => http.Response(fixture('login_data.json'), 200),
    //   );
    //   final result = await dataSourceImpl.getLoginUser(tId, tPassword);
    //   expect(result, equals(tUserModel));
    // });

    // test('response code is 404', () async {
    //   when(mockHttpClient.post(any, headers: anyNamed('headers'), body: tBody))
    //       .thenAnswer(
    //     (_) async => http.Response('Something went wrong', 404),
    //   );

    //   final call = dataSourceImpl.getLoginUser;
    //   expect(
    //       () => call(tId, tPassword), throwsA(TypeMatcher<ServerException>()));
    // });
  });
}
