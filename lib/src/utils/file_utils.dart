import 'dart:io';

import 'package:api_for_dart/src/core/result.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';
import 'package:shelf_multipart/multipart.dart';

class FileUtils {
  Future<String> getDownloadPath() async {
    String path = "/Users/sn/Documents/upload";
    Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return path;
  }

  Future<Response> uploadFile(Request request) async {
    if (!request.isMultipart) {
      return Response.ok('Not a multipart request');
    } else if (request.isMultipartForm) {
      String? filename;
      String? path;
      await for (var part in request.parts) {
        var contentDisposition = part.headers['content-disposition'];
        filename = RegExp(r'filename="([^"]*)"').firstMatch(contentDisposition!)?.group(1);
        path = '${await getDownloadPath()}/$filename';
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
}
