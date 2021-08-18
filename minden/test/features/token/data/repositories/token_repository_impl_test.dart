import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/token/data/datasources/token_data_source.dart';
import 'package:minden/features/token/data/model/token_model.dart';
import 'package:minden/features/token/data/repositories/token_repository_impl.dart';
import 'package:minden/features/token/domain/entities/token.dart';
import 'package:mockito/mockito.dart';

class MockTokenDataSource extends Mock implements TokenDataSource {}

void main() {
  late TokenRepositoryImpl tokenRepositoryImpl;
  late MockTokenDataSource mockTokenDataSource;

  setUp(() {
    mockTokenDataSource = MockTokenDataSource();
    tokenRepositoryImpl =
        TokenRepositoryImpl(tokenDataSource: mockTokenDataSource);
  });

  group('getToken', () {
    const tAppToken =
        'eyJraWQiOiJ3S3BBS3kwZXV5YThmcjc1VExMSjBRMG1GRUtGcnBLV3A2MVhtbjV2b3lrPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJjODNlNWMxZC0wZmM5LTRlOTgtOWVmMi1hNGViYzNmNjNiZjIiLCJldmVudF9pZCI6Ijk5ZmI5MDMxLTZjZTMtNDJjZC04ODU4LTc3ODc2MjM2NzdkOSIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE2MjU2MjkzNDMsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC5hcC1ub3J0aGVhc3QtMS5hbWF6b25hd3MuY29tXC9hcC1ub3J0aGVhc3QtMV82WWk2T1psSXQiLCJleHAiOjE2MjU2MzI5NDMsImlhdCI6MTYyNTYyOTM0MywianRpIjoiODY1MzJkOWUtZTUzYS00N2MyLThmZjUtNjRlYTRhMDYxM2ZmIiwiY2xpZW50X2lkIjoiNXZmODBiM3RsbjJxN2dlODdhZjF2dGN1dGMiLCJ1c2VybmFtZSI6IjIwMTkwNzA3MDg1NTUxOTYzemhheXoifQ.RkqkjVlwir65jZ7z-wJ7z8QJNattiv2dwIJ1sF0LLErmnwczGwZUXqrGshU7SYwlqCiNlJtnNTr6_ik7avfnF3zmdairtasD6iHl5KKbRNSFuoJ3A3v-DavTPPdBokxFajTEs0pUwjZ9IKywFEc7xtKnocE1HNUPrm9pmXKTppHiDWx3_3Qe3za0tL2QUhy1Pz0afFEKEIkK0NGJE0z_ZpXgqK0zYCsu_QPzjEhu3ObMr9SqHyFuvYSQ0QSnkbYw92iemzjiE0_NtRCwiUVLeYOmqEXDXfiwqmGZhmKkvLF3wrpMdZb-xNky6K7szF6cZXyxRYewgcn-Nc8R7trdVw';
    const tRefreshToken =
        'eyJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAifQ.JtSOnTmb5fpbTzpgj4kZvpmxJjRrqVPwz9F82i4a_booKx11TjxpRQBK6djuyPoIUyD3pJsVfViBzFTnrynnTNiR22hKvZSJQwE4xWhbClRX590vK5e0szU0pkOZamLy-SfGvRmUkmTGNkz5yIJceLzqL0hZ3-QMF7it_btzxvQS1tgzRGp6X_zr71rLspc-tPGkBd_vdEHGr29-MgG3L0UBb1Dv4kGskJo6n_WdTfbjFneRG7SDyDd59pieHuN-xpQhvEmBN9xFD9u3jCagT5scgzYqFpnVJpcqBXLJc9vytgjpSFXfm91XkkJ_hmHWLbZ-zPE2WOsRYxc7RUyf4A.yFpc_oy_akGq_VCW.wduhg4JmIWV4iyDzH0sR-0SxRGl8ToEJXYiufaTo8PwfmVK7HgpbwcrC4e0s9NpxBlElQhIaIUPOOYz_F1qH9bVQSCqpmP_0NYUN_ooGj-urBLMzdLRDNy-SN3MXbdPl5Ah85A2QXqv11fT6pjg2c40PEgwNMywvlLQsNH494BzGT6tu9BRAlKCjER_omw-FIyqRzmRtMIl2NK6COB8voYOa73W_3rYJ2kkwLHo7k-sPBaDqIFE0CbW9TkOtUtTJ3iBfazt2JIyE_-qaBLUQJbJJJA1SF1atq5vKib4FNKFdoloss5SujrOUgvKtL6KSW-EL_YL8eDoFsFJjAjVimiBxpy-cU_rcyKj2quT1MtgW7-W6qWZG8cCceSOOuYn9wSqhGnnXjZ7RSegVDHY84CRd3mYz7115ErmdbRbZG2TpQFOV2nGVU2Qq22Ok-1n5BC5Pr-vREMD0zvVDdI577ozc0TDLC7AwqbUMxt5X_2LqZgxYR10C1O3-CPmuh9NBob82cFudqAj4bStKZ9qybWQV4O5GRVRpKhysyiXdHCMcfbkIkSgFq7AoQxkfQc9OgmXqWHeaayursbbEzSATXMg2h5Uha3sgKaTck0E7PnW5NujYa1x8iuKwU-zyoDnc2FJ6zLbtsEzUbHXkCeOH32hG1RDWgWPE5jY20Fv1jLaPlQXPCYSh1SgoObKUJ8QfLYRaMpFoezy6T1s9qupYpTB9lh6nlfa96N86rIDWoBDWAIKI5hhvldFihN8q8hZotEdDeACl4Y-jwG3v3K6e3U-lvdI59KGPm8I560GLb5eJTUg_xplaInFO7pT6DmAf0Tue0CqU0PTMJ8lp5fgUn1xMv0uzbTbdNo0Dj_naXDqA-4bizKl7At4YyFQMnUecqtSyw7v9Ge7vKEfzkrzzwegR0eZ-d42dLlK-jgEFGwkI--_DixJkTDvlFdYWL51gp5f4qVyiI5HwY2AKwj2_8w-LhcRqez6IiQHqetk-FUyuAP5Z9DpJbiTjiMPrsTVor3GlqGic3I7pLBQtJgUs0Bwv1jJ_V0wWZveXl45l-ZJ1CX0KS77yQEla0E-THCzKhEe_lSoOEF-QJKekG1nO9eB-yUEQJrWbbwoQqkxjoUQWetyQ7027xpIkeo4j6qJvUOs-iyp5u-WhWd4cnIeO_F7qH7LoV9ecmA5sHuk5cAfBlBCN-izjNjxuwjttT9y5aaZQlEPBy-VQ-FiXKquDEJsYLgaT8hBN-r5JMIYeZIukTQMh2J1q_u93uhVCA4p8xeT_pw1Jgsgvz6etuEsvoTKPXalSf_3J3mrE7Lezw43kq3aSwhpixa8.XYB38pbaa7QMXaQoVNpWDg';
    const tTokenModel = TokenModel(
      appToken: tAppToken,
      refreshToken: tRefreshToken,
    );

    const Token tToken = tTokenModel;

    test('should return remote data', () async {
      when(mockTokenDataSource.getToken(tRefreshToken))
          .thenAnswer((_) async => tTokenModel);

      final result = await tokenRepositoryImpl.getToken(tRefreshToken);
      verify(mockTokenDataSource.getToken(tRefreshToken));
      expect(result, equals(const Right(tToken)));
    });

    test('should return server failure', () async {
      when(tokenRepositoryImpl.getToken(tRefreshToken))
          .thenThrow(ServerException());

      final result = await tokenRepositoryImpl.getToken(tRefreshToken);
      verify(mockTokenDataSource.getToken(tRefreshToken));
      expect(result, equals(Left(RenewTokenFailure())));
    });
  });
}
