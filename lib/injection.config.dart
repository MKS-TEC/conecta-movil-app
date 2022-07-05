// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:cloud_firestore/cloud_firestore.dart' as _i9;
import 'package:firebase_auth/firebase_auth.dart' as _i8;
import 'package:firebase_messaging/firebase_messaging.dart' as _i10;
import 'package:firebase_storage/firebase_storage.dart' as _i11;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i12;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i31;

import 'application/auth/auth_bloc.dart' as _i66;
import 'application/auth/sign_in/sign_in_bloc.dart' as _i61;
import 'application/auth/sign_up/sign_up_bloc.dart' as _i62;
import 'application/dashboard/daily_activities/dashboard_daily_activities_bloc.dart'
    as _i69;
import 'application/dashboard/dashboard_bloc.dart' as _i68;
import 'application/dashboard/medical_history/dashboard_medical_history_bloc.dart'
    as _i70;
import 'application/dashboard/program_categories_list/program_category_list_cubit.dart'
    as _i55;
import 'application/dashboard/program_list/program_list_bloc.dart' as _i56;
import 'application/deworming/deworming_bloc.dart' as _i71;
import 'application/diagnosis/diagnosis_bloc.dart' as _i72;
import 'application/episodies/pathology_episodies_bloc.dart' as _i51;
import 'application/events/event_view/event_view_bloc.dart' as _i44;
import 'application/events/events_bloc.dart' as _i73;
import 'application/gamification/challenges/gamification_challenges_bloc.dart'
    as _i45;
import 'application/gamification/pet_points/gamification_pet_points_bloc.dart'
    as _i46;
import 'application/initial_configuration/initial_configuration_bloc.dart'
    as _i74;
import 'application/notifications/notifications_bloc.dart' as _i20;
import 'application/onboarding/onboarding_bloc.dart' as _i47;
import 'application/orders/orders_bloc.dart' as _i49;
import 'application/owner/edit_profile/owner_edit_profile_bloc.dart' as _i50;
import 'application/owner/pets/owner_pets_bloc.dart' as _i75;
import 'application/owner/profile/owner_profile_bloc.dart' as _i76;
import 'application/pathologies/pathologies_bloc.dart' as _i77;
import 'application/pet/create_pet/create_pet_bloc.dart' as _i67;
import 'application/pet/pet_profile/pet_profile_bloc.dart' as _i54;
import 'application/pet_calendar/pet_calendar_bloc.dart' as _i78;
import 'application/program/program_view_bloc.dart' as _i57;
import 'application/program/programs_list_cubit.dart' as _i58;
import 'application/services/services_bloc.dart' as _i59;
import 'application/share_code/share_code_bloc.dart' as _i60;
import 'application/temperatures/temperatures_bloc.dart' as _i63;
import 'application/vaccines/vaccines_bloc.dart' as _i64;
import 'application/weights/weights_bloc.dart' as _i65;
import 'domain/core/entities/app_event.dart' as _i3;
import 'domain/core/entities/breed.dart' as _i4;
import 'domain/core/entities/calendar.dart' as _i5;
import 'domain/core/entities/challenge.dart' as _i6;
import 'domain/core/entities/event.dart' as _i7;
import 'domain/core/entities/pet_points.dart' as _i25;
import 'domain/core/entities/program.dart' as _i26;
import 'domain/core/entities/species.dart' as _i32;
import 'domain/core/notifications/notification.dart' as _i18;
import 'domain/core/pet_calendar/pet_calendar.dart' as _i24;
import 'infrastructure/app_events/repositories/app_event_repositories.dart'
    as _i13;
import 'infrastructure/auth/auth_facade.dart' as _i38;
import 'infrastructure/calendar/repositories/calendar_repository.dart' as _i40;
import 'infrastructure/challenges/repositories/challenges_repositories.dart'
    as _i14;
import 'infrastructure/deworming/repositories/deworming_repository.dart'
    as _i41;
import 'infrastructure/diagnosis/repositories/diagnosis_repository.dart'
    as _i42;
import 'infrastructure/episodies/repositories/episodies_repository.dart'
    as _i43;
import 'infrastructure/events/repositories/event_repository.dart' as _i15;
import 'infrastructure/initial_configuration/initial_configuration_facade.dart'
    as _i17;
import 'infrastructure/notifications/repositories/notifications_repository.dart'
    as _i19;
