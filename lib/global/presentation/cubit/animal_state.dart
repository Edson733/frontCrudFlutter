import 'package:equatable/equatable.dart'; // Importa el paquete Equatable, que facilita la comparación de estados en BLoC/Cubit
import '../../data/models/animal_model.dart'; // Importa el modelo AnimalModel, que se utiliza para representar los datos de los animales

abstract class AnimalState extends Equatable {
  @override
  List<Object?> get props => []; // Sobrescribe la propiedad 'props' de Equatable para definir qué propiedades se usarán para comparar los estados
}

class AnimalInitial extends AnimalState {} // Estado inicial, cuando no ha ocurrido ninguna acción o carga

class AnimalLoading extends AnimalState {} // Estado que indica que se está realizando una operación (cargando datos, insertando, actualizando, eliminando)

class AnimalSuccess extends AnimalState {
  final List<AnimalModel> animals; // Lista de animales que se obtiene tras una operación exitosa

  AnimalSuccess(this.animals); // Constructor que recibe la lista de animales y la asigna a la propiedad 'animals'
}

class AnimalError extends AnimalState {
  final String message; // Mensaje de error que se mostrará en caso de que ocurra un problema

  AnimalError(this.message); // Constructor que recibe un mensaje de error y lo asigna a la propiedad 'message'
}