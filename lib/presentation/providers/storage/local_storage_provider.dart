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
  return FavoriteMoviesNotifier(localStorageRepository: localStorageRepository);
});

typedef FavoriteMoviesCallback = Future<List<Movie>> Function({int offset, int limit});

class FavoriteMoviesNotifier extends StateNotifier<Map<int,Movie>> {

  int page = 0;
  LocalStorageRepository localStorageRepository;

  FavoriteMoviesNotifier({
    required this.localStorageRepository
  }): super({});

  Future<List<Movie>> loadNextPage() async {
    final List<Movie> movies = await localStorageRepository.loadMovies(offset: page * 10, limit: 20);
    page++;

    final tempMoviesMap = <int, Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }

    state = { ...state, ...tempMoviesMap};

    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    await localStorageRepository.toggleFavorite(movie);

    final bool isMovieInFavorite = state[movie.id] != null;

    if (isMovieInFavorite) {
      state.remove(movie.id);
      state = { ...state };
    } else {
      state = { ...state, movie.id: movie };
    }
  }
}