import 'infrastructure/orders/repositories/orders_repository.dart' as _i48;
import 'infrastructure/owner/repositories/owner_repository.dart' as _i21;
import 'infrastructure/pathologies/repositories/episodes_repository.dart'
    as _i22;
import 'infrastructure/pathologies/repositories/pathologies_repository.dart'
    as _i23;
import 'infrastructure/pet/breed_repository.dart' as _i39;
import 'infrastructure/pet/pet_repository.dart' as _i52;
import 'infrastructure/pet/species_repository.dart' as _i33;
import 'infrastructure/pet_calendar/repositories/pet_calendar_repository.dart'
    as _i53;
import 'infrastructure/pet_points/repositories/pet_points_repository.dart'
    as _i16;
import 'infrastructure/program/repositories/program_category_repository.dart'
    as _i27;
import 'infrastructure/program/repositories/program_repository.dart' as _i28;
import 'infrastructure/services/repositories/services_repositories.dart'
    as _i29;
import 'infrastructure/share_code/repositories/share_code_repositories.dart'
    as _i30;
import 'infrastructure/subject/repositories/subject_repository.dart' as _i34;
import 'infrastructure/temperature/repositories/temperature_repositories.dart'
    as _i35;
import 'infrastructure/vaccines/repositories/vaccines_repositories.dart'
    as _i36;
