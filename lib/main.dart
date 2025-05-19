import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'core/network/network_client.dart';
import 'feature/exercise/data/datasources/exercise_remote_data_source.dart';
import 'feature/exercise/data/repositories/exercise_repository_impl.dart';
import 'feature/exercise/presentation/bloc/exercise_bloc.dart';
import 'feature/exercise/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create dependencies once at the app level
    final httpClient = http.Client();
    final networkClient = NetworkClient(client: httpClient);
    final remoteDataSource = ExerciseRemoteDataSourceImpl(client: networkClient);
    final repository = ExerciseRepositoryImpl(remoteDataSource: remoteDataSource);
    final exerciseBloc = ExerciseBloc(repository: repository);

    return BlocProvider.value(
      value: exerciseBloc,
      child: MaterialApp(
        title: 'Exercise App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
}