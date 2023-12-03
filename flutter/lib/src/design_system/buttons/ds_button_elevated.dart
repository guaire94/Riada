import 'package:riada/src/design_system/ds_border_radius.dart';
import 'package:riada/src/design_system/ds_color.dart';
import 'package:flutter/material.dart';

class DSButtonElevated extends StatelessWidget {
  // MARK: - Constants
  static const double _height = 48;

  // MARK: - Properties
  final String _text;
  final bool _isLoading;
  final bool _isEnable;
  final void Function()? _onPressed;

  // MARK: - LifeCycle
  const DSButtonElevated({
    Key? key,
    required String text,
    bool isLoading = false,
    bool isEnable = true,
    void Function()? onPressed,
  })  : _text = text,
        _onPressed = onPressed,
        _isLoading = isLoading,
        _isEnable = isEnable,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final onPressed =
        _isLoading == true || _isEnable == false ? null : _onPressed;
    Widget? content;
    if (_isEnable) {
      content = _isLoading == true
          ? Center(
              child: SizedBox(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : Center(
              child: Text(
                _text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: DSColor.secondary100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSBorderRadius.input),
        ),
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
