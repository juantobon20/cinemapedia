import 'package:cinemapedia/domain/datasources/actor_datasource.dart';
import 'package:cinemapedia/domain/repositories/actor_repository.dart';
import 'package:cinemapedia/infrastructure/datasources/actor_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/repository/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final  actorRepositoryProvider = Provider<ActorRepository>((ref) {
  final ActorDatasource actorDatasource = ActorDatasourceImp();
  return ActorRepositoryImpl(actorDatasource);
});