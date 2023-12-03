import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  // MARK: LifeCycle
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
