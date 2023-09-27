import 'package:postgres/postgres.dart';

class PostgresDB {
  static PostgresDB get instance => PostgresDB._();
  PostgresDB._();

  final _connection = PostgreSQLConnection("localhost", 5432, "your_database_name", username: "your_username", password: "your_password");
  bool _isOpen = false;
  bool get isOpen => _isOpen;

  ///打开数据
  Future<bool> open() async {
    if (_isOpen) {
      return true;
    }
    bool success = await _connection.open().then((value) => true).catchError((onError) => false);
    _isOpen = success;
    return _isOpen;
  }

  Future<int> execute(
    String fmtString, {
    Map<String, dynamic>? substitutionValues = const {},
    int? timeoutInSeconds,
  }) {
    return _connection.execute(
      fmtString,
      substitutionValues: substitutionValues,
      timeoutInSeconds: timeoutInSeconds,
    );
  }

  Future<PostgreSQLResult> query(
    String fmtString, {
    Map<String, dynamic>? substitutionValues,
    bool? allowReuse,
    int? timeoutInSeconds,
    bool? useSimpleQueryProtocol,
  }) {
    return _connection.query(
      fmtString,
      substitutionValues: substitutionValues,
      allowReuse: allowReuse,
      timeoutInSeconds: timeoutInSeconds,
      useSimpleQueryProtocol: useSimpleQueryProtocol,
    );
  }

  ///关闭数据库
  Future close() async {
    _isOpen = false;
    await _connection.close();
  }
}
