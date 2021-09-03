// @dart=2.9

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/login/data/datasources/user_data_source.dart';
import 'package:minden/features/login/data/model/user_model.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  UserDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUpAll(() {
    Config.setEnvironment(Config.kStagingFlavor);
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = UserDataSourceImpl(client: mockHttpClient);
  });

  group('getLoginUser', () {
    final tId = 'nakajo@minden.co.jp';
    final tPassword = '1234qwer';
    final tBody = json.encode({'loginId': tId, 'password': tPassword});

    final Uri tUrl =
        Uri.parse('https://www.stg.minapp.minden.co.jp/api/v1/auth');
    final tUserModel =
        UserModel.fromJson(json.decode(fixture('login_data.json')));

    test('should preform a Post request', () async {
      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: tBody,
        ),
      ).thenAnswer((_) async {
        return http.Response(fixture('login_data.json'), 200, headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        });
      });

      await dataSource.getLoginUser(tId, tPassword);
      verify(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: tBody,
        ),
      );
    });

    test('response code is 200', () async {
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: tBody,
      )).thenAnswer(
        (_) async => http.Response(fixture('login_data.json'), 200, headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        }),
      );
      final result = await dataSource.getLoginUser(tId, tPassword);

      expect(result, equals(tUserModel));
    });

    test('response code is 404', () async {
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: tBody,
      )).thenAnswer(
        (_) async => http.Response('Something went wrong', 404, headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        }),
      );

      final call = dataSource.getLoginUser;
      expect(
          () => call(tId, tPassword), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
