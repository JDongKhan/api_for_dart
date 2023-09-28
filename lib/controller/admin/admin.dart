import 'dart:async';

import 'package:api_for_dart/src/core/controller.dart';
import 'package:api_for_dart/src/core/result.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'admin.g.dart';

class AdminController extends Controller {
  AdminController() : super();

  @override
  bool get needLogin => true;

  @Route.get('/index')
  FutureOr<Response> _index(Request request) {
    checkLogin(request);
    return response(Result(data: 'index'));
  }

  @Route.get('/detail/<id|\\d+>')
  FutureOr<Response> _detail(Request request, String id) {
    final intId = int.parse(id);
    if (intId <= 0) {
      return response(Result.error('Argument error'));
    }
    return response(Result(data: 'detail $id'));
  }

  @Route.post('/create')
  FutureOr<Response> _create(Request request) {
    return response(Result(data: 'update'));
  }

  @Route.post('/update/<id|\\d+>')
  FutureOr<Response> _update(Request request, String id) {
    final intId = int.parse(id);
    if (intId <= 0) {
      return response(Result.error('Argument error'));
    }
    return response(Result(data: 'update $id'));
  }

  @override
  Router get router => _$AdminControllerRouter(this);
}
