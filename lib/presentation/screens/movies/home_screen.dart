import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/movies/movies_slide_show_provider.dart';

class HomeScreen extends StatelessWidget {
  static const name = "HomeScreen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final moviesSlideShow = ref.watch(moviesSlideShowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            centerTitle: false,
            title: CustomAppBar(),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
            children: [
              MovieSlideShow(movies: moviesSlideShow),
          
              MovieHorizontalListView(
                movies: nowPlayingMovies,
                title: 'En cines',
                subTitle: 'Lunes 20',
                loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
              ),
          
              MovieHorizontalListView(
                movies: nowPlayingMovies,
                title: 'Próximamente',
                subTitle: 'En este mes',
                loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
              ),
          
              MovieHorizontalListView(
                movies: nowPlayingMovies,
                title: 'Populares',
                loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
              ),
          
              MovieHorizontalListView(
                movies: nowPlayingMovies,
                title: 'Mejor calificadas',
                subTitle: 'Desde siempre',
                loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
              ),

              const SizedBox(height: 10)
            ],
          );
          },
          childCount: 1),
        )
      ]
      
    );
  }
}
