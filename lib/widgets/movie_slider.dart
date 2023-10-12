import 'package:flutter/material.dart';

import '../models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> movies;
  final String? title;

  //funcion para traer mas datos de otras paginas
  final Function onNextPage;

   
  const MovieSlider({
    Key? key, 
    required this.movies, 
    this.title, 
    required this.onNextPage
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  //pedir nuevas peliculas por medio del scroll
  final ScrollController scrollControler = ScrollController();

  @override
  void initState() {
    scrollControler.addListener(() { 
      if( scrollControler.position.pixels >= scrollControler.position.maxScrollExtent - 500 ){
        widget.onNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //todo el ancho posible
      width: double.infinity,
      height: 275,
      //color: Colors.red,
      child: Column(
        //poner texto al inicio
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //titulo
          if(widget.title != null)
              Padding(
            padding: const EdgeInsets.symmetric( horizontal: 20),
            child: Text(widget.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold ))
          ),


          const SizedBox(
            height: 5,
          ),

          Expanded(
            child: ListView.builder(
              controller: scrollControler,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, index) => _MoviePoster( movie: widget.movies[index], heroId: '${widget.title}-$index-${widget.movies[index].id}',)            
            ),
          ),
        ]
      ),
    );
  }
}


class _MoviePoster extends StatelessWidget {
  
  final Movie movie;
  final String heroId;
  const _MoviePoster({Key? key, required this.movie, required this.heroId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      //color: Colors.green,
      margin: const EdgeInsets.symmetric( horizontal: 10, vertical: 10),
      child: Column(
        children: [
          //para  hacer clic en las imagenes
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
          //para hacer bordes reondondos
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                //imagen
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )


        ],
      ),
    );
  }
}