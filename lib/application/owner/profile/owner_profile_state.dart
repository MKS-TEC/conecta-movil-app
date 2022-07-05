import 'package:equatable/equatable.dart';
import 'package:conecta/domain/core/entities/country.dart';
import 'package:conecta/domain/core/entities/owner.dart';
import 'package:conecta/domain/core/entities/pet.dart';

abstract class OwnerProfileState extends Equatable { }

class Initial extends OwnerProfileState {
  @override
  List<Object> get props => [];
}

class OwnerLoaded extends OwnerProfileState {
  final Owner owner;

  OwnerLoaded(this.owner);

  @override
  List<Object> get props => [owner];
}

class CountriesNotLoaded extends OwnerProfileState {
  @override
  List<Object> get props => [];
}

class CountriesLoaded extends OwnerProfileState {
  final List<Country> countries;

  CountriesLoaded(this.countries);

  @override
  List<Object> get props => [countries];
}

class OwnerNotLoaded extends OwnerProfileState {
  @override
  List<Object> get props => [];
}

class OwnerPetsLoaded extends OwnerProfileState {
  final List<Pet> pets;

  OwnerPetsLoaded(this.pets);

  @override
  List<Object> get props => [pets];
}
 

class OwnerPetsNotLoaded extends OwnerProfileState {
  @override
  List<Object> get props => [];
}
 