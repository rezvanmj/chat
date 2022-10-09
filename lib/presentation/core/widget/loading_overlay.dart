import 'package:flutter/material.dart';

import 'loading_widget.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool? isLoading;

  const LoadingOverlay({
    Key? key,
    required this.child,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        if (isLoading ?? false)
          Positioned.fill(
              child: Container(
            color: Colors.black26,
            alignment: Alignment.center,
            child: const LoadingWidget(),
          )),
      ],
    );
  }
}
