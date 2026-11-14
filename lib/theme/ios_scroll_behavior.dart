import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

/// Scroll como en iPhone en cualquier plataforma:
/// rebote al llegar al borde, se arrastra también con el mouse
/// y sin barras de desplazamiento.
class IosScrollBehavior extends CupertinoScrollBehavior {
  const IosScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  @override
  Widget buildScrollbar(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}
