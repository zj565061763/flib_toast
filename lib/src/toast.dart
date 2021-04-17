import 'dart:async';

import 'package:flutter/material.dart';

class FToast {
  OverlayEntry? _overlayEntry;
  Timer? _timer;

  /// 显示文字
  void show(
    BuildContext context,
    String text, {
    Duration? duration,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
  }) {
    showContent(
      context,
      Text(text),
      duration: duration,
      alignment: alignment,
      margin: margin,
      backgroundColor: backgroundColor,
    );
  }

  /// 显示内容Widget
  void showContent(
    BuildContext context,
    Widget child, {
    Duration? duration,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
  }) {
    showCustom(
      context,
      _ToastWidget(
        child: child,
        alignment: alignment,
        margin: margin,
        backgroundColor: backgroundColor,
      ),
      duration: duration,
    );
  }

  /// 显示传入的Widget
  bool showCustom(
    BuildContext context,
    Widget child, {
    Duration? duration,
  }) {
    dismiss();

    final OverlayState? overlayState = Overlay.of(context);
    if (overlayState == null) return false;

    _overlayEntry = OverlayEntry(builder: (context) {
      return child;
    });
    overlayState.insert(_overlayEntry!);

    duration ??= const Duration(seconds: 2);
    _timer = Timer(duration, () {
      dismiss();
    });

    return true;
  }

  /// 关闭Toast
  void dismiss() {
    _timer?.cancel();
    _timer = null;

    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _ToastWidget extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  _ToastWidget({
    required this.child,
    this.alignment,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final EdgeInsetsGeometry padding =
        margin ?? EdgeInsets.all(mediaQueryData.size.width / 10);

    return Container(
      alignment: this.alignment ?? Alignment.bottomCenter,
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: this.backgroundColor ?? Colors.black,
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
