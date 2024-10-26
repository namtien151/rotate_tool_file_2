// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i7;
import 'package:flutter/material.dart';
import 'package:roate_text_tool2/ui/views/home/home_view.dart' as _i2;
import 'package:roate_text_tool2/ui/views/rotate_tool/rotate_tool_view.dart'
    as _i5;
import 'package:roate_text_tool2/ui/views/split_tool/split_tool_view.dart'
    as _i6;
import 'package:roate_text_tool2/ui/views/startup/startup_view.dart' as _i3;
import 'package:roate_text_tool2/ui/views/top_bar/top_bar_view.dart' as _i4;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i8;

class Routes {
  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const topBarView = '/top-bar-view';

  static const rotateToolView = '/rotate-tool-view';

  static const splitToolView = '/split-tool-view';

  static const all = <String>{
    homeView,
    startupView,
    topBarView,
    rotateToolView,
    splitToolView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i3.StartupView,
    ),
    _i1.RouteDef(
      Routes.topBarView,
      page: _i4.TopBarView,
    ),
    _i1.RouteDef(
      Routes.rotateToolView,
      page: _i5.RotateToolView,
    ),
    _i1.RouteDef(
      Routes.splitToolView,
      page: _i6.SplitToolView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.StartupView(),
        settings: data,
      );
    },
    _i4.TopBarView: (data) {
      final args = data.getArgs<TopBarViewArguments>(nullOk: false);
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.TopBarView(
            key: args.key,
            screenHeight: args.screenHeight,
            screenWidth: args.screenWidth),
        settings: data,
      );
    },
    _i5.RotateToolView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.RotateToolView(),
        settings: data,
      );
    },
    _i6.SplitToolView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.SplitToolView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class TopBarViewArguments {
  const TopBarViewArguments({
    this.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final _i7.Key? key;

  final double screenHeight;

  final double screenWidth;

  @override
  String toString() {
    return '{"key": "$key", "screenHeight": "$screenHeight", "screenWidth": "$screenWidth"}';
  }

  @override
  bool operator ==(covariant TopBarViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.screenHeight == screenHeight &&
        other.screenWidth == screenWidth;
  }

  @override
  int get hashCode {
    return key.hashCode ^ screenHeight.hashCode ^ screenWidth.hashCode;
  }
}

extension NavigatorStateExtension on _i8.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTopBarView({
    _i7.Key? key,
    required double screenHeight,
    required double screenWidth,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.topBarView,
        arguments: TopBarViewArguments(
            key: key, screenHeight: screenHeight, screenWidth: screenWidth),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRotateToolView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.rotateToolView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSplitToolView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.splitToolView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTopBarView({
    _i7.Key? key,
    required double screenHeight,
    required double screenWidth,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.topBarView,
        arguments: TopBarViewArguments(
            key: key, screenHeight: screenHeight, screenWidth: screenWidth),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRotateToolView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.rotateToolView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplitToolView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.splitToolView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
