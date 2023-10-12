import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier{

  final String _apiKey   = 'c9b65a0cc07ed97c66640f808285f54d';
  final String _baseUrl  = 'api.themoviedb.org';
  final String _lenguage = 'es-ES';

  //https://api.themoviedb.org/3/movie/now_playing?api_key=c9b65a0cc07ed97c66640f808285f54d&language=es-ES&page=1

  //lista de peliculas luego de mapear
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> upComingMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  //paginacion
  int _popularPage = 0;
  int _upComingPage = 0;

  //buscador
  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
    //onValue: 
  );
  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionstream => _suggestionStreamController.stream;


  //constructor
  MoviesProvider(){
    print('MoviesProvider inicializado');
    //llamamos el metodo para traer datos
    getOnDisplayMovies();
    getPopularMovies();

  }

  Future<String> _getJsonData( String endPoint, [int page = 1]) async{
    //creamos la url de los datos
    final url =
      Uri.https(_baseUrl, endPoint, {
        //parametros del query
        'api_key'  : _apiKey,
        'language' : _lenguage,
        'page'     : '$page'
      });
    
    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  //metodo para llamar mi servicio y traer datos
  getOnDisplayMovies() async {

    //data
    final jsonData = await _getJsonData('3/movie/now_playing');

    //pasamos los datos a un mapa
    final nowPlayingResponse = NowPlayingResponse.fromJson( jsonData );
    onDisplayMovies = nowPlayingResponse.results;
    
    //redibujamos la app cuando hay cambios en los datos
    notifyListeners();

  }

  getPopularMovies() async{
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson( jsonData );
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  getUpComingMovies() async{
    _upComingPage++;
    final jsonData = await _getJsonData('3/movie/upcoming', _upComingPage);
    final upComingResponse = UpComingResponse.fromJson( jsonData );
    upComingMovies = [...upComingMovies, ...upComingResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async{

    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;

  }

  Future<List<Movie>> searchMovies ( String query) async{
    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _lenguage,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson( response.body );

    return searchResponse.results;
  }

  //buscador
  void getSuggestionsByQuery( String searchTerm ){
    debouncer.value = '';
    debouncer.onValue =(value) async {
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
  

}