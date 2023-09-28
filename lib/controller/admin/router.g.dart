// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AdminRouterRouter(AdminRouter service) {
  final router = Router();
  router.mount(
    r'/auth/',
    service._auth.call,
  );
  router.mount(
    r'/post/',
    service._post.call,
  );
  router.mount(
    r'/user/',
    service._user.call,
  );
  router.mount(
    r'/admin/',
    service._admin.call,
  );
  router.all(
    r'/<ignored|.*>',
    service._notFound,
  );
  return router;
}
