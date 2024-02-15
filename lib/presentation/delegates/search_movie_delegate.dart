import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_format.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<String?> {

  final SearchMovieCallback searchMovieCallback;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovieCallback,
    required this.initialMovies
  });

  void clearDebounced() {
    debouncedMovies.close();
  }

  void _onQueryChange(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    isLoadingStream.add(true);

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovieCallback(query);
      
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
     });
  }

  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
        StreamBuilder(
          initialData: false,
          stream: isLoadingStream.stream, 
          builder: (context, snapshot) {
            if (snapshot.data ?? false) {
              return SpinPerfect (
                duration: const Duration(seconds: 2),
                infinite: true,
                spins: 10,
                child: IconButton(
                  onPressed: () => query = "",
                  icon: const Icon(Icons.refresh_rounded)
                ),
              );
            }

            return FadeIn (
              animate: query.isNotEmpty,
              child: IconButton(
                onPressed: () => query = "",
                icon: const Icon(Icons.clear)
              ),
            );
          }
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearDebounced();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChange(query);
    return buildResultsAndSuggestions();
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final List<Movie> movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearDebounced();
              close(context, movie);
            },
          )
        );
      }
    );
  }
}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie,
    required this.onMovieSelected
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie.id.toString());
      },
      child: FadeIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              //* Image
              SizedBox(
                width: size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    height: 130,
                    fit: BoxFit.cover,
                    image: NetworkImage(movie.posterPath),
                    placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                  ),
                ),
              ),
        
              const SizedBox(width: 10),
        
              //* Description
              SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textTheme.titleMedium),
        
                    movie.overview.length > 100
                      ? Text('${movie.overview.substring(0,100)}...')
                      : Text(movie.overview),
        
                    Row(
                      children: [
                        Icon(Icons.star_half_rounded, color: Colors.yellow.shade800),
        
                        const SizedBox(width: 5),
        
                        Text(
                          HumanFormats.number(movie.voteAverage, 1), 
                          style: textTheme.bodyMedium!.copyWith(color: Colors.yellow.shade900)
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}