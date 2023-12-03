import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riada/src/factory/di.dart';
import 'package:riada/src/features/presentation/base/base_state.dart';
import 'package:riada/src/features/presentation/common/loading_widget.dart';
import 'package:riada/src/features/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:riada/src/features/presentation/onboarding/screen/onboarding_error_widget.dart';
import 'package:riada/src/features/presentation/onboarding/screen/onboarding_idle_widget.dart';

@RoutePage()
class OnBoardingScreen extends StatefulWidget implements AutoRouteWrapper {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnboardingScreenState();

  @override
  Widget wrappedRoute(context) {
    return BlocProvider(
      create: (context) => getIt<OnBoardingBloc>(),
      child: this,
    );
  }
}

class _OnboardingScreenState
    extends BaseState<OnBoardingScreen, OnBoardingBloc> {
  // MARK: - Life cycle
  @override
  void initState() {
    super.initState();
    bloc.add(LoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnBoardingBloc, OnBoardingState>(
      buildWhen: _buildWhen,
      listenWhen: _listenWhen,
      builder: _onStateChangeBuilder,
      listener: _onStateChangeListener(),
    );
  }

  bool _buildWhen(
    OnBoardingState previous,
    OnBoardingState current,
  ) {
    return current is LoadingState ||
        current is IdleState ||
        current is ErrorState;
  }

  bool _listenWhen(OnBoardingState previous, OnBoardingState current) {
    return current is SuccessState;
  }

  Function(BuildContext, OnBoardingState) _onStateChangeListener() {
    return (context, state) {
      if (state is SuccessState) {
        // TODO: Redirect to home
      }
    };
  }

  Widget _onStateChangeBuilder(
    BuildContext context,
    OnBoardingState state,
  ) {
    if (state is LoadingState) {
      return LoadingWidget();
    }
    if (state is IdleState) {
      return OnBoardingIdleWidget(
        state: state,
        onPressedFavorite: (item) {
          bloc.add(UpdateFavoriteEvent(item: item));
        },
      );
    }
    if (state is ErrorState) {
      return OnBoardingErrorWidget();
    }
    return Container();
  }

  // MARK: - Privates
  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
