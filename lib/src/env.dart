import 'dart:io';

import 'package:api_for_dart/src/utils/extesion.dart';
import 'package:ini/ini.dart';

import 'utils/logger_utils.dart';

enum EnvSource {
  file,
  environment,
}

class Env {
  Env.init({
    this.isDebug = false,
    this.port = '8080',
    this.ip = '',
    this.domain = '',
    this.documentRoot = '',
    this.alias = const <String>[],
    this.isSSL = false,
    this.type = 'mysql',
    this.hostName = '',
    this.dataport = 3306,
    this.database = '',
    this.userName = '',
    this.password = '',
  });

  Env.config(Config? config)
      : this.init(
          isDebug: parseBool(
            config?.get('default', 'DEBUG'),
            Platform.executable.contains('dart.exe'),
          ),
          port: config?.get('default', 'PORT') ?? '8080',
          ip: config?.get('default', 'IP') ?? '',
          domain: config?.get('default', 'DOMAIN') ?? '',
          documentRoot: config?.get('default', 'ROOT') ?? '',
          alias: (config?.get('default', 'ALIAS') ?? '').split(' '),
          isSSL: config?.get('default', 'IS_SSL') == '1',
          type: config?.get('DATABASE', 'TYPE') ?? 'mysql',
          hostName: config?.get('DATABASE', 'HOSTNAME') ?? '',
          dataport: int.parse(config?.get('DATABASE', 'DATABASE_PORT') ?? '3306'),
          database: config?.get('DATABASE', 'DATABASE') ?? '',
          userName: config?.get('DATABASE', 'USERNAME') ?? '',
          password: config?.get('DATABASE', 'PASSWORD') ?? '',
        );

  Env.file(String file) : this.config(Config.fromStrings(File(file).readAsLinesSync()));

  Env.json(Map<String, dynamic> env)
      : this.init(
          isDebug: parseBool(
            env['DEBUG'],
            Platform.executable.contains('dart.exe'),
          ),
          port: env['PORT'] ?? '8080',
          ip: env['IP'] ?? '',
          domain: env['DOMAIN'] ?? '',
          documentRoot: env['ROOT'] ?? '',
          alias: env['ALIAS']?.split(' ') ?? <String>[],
          isSSL: env['IS_SSL'] == '1',
          type: env['TYPE'] ?? 'mysql',
          hostName: env['HOSTNAME'] ?? '',
          dataport: int.parse(env['DATABASE_PORT'] ?? '3306'),
          database: env['DATABASE'] ?? '',
          userName: env['USERNAME'] ?? '',
          password: env['PASSWORD'] ?? '',
        );

  Env.environment() : this.json(Platform.environment);

  factory Env([EnvSource src = EnvSource.file, String? path]) {
    switch (src) {
      case EnvSource.file:
        path ??= '.env';
        if (File(path).existsSync()) {
          _instance = Env.file(path);
        } else {
          _instance = Env.config(null);
          logger.warning('config file $path not exists.');
        }
        break;
      case EnvSource.environment:
        _instance = Env.environment();
        break;
    }

    return _instance!;
  }

  static Env? _instance;

  static Env get instance => _instance!;

  final bool isDebug;
  final String port;
  final String ip;
  final String domain;
  final String documentRoot;
  final List<String> alias;
  final bool isSSL;

  final String type;
  final String hostName;
  final int dataport;
  final String database;
  final String userName;
  final String password;

  static bool parseBool(String? value, [bool defaultValue = false]) {
    if (value.isNotNullOrEmpty) {
      return value == '1' || value!.toLowerCase() == 'true';
    }
    return defaultValue;
  }

  Env copyWith(Map<String, dynamic> args) {
    return _instance = Env.init(
      isDebug: args['debug'] ?? false,
      port: args['port'] ?? port,
      ip: args['ip'] ?? ip,
      domain: args['domain'] ?? domain,
      documentRoot: args['root'] ?? documentRoot,
      alias: args['alias'] ?? alias,
      isSSL: args['ssl'] ?? args['no-ssl'] ?? isSSL,
      type: args['type'] ?? type,
      hostName: args['hostname'] ?? hostName,
      dataport: args['database-port'] ?? dataport,
      database: args['database'] ?? database,
      userName: args['username'] ?? userName,
      password: args['password'] ?? password,
    );
  }

  Map<String, dynamic> toJson() => {
        'PORT': port,
        'IP': ip,
        'DOMAIN': domain,
        'ROOT': documentRoot,
        'ALIAS': alias,
        'IS_SSL': isSSL,
        'TYPE': type,
        'HOSTNAME': hostName,
        'DATABASE_PORT': dataport,
        'DATABASE': database,
        'USERNAME': userName,
        'PASSWORD': password,
      };

  @override
  String toString() => toJson().toString();
}
