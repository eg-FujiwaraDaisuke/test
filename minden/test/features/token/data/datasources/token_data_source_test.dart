// @dart=2.9

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/env/config.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/features/token/data/datasources/token_data_source.dart';
import 'package:minden/features/token/data/model/token_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'token_data_source_test.mocks.dart';

class MockHttpClient extends Mock implements http.Client {}

@GenerateMocks([EncryptionTokenDataSource])
void main() {
  TokenDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;
  MockEncryptionTokenDataSource mockEncryptionTokenDataSource;

  setUpAll(() {
    Config.setEnvironment(Config.kStagingFlavor);
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockEncryptionTokenDataSource = MockEncryptionTokenDataSource();
    dataSource = TokenDataSourceImpl(
      client: mockHttpClient,
      encrypztionTokenDataSource: mockEncryptionTokenDataSource,
    );
  });

  group('requestRefreshToken', () {
    const tRefreshToken = '''
eyJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAifQ.JtSOnTmb5fpbTzpgj4kZvpmxJjRrqVPwz9F82i4a_booKx11TjxpRQBK6djuyPoIUyD3pJsVfViBzFTnrynnTNiR22hKvZSJQwE4xWhbClRX590vK5e0szU0pkOZamLy-SfGvRmUkmTGNkz5yIJceLzqL0hZ3-QMF7it_btzxvQS1tgzRGp6X_zr71rLspc-tPGkBd_vdEHGr29-MgG3L0UBb1Dv4kGskJo6n_WdTfbjFneRG7SDyDd59pieHuN-xpQhvEmBN9xFD9u3jCagT5scgzYqFpnVJpcqBXLJc9vytgjpSFXfm91XkkJ_hmHWLbZ-zPE2WOsRYxc7RUyf4A.yFpc_oy_akGq_VCW.wduhg4JmIWV4iyDzH0sR-0SxRGl8ToEJXYiufaTo8PwfmVK7HgpbwcrC4e0s9NpxBlElQhIaIUPOOYz_F1qH9bVQSCqpmP_0NYUN_ooGj-urBLMzdLRDNy-SN3MXbdPl5Ah85A2QXqv11fT6pjg2c40PEgwNMywvlLQsNH494BzGT6tu9BRAlKCjER_omw-FIyqRzmRtMIl2NK6COB8voYOa73W_3rYJ2kkwLHo7k-sPBaDqIFE0CbW9TkOtUtTJ3iBfazt2JIyE_-qaBLUQJbJJJA1SF1atq5vKib4FNKFdoloss5SujrOUgvKtL6KSW-EL_YL8eDoFsFJjAjVimiBxpy-cU_rcyKj2quT1MtgW7-W6qWZG8cCceSOOuYn9wSqhGnnXjZ7RSegVDHY84CRd3mYz7115ErmdbRbZG2TpQFOV2nGVU2Qq22Ok-1n5BC5Pr-vREMD0zvVDdI577ozc0TDLC7AwqbUMxt5X_2LqZgxYR10C1O3-CPmuh9NBob82cFudqAj4bStKZ9qybWQV4O5GRVRpKhysyiXdHCMcfbkIkSgFq7AoQxkfQc9OgmXqWHeaayursbbEzSATXMg2h5Uha3sgKaTck0E7PnW5NujYa1x8iuKwU-zyoDnc2FJ6zLbtsEzUbHXkCeOH32hG1RDWgWPE5jY20Fv1jLaPlQXPCYSh1SgoObKUJ8QfLYRaMpFoezy6T1s9qupYpTB9lh6nlfa96N86rIDWoBDWAIKI5hhvldFihN8q8hZotEdDeACl4Y-jwG3v3K6e3U-lvdI59KGPm8I560GLb5eJTUg_xplaInFO7pT6DmAf0Tue0CqU0PTMJ8lp5fgUn1xMv0uzbTbdNo0Dj_naXDqA-4bizKl7At4YyFQMnUecqtSyw7v9Ge7vKEfzkrzzwegR0eZ-d42dLlK-jgEFGwkI--_DixJkTDvlFdYWL51gp5f4qVyiI5HwY2AKwj2_8w-LhcRqez6IiQHqetk-FUyuAP5Z9DpJbiTjiMPrsTVor3GlqGic3I7pLBQtJgUs0Bwv1jJ_V0wWZveXl45l-ZJ1CX0KS77yQEla0E-THCzKhEe_lSoOEF-QJKekG1nO9eB-yUEQJrWbbwoQqkxjoUQWetyQ7027xpIkeo4j6qJvUOs-iyp5u-WhWd4cnIeO_F7qH7LoV9ecmA5sHuk5cAfBlBCN-izjNjxuwjttT9y5aaZQlEPBy-VQ-FiXKquDEJsYLgaT8hBN-r5JMIYeZIukTQMh2J1q_u93uhVCA4p8xeT_pw1Jgsgvz6etuEsvoTKPXalSf_3J3mrE7Lezw43kq3aSwhpixa8.XYB38pbaa7QMXaQoVNpWDg''';
    final tBody = json.encode({});
    final tTokenModel =
        TokenModel.fromJson(json.decode(fixture('token_data.json')));

    test('should preform a Post request', () async {
      // setup
      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: tBody,
        ),
      ).thenAnswer(
        (_) async => http.Response(
          fixture('token_data.json'),
          200,
        ),
      );

      // exercise
      await dataSource.requestRefreshToken(tRefreshToken);

      // verify
      verify(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: tBody,
        ),
      );
    });

    test('response code is 200', () async {
      // setup
      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: tBody,
        ),
      ).thenAnswer(
        (_) async => http.Response(
          fixture('token_data.json'),
          200,
        ),
      );

      // exercise
      final result = await dataSource.requestRefreshToken(tRefreshToken);

      // verify
      expect(result, equals(tTokenModel));
    });

    test('response code is 404', () async {
      // setup
      when(mockHttpClient.post(
        any,
        headers: anyNamed('headers'),
        body: tBody,
      )).thenAnswer(
        (_) async => http.Response(
          'Something went wrong',
          404,
        ),
      );

      // exercise/verify
      expect(
        () => dataSource.requestRefreshToken(tRefreshToken),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });
  });
}
