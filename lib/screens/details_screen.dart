import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          _CustomAppBar(movie: movie),

          SliverList(
            delegate: SliverChildListDelegate([
              
               _PosterAndTitle( movie: movie,),
               _Overview(texto: movie.overview),
              CastingCards( movieId: movie.id,)

            ])
          )

        ],
      )
    );
  }
}


class _CustomAppBar extends StatelessWidget {
  final Movie movie;   
  const _CustomAppBar({
    Key? key, 
    required this.movie
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          color: Colors.black12,
          child: Text(
            movie.title,
            style: const TextStyle( fontSize: 16),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          //width: 130,
          //height: 190,
          fit: BoxFit.cover,
        ),
      ),

    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  const _PosterAndTitle({Key? key, required this.movie}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only( top: 20 ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox( width: 20,),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [            
                Text(
                  movie.title, 
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  movie.originalTitle, 
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(children: [
                  const Icon( Icons.star_outline, size: 15, color: Colors.grey,),
                  const SizedBox(width: 5),
                  Text(movie.voteAverage.toString(), style: textTheme.caption)
                ],)
            ],),
          )
        ]
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  
  final String texto; 
  const _Overview({
    Key? key, 
    required this.texto
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(texto, 
        textAlign: TextAlign.justify,
        style: textTheme.subtitle1
      ),
    );
  }
}