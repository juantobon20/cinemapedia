import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movie_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryMovieProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider = StateNotifierProvider<SearchMoviesNotifier,List<Movie>>((ref) {
  final MovieRepository movieRepository = ref.read(movieRepositoryProvider); 
  
  return SearchMoviesNotifier(
    searchMoviesCallback: movieRepository.searchMovies, 
    ref: ref
  );
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {

  final SearchMoviesCallback searchMoviesCallback;
  final Ref ref;
  
  SearchMoviesNotifier({
    required this.searchMoviesCallback,
    required this.ref
  }) : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMoviesCallback(query);

    ref.read(searchQueryMovieProvider.notifier).update((state) => query);

    state = movies;
    return movies;
  }
}