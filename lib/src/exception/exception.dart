import 'dart:convert';

import 'package:shelf/shelf.dart';

///统一异常
Middleware get tryCatchRequests => (innerHandler) {
      return (request) {
        return Future.sync(() => innerHandler(request)).then((response) {
          return response;
        }, onError: (Object error, StackTrace stackTrace) {
          // 处理异常
          print('Exception occurred: $error');
          return Response.internalServerError(
            body: error.toString(),
            headers: {
              'content-type': 'text/plain',
            },
            encoding: utf8,
          );
        });
      };
    };
