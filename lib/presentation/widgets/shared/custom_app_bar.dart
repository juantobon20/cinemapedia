import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: color.primary),
              const SizedBox(width: 5),
              Text('Cinemapedia', style: titleStyle),
              const Spacer(),
              IconButton(onPressed: () {
                final searchedMovies = ref.read(searchedMoviesProvider);
                final searchQuery = ref.read(searchQueryMovieProvider);

                showSearch<String?>(
                  context: context, 
                  query: searchQuery,
                  delegate: SearchMovieDelegate(
                    initialMovies: searchedMovies,
                    searchMovieCallback: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery
                  )
                ).then((movieId) {
                  if (movieId != null) {
                    context.push('/movie/$movieId');
                  }
                });
              }, icon: const Icon(Icons.search))
            ],
          ),
        ),
        ),
    );
  }
}