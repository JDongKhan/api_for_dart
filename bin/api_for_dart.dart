import 'dart:async';

import 'package:api_for_dart/db_mysql.dart';
import 'package:api_for_dart/db_postgres.dart';
import 'package:api_for_dart/index.dart';
import 'package:api_for_dart/redis_utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

///程序入口
void main(List<String> arguments) async {
  //打开数据库
  // await MysqlDB.instance.open();
  // //打开数据库
  // await PostgresDB.instance.open();
  // //打开缓存
  // await RedisUtil.instance.open();

  var app = Router();
  app.get('/hello', (Request request) {
    return getIndex(request);
  });
  app.get('/user/<user>', (Request request, String user) {
    return getUserInfo(request, user);
  });

  //添加日志
  var handler = const Pipeline().addMiddleware(logRequests()).addMiddleware(tryCatchRequests()).addHandler(app);
  var server = await shelf_io.serve(handler, 'localhost', 8080);
  // Enable content compression
  server.autoCompress = true;
  print('Serving at http://${server.address.host}:${server.port}');
}

///统一异常
Middleware tryCatchRequests() => (innerHandler) {
      return (request) {
        return Future.sync(() => innerHandler(request)).then((response) {
          return response;
        }, onError: (Object error, StackTrace stackTrace) {
          // 处理异常
          print('Exception occurred: $error');
          return Response.internalServerError(body: error.toString());
        });
      };
    };
