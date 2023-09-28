// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$IndexControllerRouter(IndexController service) {
  final router = Router();
  router.add(
    'GET',
    r'/',
    service._index,
  );
  router.add(
    'GET',
    r'/sitemap',
    service._sitemap,
  );
  router.all(
    r'/<ignored|.*>',
    service._notFound,
  );
  return router;
}