import 'infrastructure/weight/repositories/weight_repository.dart' as _i37;
import 'register_module.dart' as _i79; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.factory<_i3.AppEvent>(() => _i3.AppEvent());
  gh.factory<_i4.Breed>(() => _i4.Breed(get<String>()));
  gh.factory<_i5.CalendarEvent>(() => _i5.CalendarEvent());
  gh.factory<_i6.Challenge>(() => _i6.Challenge());
  gh.factory<_i6.ChallengeActivity>(() => _i6.ChallengeActivity());
  gh.factory<_i7.Event>(() => _i7.Event());
  gh.factory<_i7.EventFeatured>(() => _i7.EventFeatured());
  gh.factory<_i8.FirebaseAuth>(() => registerModule.firebaseAuth);
  gh.factory<_i9.FirebaseFirestore>(() => registerModule.firestore);
  gh.factory<_i10.FirebaseMessaging>(() => registerModule.firebaseMessaging);
  gh.factory<_i11.FirebaseStorage>(() => registerModule.firebaseStorage);
  gh.factory<_i12.GoogleSignIn>(() => registerModule.googleSignIn);
  gh.lazySingleton<_i13.IAppEventRepository>(
      () => _i13.IAppEventRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i14.IChallengeRepository>(
      () => _i14.IChallengeRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i15.IEventRepository>(
      () => _i15.IEventRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i16.IPetPointRepository>(
      () => _i16.IPetPointRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i17.InitialConfigurationFacade>(
      () => _i17.InitialConfigurationFacade(get<_i9.FirebaseFirestore>()));
  gh.factory<_i18.NotificationModel>(() => _i18.NotificationModel());
  gh.lazySingleton<_i19.NotificationRepository>(
      () => _i19.NotificationRepository(get<_i9.FirebaseFirestore>()));
  gh.factory<_i20.NotificationsBloc>(
      () => _i20.NotificationsBloc(get<_i19.NotificationRepository>()));
  gh.lazySingleton<_i21.OwnerRepository>(() => _i21.OwnerRepository(
      get<_i9.FirebaseFirestore>(),
      get<_i11.FirebaseStorage>(),
      get<_i8.FirebaseAuth>()));
  gh.lazySingleton<_i22.PathologiesRepository>(
      () => _i22.PathologiesRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i23.PathologiesRepository>(
      () => _i23.PathologiesRepository(get<_i9.FirebaseFirestore>()));
  gh.factory<_i24.PetCalendarItem>(() => _i24.PetCalendarItem());
  gh.factory<_i25.PetPoint>(() => _i25.PetPoint());
  gh.factory<_i26.ProgramActivity>(() => _i26.ProgramActivity());
  gh.lazySingleton<_i27.ProgramCategoryRepository>(
      () => _i27.ProgramCategoryRepository(get<_i9.FirebaseFirestore>()));
  gh.factory<_i26.ProgramFeatures>(() => _i26.ProgramFeatures());
  gh.lazySingleton<_i28.ProgramRepository>(
      () => _i28.ProgramRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i29.ServicesRepository>(
      () => _i29.ServicesRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i30.ShareCodeRepository>(
      () => _i30.ShareCodeRepository(get<_i9.FirebaseFirestore>()));
  await gh.factoryAsync<_i31.SharedPreferences>(() => registerModule.prefs,
      preResolve: true);
  gh.factory<_i32.Species>(() => _i32.Species(get<String>()));
  gh.lazySingleton<_i33.SpeciesRepository>(
      () => _i33.SpeciesRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i34.SubjectRepository>(() => _i34.SubjectRepository());
  gh.lazySingleton<_i35.TemperatureRepository>(
      () => _i35.TemperatureRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i36.VaccinesRepository>(
      () => _i36.VaccinesRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i37.WeightsRepository>(
      () => _i37.WeightsRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i38.AuthFacade>(() => _i38.AuthFacade(
      get<_i8.FirebaseAuth>(),
      get<_i31.SharedPreferences>(),
      get<_i9.FirebaseFirestore>(),
      get<_i12.GoogleSignIn>()));
  gh.lazySingleton<_i39.BreedRepository>(
      () => _i39.BreedRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i40.CalendarRepository>(
      () => _i40.CalendarRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i41.DewormingRepository>(
      () => _i41.DewormingRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i42.DiagnosisRepository>(
      () => _i42.DiagnosisRepository(get<_i9.FirebaseFirestore>()));
  gh.lazySingleton<_i43.EpisodiesRepository>(
      () => _i43.EpisodiesRepository(get<_i9.FirebaseFirestore>()));
  gh.factory<_i44.EventViewBloc>(
      () => _i44.EventViewBloc(get<_i15.IEventRepository>()));
  gh.factory<_i45.GamificationChallengesBloc>(() =>
      _i45.GamificationChallengesBloc(get<_i14.IChallengeRepository>(),
          get<_i16.IPetPointRepository>(), get<_i13.IAppEventRepository>()));
  gh.factory<_i46.GamificationPetPointsBloc>(
      () => _i46.GamificationPetPointsBloc(get<_i16.IPetPointRepository>()));
  gh.factory<_i47.OnboardingBloc>(
      () => _i47.OnboardingBloc(get<_i38.AuthFacade>()));
  gh.lazySingleton<_i48.OrderRepository>(() => _i48.OrderRepository(
      get<_i9.FirebaseFirestore>(), get<_i31.SharedPreferences>()));
  gh.factory<_i49.OrdersBloc>(
      () => _i49.OrdersBloc(get<_i48.OrderRepository>()));
  gh.factory<_i50.OwnerEditProfileBloc>(() => _i50.OwnerEditProfileBloc(
      get<_i21.OwnerRepository>(),
      get<_i14.IChallengeRepository>(),
      get<_i13.IAppEventRepository>(),
      get<_i16.IPetPointRepository>()));
  gh.factory<_i51.PathologyEpisodiesBloc>(
      () => _i51.PathologyEpisodiesBloc(get<_i43.EpisodiesRepository>()));
  gh.lazySingleton<_i52.PeetRepository>(() => _i52.PeetRepository(
      get<_i9.FirebaseFirestore>(),
      get<_i31.SharedPreferences>(),
      get<_i11.FirebaseStorage>()));
  gh.lazySingleton<_i53.PetCalendarRepository>(() => _i53.PetCalendarRepository(
      get<_i9.FirebaseFirestore>(), get<_i31.SharedPreferences>()));
  gh.factory<_i54.PetProfileBloc>(() => _i54.PetProfileBloc(
      get<_i52.PeetRepository>(),
      get<_i39.BreedRepository>(),
      get<_i13.IAppEventRepository>(),
      get<_i14.IChallengeRepository>(),
      get<_i16.IPetPointRepository>()));
  gh.factory<_i55.ProgramCategoryListCubit>(() => _i55.ProgramCategoryListCubit(
      get<_i27.ProgramCategoryRepository>(), get<_i52.PeetRepository>()));
  gh.factory<_i56.ProgramListBloc>(() => _i56.ProgramListBloc(
      get<_i28.ProgramRepository>(),
      get<_i52.PeetRepository>(),
      get<_i40.CalendarRepository>()));
  gh.factory<_i57.ProgramViewBloc>(() => _i57.ProgramViewBloc(
      get<_i28.ProgramRepository>(),
      get<_i52.PeetRepository>(),
      get<_i40.CalendarRepository>()));
  gh.factory<_i58.ProgramsListCubit>(() => _i58.ProgramsListCubit(
      get<_i27.ProgramCategoryRepository>(),
      get<_i28.ProgramRepository>(),
      get<_i52.PeetRepository>()));
  gh.factory<_i59.ServicesBloc>(
      () => _i59.ServicesBloc(get<_i29.ServicesRepository>()));
  gh.factory<_i60.ShareCodeBloc>(() => _i60.ShareCodeBloc(
      get<_i30.ShareCodeRepository>(),
      get<_i14.IChallengeRepository>(),
      get<_i16.IPetPointRepository>(),
      get<_i13.IAppEventRepository>()));
  gh.factory<_i61.SignInBloc>(() =>
      _i61.SignInBloc(get<_i38.AuthFacade>(), get<_i21.OwnerRepository>()));
  gh.factory<_i62.SignUpBloc>(() => _i62.SignUpBloc(get<_i38.AuthFacade>()));
  gh.factory<_i63.TemperaturesBloc>(() => _i63.TemperaturesBloc(
      get<_i35.TemperatureRepository>(), get<_i52.PeetRepository>()));
  gh.factory<_i64.VaccinesBloc>(() => _i64.VaccinesBloc(
      get<_i36.VaccinesRepository>(),
      get<_i52.PeetRepository>(),
      get<_i28.ProgramRepository>(),
      get<_i40.CalendarRepository>()));
  gh.factory<_i65.WeightsBloc>(() => _i65.WeightsBloc(
      get<_i37.WeightsRepository>(),
      get<_i14.IChallengeRepository>(),
      get<_i13.IAppEventRepository>(),
      get<_i16.IPetPointRepository>(),
      get<_i52.PeetRepository>()));
  gh.factory<_i66.AuthBloc>(() => _i66.AuthBloc(get<_i38.AuthFacade>()));
  gh.factory<_i67.CreatePetBloc>(() => _i67.CreatePetBloc(
      get<_i33.SpeciesRepository>(),
      get<_i39.BreedRepository>(),
      get<_i28.ProgramRepository>(),
      get<_i27.ProgramCategoryRepository>(),
      get<_i40.CalendarRepository>(),
      get<_i52.PeetRepository>()));
  gh.factory<_i68.DashboardBloc>(
      () => _i68.DashboardBloc(get<_i52.PeetRepository>()));
  gh.factory<_i69.DashboardDailyActivitiesBloc>(() =>
      _i69.DashboardDailyActivitiesBloc(
          get<_i28.ProgramRepository>(),
          get<_i52.PeetRepository>(),
          get<_i40.CalendarRepository>(),
          get<_i15.IEventRepository>()));
  gh.factory<_i70.DashboardMedicalHistoryBloc>(() =>
      _i70.DashboardMedicalHistoryBloc(
          get<_i52.PeetRepository>(), get<_i37.WeightsRepository>()));
  gh.factory<_i71.DewormingBloc>(() => _i71.DewormingBloc(
      get<_i41.DewormingRepository>(), get<_i52.PeetRepository>()));
  gh.factory<_i72.DiagnosisBloc>(() => _i72.DiagnosisBloc(
      get<_i42.DiagnosisRepository>(), get<_i52.PeetRepository>()));
  gh.factory<_i73.EventsBloc>(() => _i73.EventsBloc(
      get<_i52.PeetRepository>(), get<_i15.IEventRepository>()));
  gh.factory<_i74.InitialConfigurationBloc>(() => _i74.InitialConfigurationBloc(
      get<_i33.SpeciesRepository>(),
      get<_i39.BreedRepository>(),
      get<_i40.CalendarRepository>(),
      get<_i28.ProgramRepository>(),
      get<_i27.ProgramCategoryRepository>(),
      get<_i52.PeetRepository>()));
  gh.factory<_i75.OwnerPetsBloc>(
      () => _i75.OwnerPetsBloc(get<_i52.PeetRepository>()));
  gh.factory<_i76.OwnerProfileBloc>(() => _i76.OwnerProfileBloc(
      get<_i21.OwnerRepository>(), get<_i52.PeetRepository>()));
  gh.factory<_i77.PathologiesBloc>(() => _i77.PathologiesBloc(
      get<_i22.PathologiesRepository>(), get<_i52.PeetRepository>()));
  gh.factory<_i78.PetCalendarBloc>(
      () => _i78.PetCalendarBloc(get<_i53.PetCalendarRepository>()));
  return get;
}

class _$RegisterModule extends _i79.RegisterModule {}
