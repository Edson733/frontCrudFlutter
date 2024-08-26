import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importa el paquete flutter_bloc para manejar el estado con Bloc/Cubit
import '../../data/repository/animal_repository.dart'; // Importa el repositorio que maneja las operaciones CRUD
import '../../data/models/animal_model.dart'; // Importa el modelo AnimalModel
import '../cubit/animal_state.dart'; // Importa los estados del Cubit
import '../cubit/animal_cubit.dart'; // Importa el Cubit que maneja la lógica de negocio para los animales

class AnimalListView extends StatelessWidget {
  const AnimalListView({super.key}); // Constructor de la clase, con una clave opcional

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animales', // Título del AppBar
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          )
        ),
        centerTitle: true, // Centra el título
        backgroundColor: const Color.fromRGBO(52, 152, 219, 1), // Color de fondo del AppBar
        elevation: 4.0, // Sombra del AppBar
      ),
      body: BlocProvider(
        create: (context) => AnimalCubit(
          animalRepository: RepositoryProvider.of<AnimalRepository>(context) // Provee el repositorio al Cubit
        ),
        child: Container(
          color: Colors.white, // Color de fondo de la pantalla
          child: const AnimalListScreen(), // Carga la pantalla que muestra la lista de animales
        )
      )
    );
  }
}

class AnimalListScreen extends StatelessWidget {
  const AnimalListScreen({super.key}); // Constructor de la clase, con una clave opcional

  @override
  Widget build(BuildContext context) {
    final animalCubit = BlocProvider.of<AnimalCubit>(context); // Obtiene el Cubit desde el contexto
    return Padding(
      padding: const EdgeInsets.all(8.0), // Padding de 8 píxeles alrededor del contenido
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacia uniformemente los botones en la fila
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  animalCubit.fetchAllAnimals(); // Llama al método para obtener todos los animales
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(31, 97, 141, 1), // Color del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Borde redondeado del botón
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12) // Padding interno del botón
                ),
                icon: const Icon(Icons.refresh, color: Colors.white), // Icono de refrescar con color blanco
                label: const Text('Recargar', style: TextStyle(color: Colors.white)), // Texto del botón recargar
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<AnimalCubit>(context), // Mantiene el mismo Cubit para la nueva pantalla
                        child: const AnimalFormScreen(), // Navega a la pantalla de formulario para agregar o editar un animal
                      ),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(31, 97, 141, 1), // Color del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Borde redondeado del botón
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12) // Padding interno del botón
                ),
                icon: const Icon(Icons.add, color: Colors.white), // Icono de agregar con color blanco
                label: const Text('Agregar', style: TextStyle(color: Colors.white)), // Texto del botón agregar
              )
            ]
          ),
          const SizedBox(height: 10), // Espacio de 10 píxeles de altura
          const Text('¡No olvides recargar para ver los cambios!', style: TextStyle(fontSize: 11)), // Mensaje de recordatorio
          Expanded(
            child: BlocBuilder<AnimalCubit, AnimalState>(
              builder: (context, state) { // Construye la UI basada en el estado actual
                if (state is AnimalLoading) {
                  return const Center(child: CircularProgressIndicator()); // Muestra un indicador de carga
                } else if (state is AnimalSuccess) {
                  final animals = state.animals; // Obtiene la lista de animales si la carga fue exitosa
                  return ListView.builder(
                    itemCount: animals.length, // Número de animales en la lista
                    itemBuilder: (context, index) {
                      final animal = animals[index]; // Animal en el índice actual
                      return Card(
                        elevation: 4, // Sombra de la tarjeta
                        margin: const EdgeInsets.symmetric(vertical: 8), // Margen vertical entre las tarjetas
                        color: const Color.fromRGBO(133, 193, 233, 1), // Color de la tarjeta
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Borde redondeado de la tarjeta
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0), // Padding interno de la tarjeta
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido al inicio del eje horizontal
                            children: [
                              Text(
                                animal.nombre, // Muestra el nombre del animal
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Estilo del texto del nombre
                              ),
                              const SizedBox(height: 8), // Espacio de 8 píxeles de altura
                              Text('ID: ${animal.id}'), // Muestra el ID del animal
                              Text('Raza: ${animal.raza}'), // Muestra la raza del animal
                              Text('Edad: ${animal.edad} años'), // Muestra la edad del animal
                              Text('Color: ${animal.color}'), // Muestra el color del animal
                              const SizedBox(height: 12), // Espacio de 12 píxeles de altura
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end, // Alinea los botones al final del eje horizontal
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit), // Icono de editar
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider.value(
                                            value: BlocProvider.of<AnimalCubit>(context), // Mantiene el mismo Cubit para la nueva pantalla
                                            child: AnimalFormScreen(animal: animal) // Navega al formulario con los datos del animal para editar
                                          )
                                        )
                                      );
                                    }
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete), // Icono de eliminar
                                    onPressed: () {
                                      context.read<AnimalCubit>().deleteAnimal(animal.id); // Elimina el animal por su ID
                                    }
                                  )
                                ]
                              )
                            ]
                          )
                        )
                      );
                    }
                  );
                } else if (state is AnimalError) {
                  return Center(child: Text('Error: ${state.message}')); // Muestra el mensaje de error si ocurre uno
                }
                return const Center(child: Text('Presiona el botón para cargar los animales')); // Mensaje cuando no hay animales cargados
              }
            )
          )
        ]
      )
    );
  }
}

