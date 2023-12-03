part of 'onboarding_bloc.dart';

abstract class OnBoardingEvent {}

class LoadEvent extends OnBoardingEvent {}

class UpdateFavoriteEvent extends OnBoardingEvent {
  final SportItem item;

  UpdateFavoriteEvent({required this.item});
}

class ConfirmEvent extends OnBoardingEvent {}
