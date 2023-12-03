import 'package:flutter/material.dart';
import 'package:riada/src/utils/build_context_extension.dart';

class OnBoardingErrorWidget extends StatelessWidget {
  // MARK: - LifeCycle
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(context.l10N.onboarding_error),
      ),
    );
  }
}