class AnimalFormScreen extends StatelessWidget {
  final AnimalModel? animal; // Modelo del animal (nulo si es para agregar)

  const AnimalFormScreen({super.key, this.animal}); // Constructor de la clase, con un animal opcional

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>(); // Llave para manejar el estado del formulario
    final nombreController = TextEditingController(text: animal?.nombre); // Controlador para el nombre
    final razaController = TextEditingController(text: animal?.raza); // Controlador para la raza
    final edadController = TextEditingController(text: animal?.edad.toString() ?? ''); // Controlador para la edad
    final colorController = TextEditingController(text: animal?.color); // Controlador para el color

    return Scaffold(
      appBar: AppBar(
        title: Text(animal == null ? 'Agregar Animal' : 'Actualizar Animal') // Título dinámico dependiendo si se agrega o actualiza
      ),
      body: Container(
        color: Colors.white, // Color de fondo de la pantalla
        padding: const EdgeInsets.all(16.0), // Padding alrededor del contenido
        child: Form(
          key: formKey, // Asocia la llave de estado al formulario
          child: Column(
            children: [
              _buildTextField(
                controller: nombreController,
                label: 'Nombre', // Campo para el nombre
              ),
              const SizedBox(height: 10), // Espacio de 10 píxeles de altura
              _buildTextField(
                controller: razaController,
                label: 'Raza', // Campo para la raza
              ),
              const SizedBox(height: 10), // Espacio de 10 píxeles de altura
              _buildTextField(
                controller: edadController,
                label: 'Edad', // Campo para la edad
                keyboardType: TextInputType.number, // Establece el teclado numérico para la edad
              ),
              const SizedBox(height: 10), // Espacio de 10 píxeles de altura
              _buildTextField(
                controller: colorController,
                label: 'Color', // Campo para el color
              ),
              const SizedBox(height: 20), // Espacio de 20 píxeles de altura
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) { // Verifica si el formulario es válido
                      final animalModel = AnimalModel(
                        id: animal?.id ?? 0,
                        nombre: nombreController.text,
                        raza: razaController.text,
                        edad: int.parse(edadController.text), // Parsea la edad a entero, o 0 si es inválido
                        color: colorController.text,
                      );
                      final animalCubit = BlocProvider.of<AnimalCubit>(context);
                      if (animal == null) {
                        animalCubit.insertAnimal(animalModel); // Inserta un nuevo animal si es nulo
                      } else {
                        animalCubit.updateAnimal(animalModel); // Actualiza el animal si no es nulo
                      }
                      Navigator.pop(context); // Vuelve a la pantalla anterior
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(31, 97, 141, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                  ),
                  label: Text(
                    animal == null ? 'Agregar Animal' : 'Actualizar Animal', // Texto dinámico del botón
                    style: const TextStyle(color: Colors.white)
                  )
                )
              )
            ]
          )
        )
      )
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller, // Controlador del campo
      decoration: InputDecoration(
        labelText: label, // Etiqueta del campo
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12) // Borde redondeado para el campo de texto
        ),
        filled: true // Rellena el campo
      ),
      keyboardType: keyboardType, // Tipo de teclado
      validator: (value) {
        if (value == null || value.isEmpty) { // Valida si el campo no está vacío
          return 'Este campo es obligatorio';
        }
        return null;
      }
    );
  }
}