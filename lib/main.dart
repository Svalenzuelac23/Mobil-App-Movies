import 'package:flutter/material.dart';
 
import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/pelicula_detalle.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Peliculas',
      initialRoute: '/',
      routes: {
        '/'       : (context) => HomePage(),
        'detalle' : (context) => PeliculaDetalle(),    
            

      },
      
    );
  }
}