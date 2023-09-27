import 'package:api_for_dart/index.dart';

//路由配置
Map<String, RouterConfig> routerConfig = {
  "/login": RouterConfig(response: login, needLogin: false),
  "/hello": RouterConfig(response: getIndex, needLogin: false),
  '/user/<user>': RouterConfig.response(response: getUserInfo),
};

enum RequestMethod {
  get,
  post,
  put,
  head,
  delete,
}

class RouterConfig {
  final Function response;
  final bool needLogin;
  final RequestMethod method;
  RouterConfig({required this.response, this.needLogin = true, this.method = RequestMethod.get});

  RouterConfig.response({required this.response, this.method = RequestMethod.get}) : needLogin = true;
}
