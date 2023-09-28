import 'dart:async';

import 'package:api_for_dart/src/core/controller.dart';
import 'package:api_for_dart/src/core/result.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'index.g.dart';

class IndexController extends Controller {
  IndexController() : super();

  @Route.get('/')
  FutureOr<Response> _index(Request request) {
    return response(Result(data: 'index'));
  }

  @Route.get('/sitemap')
  FutureOr<Response> _sitemap(Request request) {
    return response(Result(data: 'sitemap'));
  }

  @Route.all('/<ignored|.*>')
  Response _notFound(Request request) => Response.notFound('Page not found');

  @override
  Router get router => _$IndexControllerRouter(this);
}
