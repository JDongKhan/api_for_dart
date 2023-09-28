import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'result.dart';

abstract class Controller {
  bool get needLogin => false;

  ///检查是否登录了
  void checkLogin(Request request) {
    final token = request.headers['token'];
    if (token == null) {
      throw Exception('未登录，请登录');
    }
  }

  Router get router;

  Response error(Result result) {
    return Response.internalServerError(body: result.toString());
  }

  Response response(Result result) {
    return Response.ok(result.toString());
  }
}
