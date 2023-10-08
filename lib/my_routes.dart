import 'package:api_for_dart/controller/file.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'controller/auth.dart';
import 'controller/post.dart';
import 'controller/user.dart';
import 'controller/index.dart';
import 'controller/admin/router.dart' as admin;
part 'my_routes.g.dart';

class MyRoutes {
  @Route.get('/echo/<message>')
  Response _echo(Request request, String message) => Response.ok(message);

  @Route.mount('/auth')
  Router get _auth => AuthController().router;

  @Route.mount('/post/')
  Router get _post => PostController().router;

  @Route.mount('/file/')
  Router get _file => FileController().router;

  @Route.mount('/user/')
  Router get _user => UserController().router;

  @Route.mount('/admin/')
  Router get _admin => admin.AdminRouter().router;

  @Route.mount('/')
  Router get _index => IndexController().router;

  Handler get handler => _$MyRoutesRouter(this);
}
