import 'package:flutter/material.dart';
import 'package:riada/src/design_system/appBar/ds_app_bar.dart';
import 'package:riada/src/features/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:riada/src/features/presentation/onboarding/item/sport_item.dart';
import 'package:riada/src/utils/build_context_extension.dart';

class OnBoardingIdleWidget extends StatelessWidget {
  // MARK: - Dependencies
  final IdleState _state;
  final void Function(SportItem) _onPressedFavorite;

  // MARK: - LifeCycle
  const OnBoardingIdleWidget({
    super.key,
    required IdleState state,
    required void Function(SportItem) onPressedFavorite,
  })  : _state = state,
        _onPressedFavorite = onPressedFavorite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DSAppBar(title: context.l10N.onboarding_title),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _state.sportItems.length,
          itemBuilder: (context, index) {
            final item = _state.sportItems[index];
            return ListTile(
              title: Text(item.sport.name),
              onTap: () {
                _onPressedFavorite(item);
              },
            );
          },
        ),
      ),
    );
  }
}
