import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../search/search_delegate.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    //traemos los datos con un provider
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()), 
            icon:const  Icon( Icons.search_outlined )
          )
        ],
      ),
      //SingleChildScrollView permite hacer scroll en listas
      body: SingleChildScrollView(
        child: Column(          
          children: [

            //tarjetas principales
            CardSwiper( movies: moviesProvider.onDisplayMovies ),
            
            const SizedBox(
              height: 5,
            ),
      
            //slider de peliculas
            MovieSlider( 
              movies: moviesProvider.popularMovies,
              title: 'Populares',
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
            MovieSlider( 
              movies: moviesProvider.popularMovies,
              title: 'Estrenos',
              onNextPage: () => moviesProvider.getUpComingMovies(),
            ),
          ],
          //Listado horizontal de peliculas
        ),
      )
    );
  }
}