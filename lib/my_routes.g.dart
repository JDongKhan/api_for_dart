// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_routes.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$MyRoutesRouter(MyRoutes service) {
  final router = Router();
  router.add(
    'GET',
    r'/echo/<message>',
    service._echo,
  );
  router.mount(
    r'/auth',
    service._auth.call,
  );
  router.mount(
    r'/post/',
    service._post.call,
  );
  router.mount(
    r'/file/',
    service._file.call,
  );
  router.mount(
    r'/user/',
    service._user.call,
  );
  router.mount(
    r'/admin/',
    service._admin.call,
  );
  router.mount(
    r'/',
    service._index.call,
  );
  return router;
}
