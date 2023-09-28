import '../core/module.dart';
import '../model/user.dart';

class UserModule extends Module<User, int> {
  @override
  User parser(Map<String, dynamic> json) => User.fromJson(json);

  @override
  String get primary => 'id';

  @override
  String get table => 'member';
}
