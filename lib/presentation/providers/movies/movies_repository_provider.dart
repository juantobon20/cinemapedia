
import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/repositories/movie_repository.dart';
import 'package:cinemapedia/infrastructure/datasources/movie_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/repository/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final MovieDatasoruce movieDatasoruce = MovieDatasoruceImpl();
  return MovieRepositoryImpl(movieDatasoruce);
});