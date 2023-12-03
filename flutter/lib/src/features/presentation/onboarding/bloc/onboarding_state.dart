part of 'onboarding_bloc.dart';

abstract class OnBoardingState {}

class IdleState extends OnBoardingState {
  List<SportItem> sportItems;

  IdleState({required this.sportItems});
}

class LoadingState extends OnBoardingState {}

class SuccessState extends OnBoardingState {}

class ErrorState extends OnBoardingState {}
