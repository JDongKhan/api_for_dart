import 'package:api_for_dart/db/db_mysql.dart';
import 'package:api_for_dart/utils/jwt_utils.dart';
import 'package:shelf/shelf.dart';

import 'db/db_postgres.dart';

///获取首页接口
Future<Response> login(Request request) async {
  //查询数据库表
  if (MysqlDB.instance.isOpen) {
    final results = await MysqlDB.instance.query('SELECT * FROM your_table_name');
    for (var row in results) {
      print('ID: ${row['id']}, Name: ${row['name']}');
    }
  }
  return Response.ok('hello-world', headers: {
    'Authentication': JwtUtils.encode({}, "your-secret-key"),
  });
}

///获取首页接口
Future<Response> getIndex(Request request) async {
  //查询数据库表
  if (MysqlDB.instance.isOpen) {
    final results = await MysqlDB.instance.query('SELECT * FROM your_table_name');
    for (var row in results) {
      print('ID: ${row['id']}, Name: ${row['name']}');
    }
  }
  return Response.ok('hello-world');
}

///获取用户信息
Future<Response> getUserInfo(Request request, String user) async {
  //创建数据库表
  if (PostgresDB.instance.isOpen) {
    await PostgresDB.instance.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      name TEXT NOT NULL
    )
''');
    //查询数据
    final results = await PostgresDB.instance.query('SELECT * FROM users');
    for (var row in results) {
      print('ID: ${row[0]}, Name: ${row[1]}');
    }
  }
  return Response.ok('hello $user');
}
