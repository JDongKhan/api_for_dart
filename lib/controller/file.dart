import 'dart:async';
import 'dart:io';

import 'package:api_for_dart/src/core/controller.dart';
import 'package:api_for_dart/src/core/result.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';
import 'package:shelf_multipart/multipart.dart';
import 'package:shelf_router/shelf_router.dart';

part 'file.g.dart';

class FileController extends Controller {
  FileController() : super();

  @Route.post('/upload')
  FutureOr<Response> _upload(Request request) async {
    if (!request.isMultipart) {
      return Response.ok(Result.error('Not a multipart request'));
    } else if (request.isMultipartForm) {
      String? filename;
      String? path;
      await for (var part in request.parts) {
        var contentDisposition = part.headers['content-disposition'];
        filename = RegExp(r'filename="([^"]*)"').firstMatch(contentDisposition!)?.group(1);
        path = '${await _getDownloadPath()}/$filename';
        File? file = File(path);
        IOSink sink = file.openWrite();
        await sink.addStream(part);
        await sink.flush();
        await sink.close();
      }
      return Response.ok(Result(data: {"filePath": path}).toString());
    }
    return Response.ok(Result.error('请求不支持'));
  }

  Future<String> _getDownloadPath() async {
    String path = "/Users/sn/Documents/upload";
    Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return path;
  }

  @override
  Router get router => _$FileControllerRouter(this);
}
