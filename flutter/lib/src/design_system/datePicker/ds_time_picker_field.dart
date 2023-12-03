import 'package:riada/src/design_system/datePicker/ds_time_picker_controller.dart';
import 'package:riada/src/design_system/ds_border_radius.dart';
import 'package:riada/src/design_system/ds_color.dart';
import 'package:riada/src/design_system/ds_spacing.dart';
import 'package:riada/src/utils/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class DSTimePickerTextField extends StatefulWidget {
  // MARK: Dependencies
  final bool _obscureText;
  final String? _hintText;
  final String? _errorText;
  final String? _label;
  final DSTimePickerController? _controller;
  final StringValidationCallback? _validate;
  final FocusNode? _focusNode;
  final ValueChanged<String>? _onChanged;
  final bool _enabled;

  // MARK: LifeCycle
  const DSTimePickerTextField({
    Key? key,
    bool obscureText = false,
    String? label,
    String? hintText,
    String? errorText,
    DSTimePickerController? controller,
    FocusNode? focusNode,
    StringValidationCallback? validate,
    ValueChanged<String>? onChanged,
    bool enabled = true,
  })  : _hintText = hintText,
        _errorText = errorText,
        _label = label,
        _obscureText = obscureText,
        _controller = controller,
        _validate = validate,
        _focusNode = focusNode,
        _onChanged = onChanged,
        _enabled = enabled,
        super(key: key);

  @override
  State<DSTimePickerTextField> createState() => _DSTimePickerTextFieldState();
}

class _DSTimePickerTextFieldState extends State<DSTimePickerTextField> {
  // MARK: Constants
  final double _width = 105;

  // MARK: Properties
  final TextEditingController _controller = TextEditingController();

  // MARK: LifeCycle
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: TextFormField(
        enabled: widget._enabled,
        style: context.textTheme.bodyLarge?.copyWith(
          color: DSColor.neutral70,
        ),
        onChanged: widget._onChanged,
        validator: (value) =>
            widget._validate != null ? widget._validate!(value) : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _controller,
        obscureText: widget._obscureText,
        focusNode: widget._focusNode,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DSBorderRadius.input),
            borderSide: const BorderSide(color: DSColor.neutral35),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DSBorderRadius.input),
            borderSide: const BorderSide(color: DSColor.neutral35),
          ),
          hintText: widget._hintText,
          errorText: widget._errorText,
          labelText: widget._label,
          contentPadding: EdgeInsets.symmetric(
            horizontal: DSSpacing.sizeL,
            vertical: DSSpacing.sizeXs,
          ),
        ),
        onTap: () async {
          FocusScope.of(context).requestFocus(new FocusNode());

          final TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: widget._controller?.time ?? TimeOfDay.now(),
            initialEntryMode: TimePickerEntryMode.inputOnly,
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: DSColor.secondary100,
                    onSurface: DSColor.secondary100,
                  ),
                ),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: true,
                  ),
                  child: child!,
                ),
              );
            },
          );

          if (time != null && widget._controller != null) {
            setState(() {
              widget._controller!.time = time;
              _controller.text = widget._controller!.content;
            });
          }
        },
      ),
    );
  }
}
