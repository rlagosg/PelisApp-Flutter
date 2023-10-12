import 'package:flutter/material.dart';
import 'screens/screens.dart';
import 'package:provider/provider.dart';

import 'package:peliculas/providers/movies_provider.dart';

void main() => runApp(const AppState());

//estado de la aplicacion
class AppState extends StatelessWidget {
  const AppState({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> MoviesProvider(), lazy: false,),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas App',
      initialRoute: 'home',
      routes: {
        'home': ( _ ) => const HomeScreen(),
        'details': ( _ ) => const DetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.indigo
        )
      ),
    );
  }
}