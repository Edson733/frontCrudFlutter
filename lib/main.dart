import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'global/presentation/screens/animals_screen.dart';
import 'global/presentation/cubit/animal_cubit.dart';
import 'global/data/repository/animal_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AnimalRepository>(
          create: (context) => AnimalRepository(
            apiUrl: 'https://imdh36vp7d.execute-api.us-east-2.amazonaws.com/Prod'
          )
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AnimalCubit>(
            create: (context) => AnimalCubit(
              animalRepository: RepositoryProvider.of<AnimalRepository>(context),
            )
          )
        ],
        child: const MaterialApp(
          title: 'Animal CRUD',
          debugShowCheckedModeBanner: false,
          home: AnimalListView()
        )
      )
    );
  }
}