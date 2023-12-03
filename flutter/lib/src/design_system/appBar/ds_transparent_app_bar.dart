import 'package:auto_route/auto_route.dart';
import 'package:riada/gen/assets.gen.dart';
import 'package:riada/src/design_system/ds_spacing.dart';
import 'package:riada/src/utils/build_context_extension.dart';
import 'package:flutter/material.dart';

class DSTransparentAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? _title;
  final bool _canGoBack;

  const DSTransparentAppBar({
    Key? key,
    String? title,
    bool canGoBack = true,
  })  : _title = title,
        _canGoBack = canGoBack,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(
        title: _titleWidget(context: context),
        leading: _leadingWidget(context),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  Widget? _leadingWidget(BuildContext context) {
    if (_canGoBack == true) {
      return Container(
        padding: EdgeInsets.only(
          top: DSSpacing.sizeXxxs,
          left: DSSpacing.sizeS,
        ),
        child: InkWell(
          onTap: () {
            context.router.pop();
          },
          child: Assets.images.icons.backButton.svg(),
        ),
      );
    }

    return null;
  }

  Widget? _titleWidget({
    required BuildContext context,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_title != null)
          Text(
            _title!,
            style: context.textTheme.displaySmall?.copyWith(
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
