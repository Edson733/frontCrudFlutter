import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/animal_repository.dart';
import '../../data/models/animal_model.dart';
import '../cubit/animal_state.dart';
import '../cubit/animal_cubit.dart';

class AnimalListView extends StatelessWidget {
  const AnimalListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animales',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          )
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(52, 152, 219, 1),
        elevation: 4.0,
      ),
      body: BlocProvider(
        create: (context) => AnimalCubit(
          animalRepository: RepositoryProvider.of<AnimalRepository>(context)
        ),
        child: Container(
          color: Colors.white,
          child: const AnimalListScreen(),
        )
      )
    );
  }
}

class AnimalListScreen extends StatelessWidget {
  const AnimalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final animalCubit = BlocProvider.of<AnimalCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  animalCubit.fetchAllAnimals();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(31, 97, 141, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                ),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('Recargar', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<AnimalCubit>(context),
                        child: const AnimalFormScreen(),
                      ),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(31, 97, 141, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Agregar', style: TextStyle(color: Colors.white)),
              )
            ]
          ),
          const SizedBox(height: 10),
          const Text('¡No olvides recargar para ver los cambios!', style: TextStyle(fontSize: 11)),
          Expanded(
            child: BlocBuilder<AnimalCubit, AnimalState>(
              builder: (context, state) {
                if (state is AnimalLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AnimalSuccess) {
                  final animals = state.animals;
                  return ListView.builder(
                    itemCount: animals.length,
                    itemBuilder: (context, index) {
                      final animal = animals[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: const Color.fromRGBO(133, 193, 233, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                animal.nombre,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 8),
                              Text('ID: ${animal.id}'),
                              Text('Raza: ${animal.raza}'),
                              Text('Edad: ${animal.edad} años'),
                              Text('Color: ${animal.color}'),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider.value(
                                            value: BlocProvider.of<AnimalCubit>(context),
                                            child: AnimalFormScreen(animal: animal)
                                          )
                                        )
                                      );
                                    }
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      context.read<AnimalCubit>().deleteAnimal(animal.id);
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
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(child: Text('Presiona el botón para cargar los animales'));
              }
            )
          )
        ]
      )
    );
  }
}

class AnimalFormScreen extends StatelessWidget {
  final AnimalModel? animal;

  const AnimalFormScreen({super.key, this.animal});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController(text: animal?.nombre);
    final razaController = TextEditingController(text: animal?.raza);
    final edadController = TextEditingController(text: animal?.edad.toString() ?? '');
    final colorController = TextEditingController(text: animal?.color);

    return Scaffold(
      appBar: AppBar(
        title: Text(animal == null ? 'Agregar Animal' : 'Actualizar Animal')
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: nombreController,
                label: 'Nombre',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: razaController,
                label: 'Raza',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: edadController,
                label: 'Edad',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: colorController,
                label: 'Color',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final animalModel = AnimalModel(
                        id: animal?.id ?? 0,
                        nombre: nombreController.text,
                        raza: razaController.text,
                        edad: int.parse(edadController.text),
                        color: colorController.text,
                      );
                      final animalCubit = BlocProvider.of<AnimalCubit>(context);
                      if (animal == null) {
                        animalCubit.insertAnimal(animalModel);
                      } else {
                        animalCubit.updateAnimal(animalModel);
                      }
                      Navigator.pop(context);
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
                    animal == null ? 'Agregar Animal' : 'Actualizar Animal',
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
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        filled: true
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      }
    );
  }
}