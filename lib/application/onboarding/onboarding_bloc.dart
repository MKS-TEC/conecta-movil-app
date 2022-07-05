import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/onboarding/onboarding_event.dart';
import 'package:conecta/application/onboarding/onboarding_state.dart';
import 'package:conecta/infrastructure/auth/auth_facade.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {

  AuthFacade _authFacade;

  OnboardingBloc(this._authFacade) : super(Initial());

  @override
  Stream<OnboardingState> mapEventToState(
    OnboardingEvent blocEvent,
  ) async* {
    if(blocEvent is FirstTimeUsingAppDone) {
      if (await _authFacade.firstTimeUsingAppDone()) 
        yield SuccessfulOnboarding();
      else 
        yield FailedOnboarding();
    }
  }
}