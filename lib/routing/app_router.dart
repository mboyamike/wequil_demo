import 'package:auto_route/auto_route.dart';
import 'package:wequil_demo/core/core.dart';
import 'package:wequil_demo/core/views/screens/page_not_found.dart';

@AdaptiveAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: LandingScreen, initial: true, path: LandingScreen.path),
    AutoRoute(page: PageNotFoundScreen, path: '*'),
  ]
)
class $AppRouter {}