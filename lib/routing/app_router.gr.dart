// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;
import 'package:wequil_demo/core/core.dart' as _i1;
import 'package:wequil_demo/core/views/screens/page_not_found.dart' as _i2;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    LandingScreenRoute.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.LandingScreen());
    },
    PageNotFoundScreenRoute.name: (routeData) {
      return _i3.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.PageNotFoundScreen());
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(LandingScreenRoute.name, path: '/'),
        _i3.RouteConfig(PageNotFoundScreenRoute.name, path: '*')
      ];
}

/// generated route for [_i1.LandingScreen]
class LandingScreenRoute extends _i3.PageRouteInfo<void> {
  const LandingScreenRoute() : super(name, path: '/');

  static const String name = 'LandingScreenRoute';
}

/// generated route for [_i2.PageNotFoundScreen]
class PageNotFoundScreenRoute extends _i3.PageRouteInfo<void> {
  const PageNotFoundScreenRoute() : super(name, path: '*');

  static const String name = 'PageNotFoundScreenRoute';
}
