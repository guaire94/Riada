import 'package:riada/src/design_system/ds_border_radius.dart';
import 'package:riada/src/design_system/ds_color.dart';
import 'package:flutter/material.dart';

class DSButtonOutline extends StatelessWidget {
  // MARK: - Constants
  static const double _height = 48;

  // MARK: - Properties
  final String _text;
  final bool _isLoading;
  final void Function()? _onPressed;

  // MARK: - LifeCycle
  const DSButtonOutline({
    Key? key,
    required String text,
    bool isLoading = false,
    void Function()? onPressed,
  })  : _text = text,
        _onPressed = onPressed,
        _isLoading = isLoading,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final onPressed = _isLoading == true ? null : _onPressed;
    final Widget content = _isLoading == true
        ? Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
            ),
          )
        : Center(
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: DSColor.secondary100,
                  ),
            ),
          );

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSBorderRadius.input),
        ),
        side: BorderSide(color: DSColor.secondary100),
      ),
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: _height,
        child: content,
      ),
    );
  }
}
