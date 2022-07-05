import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable { }

class Initial extends OnboardingState {
  @override
  List<Object> get props => [];
}

class SuccessfulOnboarding extends OnboardingState {
  @override
  List<Object> get props => [];
}

class FailedOnboarding extends OnboardingState {
  @override
  List<Object> get props => [];
}