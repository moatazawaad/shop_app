import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshWidget extends StatelessWidget {
  const RefreshWidget(
      {Key? key,
      required this.child,
      required this.onRefresh,
      required this.keyRefresh})
      : super(key: key);

  final Widget child;
  final Future Function() onRefresh;
  final GlobalKey<RefreshIndicatorState> keyRefresh;

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? buildAndroidWidget : buildIosWidget;
  }

  get buildAndroidWidget => RefreshIndicator(
        onRefresh: onRefresh,
        key: key,
        child: child,
      );

  get buildIosWidget => CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: onRefresh,
            key: key,
          ),
          SliverToBoxAdapter(
            child: child,
          ),
        ],
      );
}
