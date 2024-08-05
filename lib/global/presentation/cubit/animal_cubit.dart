import 'package:bloc/bloc.dart';
import '../../data/models/animal_model.dart';
import '../../data/repository/animal_repository.dart';
import 'animal_state.dart';

class AnimalCubit extends Cubit<AnimalState> {
  final AnimalRepository animalRepository;

  AnimalCubit({required this.animalRepository}) : super(AnimalInitial()) {
    fetchAllAnimals();
  }

  Future<void> insertAnimal(AnimalModel animal) async {
    try {
      emit(AnimalLoading());
      await animalRepository.insertAnimal(animal);
      emit(AnimalSuccess(await animalRepository.getAllAnimals()));
    } catch (e) {
      emit(AnimalError(e.toString()));
    }
  }

  Future<void> updateAnimal(AnimalModel animal) async {
    try {
      emit(AnimalLoading());
      await animalRepository.updateAnimal(animal);
      emit(AnimalSuccess(await animalRepository.getAllAnimals()));
    } catch (e) {
      emit(AnimalError(e.toString()));
    }
  }

  Future<void> deleteAnimal(int id) async {
    try {
      emit(AnimalLoading());
      await animalRepository.deleteAnimal(id);
      emit(AnimalSuccess(await animalRepository.getAllAnimals()));
    } catch (e) {
      emit(AnimalError(e.toString()));
    }
  }

  Future<void> fetchAllAnimals() async {
    try {
      emit(AnimalLoading());
      final animals = await animalRepository.getAllAnimals();
      emit(AnimalSuccess(animals));
    } catch (e) {
      emit(AnimalError(e.toString()));
    }
  }
}