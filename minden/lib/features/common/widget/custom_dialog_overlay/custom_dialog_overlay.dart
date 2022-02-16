import 'package:flutter/material.dart';

class CustomDialogOverlay extends ModalRoute<bool> {
  CustomDialogOverlay(
    this.contents, {
    this.isAndroidBackEnable = false,
  }) : super();

  final Widget contents;

  //Androidで実機のバックボタンを押すとダイアログが閉じてしまう
  final bool isAndroidBackEnable;

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
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
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
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return Center(
      child: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomSpace),
          child: dialogContent(context),
        ),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => isAndroidBackEnable);
      },
      child: contents,
    );
  }
}
