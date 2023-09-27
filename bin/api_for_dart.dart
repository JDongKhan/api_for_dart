import 'dart:async';

import 'package:api_for_dart/db/db_mysql.dart';
import 'package:api_for_dart/index.dart';
import 'package:api_for_dart/utils/jwt_utils.dart';
import 'package:api_for_dart/utils/redis_utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../lib/router_config.dart';

///程序入口
void main(List<String> arguments) async {
  //打开数据库
  // await MysqlDB.instance.open();
  // //打开数据库
  // await PostgresDB.instance.open();
  // //打开缓存
  // await RedisUtil.instance.open();

  var app = Router();
  //配置路由
  routerConfig.forEach((key, value) {
    RouterConfig config = value;
    if (config.method == RequestMethod.get) {
      app.get(key, config.response);
    } else if (config.method == RequestMethod.post) {
      app.post(key, config.response);
    } else if (config.method == RequestMethod.delete) {
      app.delete(key, config.response);
    } else if (config.method == RequestMethod.put) {
      app.put(key, config.response);
    } else if (config.method == RequestMethod.head) {
      app.head(key, config.response);
    }
  });

  //添加日志
  var handler = const Pipeline().addMiddleware(logRequests()).addMiddleware(tryCatchRequests).addMiddleware(jwtRequests).addHandler(app);
  var server = await shelf_io.serve(handler, 'localhost', 8080);
  // Enable content compression
  server.autoCompress = true;
  print('Serving at http://${server.address.host}:${server.port}');
}

///统一异常
Middleware get tryCatchRequests => (innerHandler) {
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

///jwt验证
Middleware get jwtRequests => (innerHandler) {
      return (request) {
        String path = request.url.path;
        RouterConfig? config = routerConfig[path];
        if (config != null && config.needLogin) {
          // 从请求头获取 JWT Token
          final jwtToken = request.context['authenticated'] as String?;
          if (jwtToken != null) {
            try {
              // 验证 JWT Token
              if (!JwtUtils.isExpired(jwtToken)) {
                // 返回成功的响应
                return Response.forbidden('Invalid JWT Token');
              }
            } catch (ex) {
              // 验证失败，返回未授权的响应
              return Response.forbidden('Invalid JWT Token');
            }
          }
        }
        return innerHandler(request);
      };
    };
