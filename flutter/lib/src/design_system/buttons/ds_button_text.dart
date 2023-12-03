import 'package:riada/src/design_system/ds_color.dart';
import 'package:riada/src/utils/build_context_extension.dart';
import 'package:flutter/material.dart';

enum DSButtonTextType { primary, secondary, danger }

enum DSButtonTextSize { small, medium, large }

class DSButtonText extends StatelessWidget {
  // MARK: - Properties
  final String _text;
  final bool _isLoading;
  final DSButtonTextType _type;
  final void Function()? _onPressed;
  final DSButtonTextSize _size;

  // MARK: - LifeCycle
  const DSButtonText({
    Key? key,
    required String text,
    bool isLoading = false,
    DSButtonTextType type = DSButtonTextType.primary,
    DSButtonTextSize size = DSButtonTextSize.large,
    void Function()? onPressed,
  })  : _text = text,
        _onPressed = onPressed,
        _isLoading = isLoading,
        _type = type,
        _size = size,
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
              style: _textStyle(context),
            ),
          );

    return TextButton(
      style: TextButton.styleFrom(
        textStyle: context.textTheme.bodyMedium,
      ),
      onPressed: onPressed,
      child: content,
    );
  }

  // MARK: - Private
  Color get _styleColor {
    switch (_type) {
      case DSButtonTextType.primary:
        return DSColor.primary100;
      case DSButtonTextType.secondary:
        return DSColor.secondary100;
      case DSButtonTextType.danger:
        return DSColor.danger100;
    }
  }

  TextStyle? _textStyle(BuildContext context) {
    final TextStyle? textStyle;
    switch (_size) {
      case DSButtonTextSize.small:
        textStyle = context.textTheme.bodySmall;
        break;
      case DSButtonTextSize.medium:
        textStyle = context.textTheme.headlineMedium;
        break;
      case DSButtonTextSize.large:
        textStyle = context.textTheme.headlineLarge;
        break;
    }
    return textStyle?.copyWith(
      color: _styleColor,
    );
  }
}
