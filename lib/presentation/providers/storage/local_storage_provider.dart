import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/infrastructure/datasources/local_storage_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/repository/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  final LocalStorageDatasource localStorageDatasource = LocalStorageDatasourceImpl();
  return LocalStorageRepositoryImpl(localStorageDatasource: localStorageDatasource);
});

final isFavoriteMovieProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final LocalStorageRepository localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

final favoriteMoviesProvider = StateNotifierProvider<FavoriteMoviesNotifier, Map<int, Movie>>((ref) {
  final LocalStorageRepository localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return FavoriteMoviesNotifier(favoriteMoviesCallback: localStorageRepository.loadMovies);
});

typedef FavoriteMoviesCallback = Future<List<Movie>> Function({int offset});

class FavoriteMoviesNotifier extends StateNotifier<Map<int,Movie>> {

  int page = 0;
  FavoriteMoviesCallback favoriteMoviesCallback;

  FavoriteMoviesNotifier({
    required this.favoriteMoviesCallback
  }): super({});

  Future<void> loadNextPage() async {
    final List<Movie> movies = await favoriteMoviesCallback(offset: page * 10);
    page++;

    final tempMoviesMap = <int, Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }

    state = { ...state, ...tempMoviesMap};
  }
}