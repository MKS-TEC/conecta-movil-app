import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:conecta/domain/core/entities/program.dart';
import 'package:conecta/domain/core/entities/program_category.dart';
import 'package:conecta/domain/program/program_category_failure.dart';
import 'package:conecta/domain/program/program_failure.dart';
import 'package:conecta/infrastructure/pet/pet_repository.dart';
import 'package:conecta/infrastructure/program/repositories/program_category_repository.dart';
import 'package:conecta/infrastructure/program/repositories/program_repository.dart';

part 'programs_list_cubit.freezed.dart';

@injectable
class ProgramsListCubit extends Cubit<ProgramsListState> {
  final ProgramCategoryRepository _programCategoryRepository;
  final ProgramRepository _programRepository;
  final PeetRepository _petRepository;

  ProgramsListCubit(this._programCategoryRepository, this._programRepository, this._petRepository) : super(ProgramsListState.initial());

  Future<void> loadProgramCategories(String mainProgramCategory) async{
    var programCategoriesResult = await _programCategoryRepository.getProgramCategoriesByMainCategory(mainProgramCategory);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    programCategoriesResult.fold(
      (l) {
        emit(ProgramsListState.errorLoadingProgramCategories(l));
      } , 
      (r) {
        emit(ProgramsListState.programCategoriesLoaded(r));
      }   
    );
  }

  Future<void> loadProgramsByCategory(String programCategoryId) async{
    var programsResult = await _programRepository.getProgramsByCategory(programCategoryId);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    programsResult.fold(
      (l) {
        emit(ProgramsListState.errorLoadingProgramsByCategory(l));
      } , 
      (r) {
        emit(ProgramsListState.programsByCategoryLoaded(r));
      }   
    );
  }

  Future<void> loadProgramsPet() async{
    String? petId = _petRepository.getPetDefault();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    var programsResult = await _programRepository.getProgramsPet(petId ?? "");
    await Future<void>.delayed(const Duration(milliseconds: 50));
    programsResult.fold(
      (l) {
        emit(ProgramsListState.errorLoadingProgramsPet(l));
      } , 
      (r) {
        emit(ProgramsListState.programsPetLoaded(r));
      }   
    );
  }
}

@freezed
abstract class ProgramsListState with _$ProgramsListState {
  const factory ProgramsListState.initial() = _Initial;
  const factory ProgramsListState.loadingProgramCategories() = _LoadingProgramCategories;
  const factory ProgramsListState.errorLoadingProgramCategories(ProgramCategoryFailure failure) =
      _ErrorLoadingProgramCategories;
  const factory ProgramsListState.programCategoriesLoaded(List<ProgramCategory> programsCategories) =
      _ProgramCategoriesLoaded;
  const factory ProgramsListState.loadingProgramsByCategory() = _LoadingProgramsByCategory;
  const factory ProgramsListState.errorLoadingProgramsByCategory(ProgramFailure failure) =
      _ErrorLoadingProgramsByCategory;
  const factory ProgramsListState.programsByCategoryLoaded(List<Program> programs) =
      _ProgramsByCategoryLoaded;
  const factory ProgramsListState.loadingProgramsPet() = _LoadingProgramsPet;
  const factory ProgramsListState.errorLoadingProgramsPet(ProgramFailure failure) =
      _ErrorLoadingProgramsPet;
  const factory ProgramsListState.programsPetLoaded(List<Program> programs) =
      _ProgramPetLoaded;
}