import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoriteView extends ConsumerStatefulWidget {
  const FavoriteView({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends ConsumerState<FavoriteView> {

  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;

    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();

    if (favoriteMovies.isEmpty) {
      final color = Theme.of(context).colorScheme;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_sharp, size: 60, color: color.primary),
            Text('Ohhh no!!', style: TextStyle(fontSize: 30, color: color.primary)),
            const Text('No tienes películas favoritas', style: TextStyle(fontSize: 20, color: Colors.black45)),

            const SizedBox(height: 20),

            FilledButton.tonal(
              onPressed: () => context.go('/home/0'), 
              child: const Text('Empieza a buscar')
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(
        movies: favoriteMovies,
        loadNextPage: loadNextPage
      )
    );
  }
}