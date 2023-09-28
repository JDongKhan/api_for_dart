import 'dart:async';

import 'package:api_for_dart/src/core/controller.dart';
import 'package:api_for_dart/src/core/result.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'post.g.dart';

class PostController extends Controller {
  PostController() : super();

  @Route.get('/index')
  FutureOr<Response> _index(Request request) {
    return response(Result(data: 'post index'));
  }

  @Route.get('/list')
  FutureOr<Response> _list(Request request) {
    return response(Result(data: 'post list'));
  }

  @Route.get('/view/<id|\\d+>')
  FutureOr<Response> _view(Request request, String id) {
    final intId = int.parse(id);
    if (intId <= 0) {
      return response(Result.error('Argument error'));
    }
    return response(Result(data: 'post view $intId'));
  }

  @Route.get('/category')
  FutureOr<Response> _category(Request request) {
    return response(Result(data: 'post category'));
  }

  @Route.all('/<ignored|.*>')
  Response _notFound(Request request) => Response.notFound('post action error.');

  @override
  Router get router => _$PostControllerRouter(this);
}
