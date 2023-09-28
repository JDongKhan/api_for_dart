import 'dart:async';
import 'dart:io';
import 'package:api_for_dart/src/controller/routes_config.dart';
import 'package:api_for_dart/src/core/auth.dart';
import 'package:api_for_dart/src/env.dart';
import 'package:api_for_dart/src/exception/exception.dart';
import 'package:api_for_dart/src/exception/not_found_response.dart';
import 'package:api_for_dart/src/socket/socket.dart';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

///程序入口
void main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: '帮助')
    ..addOption('file', help: '配置文件路径. 默认是项目下的.env')
    ..addFlag('ssl', help: '是否使用ssl');

  final arguments = parser.parse(args);
  if (arguments.wasParsed('help')) {
    print(parser.usage);
    return;
  }

  final env = Env(
    EnvSource.file,
    arguments['file'],
  ).copyWith(<String, dynamic>{
    for (var name in arguments.options) name: arguments[name],
  });

  //默认127.0.0.1
  final ip = InternetAddress.tryParse(env.ip) ?? InternetAddress.anyIPv4;
  final application = Pipeline().addMiddleware(tryCatchRequests).addMiddleware(logRequests()).addMiddleware(authRequests).addHandler(AllRoutes().handler);

  final staticFileHandler = createStaticHandler(
    env.documentRoot,
    defaultDocument: 'index.html',
  );
  // Configure a pipeline that logs requests.
  final handler = Cascade().add(webSocketHandler).add(staticFileHandler).add(application).handler;

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(env.port);
  final server = await serve(handler, ip, port);

  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
  print('\nwith document root ${env.documentRoot}');
}
