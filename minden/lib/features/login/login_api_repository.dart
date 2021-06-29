import 'package:minden/features/login/data/model/user.dart';
import 'package:minden/features/login/login_api_provider.dart';

class LoginApiRepository {
  final _provider = LoginApiProvider();

  Future<User> fetchUserData({required String id, required String password}) {
    return _provider.fetchUserData(id: id, password: password);
  }
}
