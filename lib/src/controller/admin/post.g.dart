// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$PostControllerRouter(PostController service) {
  final router = Router();
  router.add(
    'GET',
    r'/index',
    service._index,
  );
  router.add(
    'GET',
    r'/detail/<id|\d+>',
    service._detail,
  );
  router.add(
    'POST',
    r'/create',
    service._create,
  );
  router.add(
    'POST',
    r'/update/<id|\d+>',
    service._update,
  );
  return router;
}
