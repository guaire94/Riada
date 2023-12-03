import 'package:flutter/material.dart';
import 'package:riada/src/design_system/ds_color.dart';
import 'package:riada/src/design_system/ds_size.dart';
import 'package:riada/src/design_system/ds_spacing.dart';
import 'package:riada/src/utils/build_context_extension.dart';
import 'package:riada/src/utils/timestamp_extension.dart';

class DSDate extends StatelessWidget {
  final DateTime _date;

  const DSDate({
    required DateTime date,
  }) : _date = date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: DSSize.buttonIcon,
          color: Colors.black,
        ),
        SizedBox(width: DSSpacing.sizeXxs),
        Text(
          _date.fullDateDescription,
          style: context.textTheme.headlineMedium?.copyWith(
            color: DSColor.primary100,
          ),
        ),
      ],
    );
  }
}
