import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/application/services/services_event.dart';
import 'package:conecta/application/services/services_state.dart';
import 'package:conecta/domain/core/services/service.dart';
import 'package:conecta/domain/services/service_failure.dart';
import 'package:conecta/infrastructure/services/repositories/services_repositories.dart';

@injectable
class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository _servicesRepository;

  ServicesBloc(this._servicesRepository) : super(Initial());

  @override
  Stream<ServicesState> mapEventToState(ServicesEvent event) async* {
    if (event is GetServices) {
      yield GetServicesProcessing();
      yield* _getServices(event);
    }else if (event is GetVideoConsultingService){
      yield GetVideoConsultingServiceProcessing();
      yield* _getVideoConsultingService(event);
    }
  }

  Stream<ServicesState> _getServices(GetServices event) async* {
    var result = await _servicesRepository.getServices();
    yield* result.fold(
      (ServiceFailure isLeft) async* {
        yield ServicesNotWasLoaded(isLeft);
      }, 
      (List<Service> isRight) async* {
        yield ServicesLoaded(isRight);
      }
    );
  }

  Stream<ServicesState> _getVideoConsultingService(GetVideoConsultingService event) async* {
    var result = await _servicesRepository.getVideoConsultingService();
    yield* result.fold(
      (ServiceFailure isLeft) async* {
        yield VideoConsultingServiceNotWasLoaded(isLeft);
      }, 
      (Service isRight) async* {
        yield VideoConsultingServiceLoaded(isRight);
      }
    );
  }

}