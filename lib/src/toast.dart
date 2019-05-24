import 'dart:async';

import 'package:flutter/material.dart';

class FToast {
  OverlayEntry _overlayEntry;
  Timer _timer;

  void show(
    BuildContext context,
    Widget child, {
    Duration duration,
    AlignmentGeometry alignment,
    EdgeInsetsGeometry margin,
  }) {
    showCustom(
      context,
      _ToastWidget(
        child: child,
        alignment: alignment,
        margin: margin,
      ),
      duration: duration,
    );
  }

  void showCustom(
    BuildContext context,
    Widget child, {
    Duration duration,
  }) {
    final OverlayState overlayState = Overlay.of(context);

    dismiss();
    _overlayEntry = OverlayEntry(builder: (context) {
      return child;
    });
    overlayState.insert(_overlayEntry);

    duration ??= const Duration(
      seconds: 1,
      milliseconds: 500,
    );

    _timer = Timer(duration, () {
      dismiss();
    });
  }

  void dismiss() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }
}

class _ToastWidget extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry margin;

  _ToastWidget({
    this.child,
    Alignment alignment,
    this.margin,
  })  : assert(child != null),
        this.alignment = alignment ?? Alignment.bottomCenter;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final EdgeInsetsGeometry padding =
        margin ?? EdgeInsets.all(mediaQueryData.size.width / 10);

    return Container(
      alignment: alignment,
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        constraints: BoxConstraints(
          minHeight: 40,
        ),
        padding: EdgeInsets.only(
          left: 10,
          top: 5,
          right: 10,
          bottom: 5,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
