import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'global/presentation/screens/animals_screen.dart'; // Importa la pantalla de la lista de animales
import 'global/presentation/cubit/animal_cubit.dart'; // Importa el cubit que maneja la lógica de negocio de los animales
import 'global/data/repository/animal_repository.dart'; // Importa el repositorio que maneja las interacciones con la API

void main() {
  runApp(const MyApp()); // Inicia la aplicación llamando a la clase MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider( // Proporciona múltiples repositorios a la aplicación
      providers: [
        RepositoryProvider<AnimalRepository>( // Inyecta AnimalRepository en la aplicación
          create: (context) => AnimalRepository(
            apiUrl: 'https://imdh36vp7d.execute-api.us-east-2.amazonaws.com/Prod' // URL de la API para las operaciones CRUD
          )
        )
      ],
      child: MultiBlocProvider( // Proporciona múltiples Bloc/Cubit a la aplicación
        providers: [
          BlocProvider<AnimalCubit>( // Inyecta AnimalCubit en la aplicación
            create: (context) => AnimalCubit(
              animalRepository: RepositoryProvider.of<AnimalRepository>(context), // Usa el repositorio de animales para la lógica de negocio
            )
          )
        ],
        child: const MaterialApp( // Configura la aplicación Material
          title: 'Animal CRUD', // Título de la aplicación
          debugShowCheckedModeBanner: false, // Oculta el banner de modo debug
          home: AnimalListView() // Establece la pantalla principal como AnimalListView
        )
      )
    );
  }
}