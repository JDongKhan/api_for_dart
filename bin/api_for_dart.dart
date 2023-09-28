import 'dart:io';
import 'package:api_for_dart/my_routes.dart';
import 'package:api_for_dart/src/core/result.dart';
import 'package:api_for_dart/src/env.dart';
import 'package:api_for_dart/src/exception/exception.dart';
import 'package:api_for_dart/src/globals.dart';
import 'package:api_for_dart/src/socket/socket.dart';
import 'package:api_for_dart/src/utils/jwt_utils.dart';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';

///程序入口
void main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: '帮助')
    ..addOption('file', help: '配置文件路径. 默认是项目下的.env')
    ..addFlag('debug', help: '是否是debug模式,默认release')
    ..addFlag('ssl', help: '是否使用ssl');

  final arguments = parser.parse(args);
  if (arguments.wasParsed('help')) {
    print(parser.usage);
    return;
  }

  // print(Platform.executable);
  // print(Platform.environment);

  final env = Env.instance.loadFromArgument(arguments);
  //默认127.0.0.1
  final ip = InternetAddress.tryParse(env.ip) ?? InternetAddress.anyIPv4;
  final application = Pipeline().addMiddleware(tryCatchRequests).addMiddleware(logRequests()).addMiddleware(authRequests).addHandler(MyRoutes().handler);

  //静态资源
  final staticFileHandler = createStaticHandler(
    env.root,
    defaultDocument: 'index.html',
  );
  // Configure a pipeline that logs requests.
  final handler = Cascade().add(webSocketHandler).add(staticFileHandler).add(application).handler;

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(env.port);
  final server = await serve(handler, ip, port);

  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}  with document root:${env.root}');
}

///验证token是否有效
Handler authRequests(Handler innerHandler) {
  return (Request request) async {
    final token = request.headers['token'] ?? '';
    if (token.isNotEmpty) {
      //验证toke是否有效
      final tokenModel = JwtUtils.isExpired(token);
      if (!tokenModel) {
        return Response.forbidden(
          Result.error('Invalid token', code: errorTokenInvalid),
        );
      }
    }
    return innerHandler(request);
  };
}
