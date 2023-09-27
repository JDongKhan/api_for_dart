import 'package:redis/redis.dart';

class RedisUtil {
  static RedisUtil get instance => RedisUtil._();
  RedisUtil._();

  final _redis = RedisConnection();
  var _isOpen = false;
  bool get isOpen => _isOpen;

  late Command _command;

  ///打开redis
  Future open() async {
    if (_isOpen) {
      return true;
    }
    // 根据实际情况修改主机和端口
    _command = await _redis.connect('localhost', 6379);
    _isOpen = true;
    return _isOpen;
  }

  Future set(String key, String value) async {
    // 设置键值对
    return _command.set(key, value);
  }

  Future get(String key, {String? defaultValue}) async {
    // 设置键值对
    return _command.get(key).then((value) => value ?? defaultValue);
  }

  ///关闭redis
  Future close() {
    return _redis.close();
  }
}
