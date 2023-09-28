import 'dart:io';

import 'package:api_for_dart/src/utils/extesion.dart';
import 'package:args/args.dart';
import 'package:ini/ini.dart';

import 'utils/logger_utils.dart';

class Env {
  static Env instance = Env._();
  Env._();

  late bool isDebug;
  late String port;
  late String ip;
  //静态资源目录
  late String root;
  late bool isSSL;
  //数据库配置
  late DataBase dataBase;

  Env loadFromArgument(ArgResults arguments) {
    String? path = arguments['file'];
    bool debug = arguments['debug'] ?? false;
    path ??= '.env';
    if (debug) {
      String p = '$path-debug';
      if (File(path).existsSync()) {
        path = p;
      }
    }
    if (File(path).existsSync()) {
      loadFromFile(path);
    } else {
      loadConfig(null);
      logger.warning('config file $path not exists.');
    }
    //复制其他参数
    copyWith(<String, dynamic>{
      for (var name in arguments.options) name: arguments[name],
    });
    return this;
  }

  Env init({
    bool isDebug = false,
    String port = '8080',
    String ip = 'localhost',
    String root = '',
    bool isSSL = false,
    DataBase? dataBase,
  }) {
    this.isDebug = isDebug;
    this.port = port;
    this.ip = ip;
    this.root = root;
    this.isSSL = isSSL;
    this.dataBase = dataBase ?? DataBase();
    return this;
  }

  Env loadConfig(Config? config) => init(
        isDebug: parseBool(
          config?.get('default', 'DEBUG'),
          Platform.executable.contains('dart.exe') || Platform.executable.contains('bin/dart'),
        ),
        port: config?.get('default', 'PORT') ?? '8080',
        ip: config?.get('default', 'IP') ?? 'localhost',
        root: config?.get('default', 'ROOT') ?? '',
        isSSL: config?.get('default', 'IS_SSL') == '1',
        dataBase: DataBase(
          type: config?.get('DATABASE', 'TYPE') ?? 'mysql',
          hostName: config?.get('DATABASE', 'HOSTNAME') ?? '',
          port: int.parse(config?.get('DATABASE', 'DATABASE_PORT') ?? '3306'),
          database: config?.get('DATABASE', 'DATABASE') ?? '',
          userName: config?.get('DATABASE', 'USERNAME') ?? '',
          password: config?.get('DATABASE', 'PASSWORD') ?? '',
        ),
      );

  Env loadFromFile(String file) => loadConfig(Config.fromStrings(File(file).readAsLinesSync()));

  Env loadFromJson(Map<String, dynamic> env) => init(
        isDebug: parseBool(
          env['DEBUG'],
          Platform.executable.contains('dart.exe') || Platform.executable.contains('bin/dart'),
        ),
        port: env['PORT'] ?? '8080',
        ip: env['IP'] ?? 'localhost',
        root: env['ROOT'] ?? '',
        isSSL: env['IS_SSL'] == '1',
        dataBase: DataBase(
          type: env['TYPE'] ?? 'mysql',
          hostName: env['HOSTNAME'] ?? '',
          port: int.parse(env['DATABASE_PORT'] ?? '3306'),
          database: env['DATABASE'] ?? '',
          userName: env['USERNAME'] ?? '',
          password: env['PASSWORD'] ?? '',
        ),
      );

  Env loadFromEnvironment() => loadFromJson(Platform.environment);

  static bool parseBool(String? value, [bool defaultValue = false]) {
    if (value.isNotNullOrEmpty) {
      return value == '1' || value!.toLowerCase() == 'true';
    }
    return defaultValue;
  }

  Env copyWith(Map<String, dynamic> args) {
    init(
      isDebug: args['debug'] ?? false,
      port: args['port'] ?? port,
      ip: args['ip'] ?? ip,
      root: args['root'] ?? root,
      isSSL: args['ssl'] ?? args['no-ssl'] ?? isSSL,
      dataBase: dataBase.copyWith(
        type: args['type'],
        hostName: args['hostname'],
        port: args['database-port'],
        database: args['database'],
        userName: args['username'],
        password: args['password'],
      ),
    );
    return this;
  }

  Map<String, dynamic> toJson() => {
        'PORT': port,
        'IP': ip,
        'ROOT': root,
        'IS_SSL': isSSL,
        'DATABASE': dataBase.toJson(),
      };

  @override
  String toString() => toJson().toString();
}

class DataBase {
  final String type;
  final String hostName;
  final int port;
  final String database;
  final String userName;
  final String password;
  DataBase({
    this.type = 'mysql',
    this.hostName = '',
    this.port = 3306,
    this.database = '',
    this.userName = '',
    this.password = '',
  });

  DataBase copyWith({
    String? type,
    String? hostName,
    int? port = 3306,
    String? database,
    String? userName,
    String? password,
  }) {
    return DataBase(
      type: type ?? this.type,
      hostName: hostName ?? this.hostName,
      port: port ?? this.port,
      database: database ?? this.database,
      userName: userName ?? this.userName,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() => {
        'PORT': port,
        'TYPE': type,
        'HOSTNAME': hostName,
        'DATABASE': database,
        'USERNAME': userName,
        'PASSWORD': password,
      };
}
