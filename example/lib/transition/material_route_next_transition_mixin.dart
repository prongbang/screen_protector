import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen_protector_example/transition/custom_page_transition_type.dart';

mixin MaterialRouteNextTransitionMixin<T> on PageRoute<T> {
  /// Builds the primary contents of the route.
  @protected
  Widget buildContent(BuildContext context);

  @protected
  CustomPageTransitionType transitionType();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return (nextRoute is MaterialRouteNextTransitionMixin &&
            !nextRoute.fullscreenDialog) ||
        (nextRoute is CupertinoRouteTransitionMixin &&
            !nextRoute.fullscreenDialog);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget? result = buildContent(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
          'The builder for route "${settings.name}" returned null.\nRoute builders must never return null.',
        );
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final PageTransitionsBuilder matchingBuilder =
        transitionType() == CustomPageTransitionType.rightToLeft
            ? const CupertinoPageTransitionsBuilder()
            : transitionType() == CustomPageTransitionType.bottomToTop
                ? const OpenUpwardsPageTransitionsBuilder()
                : const CupertinoPageTransitionsBuilder();
    return matchingBuilder.buildTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }
}
