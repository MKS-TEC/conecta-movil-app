import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/program_category.dart';
import 'package:conecta/domain/program/program_category_failure.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/program/repositories/program_category_repository.dart';

part 'program_category_list_cubit.freezed.dart';

@injectable
class ProgramCategoryListCubit extends Cubit<ProgramCategoryListState> {
  final ProgramCategoryRepository _programCategoryRepository;
  final PeetRepository _petRepository;

  ProgramCategoryListCubit(this._programCategoryRepository, this._petRepository) : super(ProgramCategoryListState.initial());

  Future<void> initCubit() async{
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  Future<void> loadMainProgramCategories() async{
    var programCategoriesResult = await _programCategoryRepository.getMainProgramCategories();
    programCategoriesResult.fold(
      (l) {
        emit(ProgramCategoryListState.errorLoadingMainProgramCategories(l));
      } , 
      (r) {
        emit(ProgramCategoryListState.mainProgramCategoriesLoaded(r));
      }   
    );
  }

  Future<void> getSelectedPet() async{
    String? petId = _petRepository.getPetDefault();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    petId != null ? emit(ProgramCategoryListState.selectedPetLoaded(petId)) : 
      emit(ProgramCategoryListState.errorLoadingSelectedPet());
  }
}

@freezed
abstract class ProgramCategoryListState with _$ProgramCategoryListState {
  const factory ProgramCategoryListState.initial() = _Initial;
  const factory ProgramCategoryListState.loadingMainProgramCategories() = _LoadingMainProgramCategories;
  const factory ProgramCategoryListState.errorLoadingMainProgramCategories(ProgramCategoryFailure failure) =
      _ErrorLoadingMainProgramCategories;
  const factory ProgramCategoryListState.mainProgramCategoriesLoaded(List<ProgramCategory> programsCategories) =
      _MainProgramCategoriesLoaded;
  const factory ProgramCategoryListState.selectedPetLoaded(String petId) =
      _SelectedPetLoaded;
  const factory ProgramCategoryListState.errorLoadingSelectedPet() =
      _ErrorLoadingSelectedPet;
}