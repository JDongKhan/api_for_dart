import 'package:mysql1/mysql1.dart';

class MysqlDB {
  static MysqlDB get instance => MysqlDB._();
  MysqlDB._();

  late MySqlConnection _connection;
  bool _isOpen = false;
  bool get isOpen => _isOpen;

  ///打开数据
  Future<bool> open() async {
    if (_isOpen) {
      return true;
    }
    _connection = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'your_username',
      password: 'your_password',
      db: 'your_database_name',
    ));
    _isOpen = true;
    return _isOpen;
  }

  Future<Results> query(String sql, [List<Object?>? values]) {
    return _connection.query(sql, values);
  }

  ///关闭数据库
  Future close() async {
    _isOpen = false;
    await _connection.close();
  }
}
