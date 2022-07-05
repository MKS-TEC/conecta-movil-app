import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_category_failure.freezed.dart';

@freezed
class ProgramCategoryFailure with _$ProgramCategoryFailure {
  const factory ProgramCategoryFailure.serverError() = _ServerError;
  const factory ProgramCategoryFailure.unauthenticated() = _Unauthenticated;
}