import 'dart:async';

import 'package:api_for_dart/src/core/controller.dart';
import 'package:api_for_dart/src/core/result.dart';
import 'package:api_for_dart/src/utils/file_utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'file.g.dart';

class FileController extends Controller {
  FileController() : super();

  @Route.post('/upload')
  FutureOr<Response> _upload(Request request) {
    return FileUtils().uploadFile(request);
  }

  @override
  Router get router => _$FileControllerRouter(this);
}
