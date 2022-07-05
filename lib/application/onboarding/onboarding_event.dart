
import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable { }

class FirstTimeUsingAppDone extends OnboardingEvent {
  @override
  List<Object> get props => [];
}