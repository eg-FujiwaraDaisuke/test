import 'package:flutter/material.dart';

class CustomDialogOverlay extends ModalRoute<void> {
  final Widget contents;

  //Androidで実機のバックボタンを押すとダイアログが閉じてしまう
  final bool isAndroidBackEnable;

  CustomDialogOverlay(this.contents, {this.isAndroidBackEnable = false})
      : super();
  @override
  Duration get transitionDuration => Duration(milliseconds: 0);
  @override
  bool get opaque => false;
  @override
  bool get barrierDismissible => false;
  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(color: Colors.transparent),
            onTap: () => Navigator.of(context).pop(),
          ),
          SafeArea(
            child: _buildOverlayContent(context),
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: dialogContent(context),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return WillPopScope(
      child: this.contents,
      onWillPop: () {
        return Future(() => isAndroidBackEnable);
      },
    );
  }
}
