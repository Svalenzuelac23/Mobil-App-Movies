import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  //ACA ESTMOS SOBREESCIBIENDO UNA PROPIEDAD DE LA CLASE SEARCH DELEGATE
  @override 
  String get searchFieldLabel => 'Buscar peliculas';

  

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [

    'IronMan 1',
    'Capitan Marvel',
    'Harry Potter 1',
    'Harry Potter 2',
    'Harry Potter 3',
    'Harry Potter 4',
    'Harry Potter 5',
    'Vengadores',
    'Son como ninos',
    'Yo Robot'

  ];

  final peliculasRecientes = [

    'SpiderMan',
    'Capitan America'

  ];


  @override
  List<Widget> buildActions(BuildContext context) {
    //SON TODAS LAS ACCIONES DE NUESRO APP BAR, POR EJEMLO EL CANCELAR O LA X PARA BORRAR LO QUE SE HA ESCRITO
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query='';
        },
      )

    ];        
  }

  @override
  Widget buildLeading(BuildContext context) {
    // ICONO O ICONOS PARA DEL APPBAR
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,   
        progress: transitionAnimation,     
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // CREA LOS RESULTADOS QUE VAMOS A MOSTRAR SEGUN LA BUSQUEDA
    
    return Container();

    //ACA ESTAMOS RETORNANDO LOS RESULTADO DE LA LISTA SUGERIADA
    // return Center(
    //   child: Container(
    //     height: 100.0,
    //     width: 100.0,
    //     color: Colors.blue,
    //     child: Text( seleccion ),
    //   ),
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // ESTAS SON LAS SUGERENCIAS QUE SE LE ETSAN MOSTRANDO AL USUARIO CONFORME VAYA ESCRIBIENDO

    if ( query.isEmpty ) {
      return Container();
    } 


    return FutureBuilder(
      future: peliculasProvider.busarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        if ( snapshot.hasData ) {

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula) {

              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0 ,
                  fit: BoxFit.contain,
                ),
                title: Text( pelicula.title ),
                subtitle: Text( pelicula.originalTitle ),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId='';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula );
                },
              );

            }).toList() ,
          );

        } else {
          return Center(
            child: CircularProgressIndicator());
        }
      },
    );



    // //ACA ESTAMOAS RETORNANDO UN WIDGET DE PRUEBA CNO UNA LISTA HECHA A MANO
    // final peliculasSugeridas = ( query.isEmpty ) 
    //                           ? peliculasRecientes
    //                           : peliculas.where((x) => x.toLowerCase().contains(query.toLowerCase())
    //                           ).toList();

    // return ListView.builder(
    //   itemCount: peliculasSugeridas.length,
    //   itemBuilder: ( context, i ){

    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(peliculasSugeridas[i]),
    //       onTap: (){
    //         seleccion = peliculasSugeridas[i];
    //         showResults(context); //ESTE METODO ES PARA MOSTRAR LOS RESULTADOS, ESTE METODO ES PROPIO DEL SEARCH DELEGATE
    //       },
    //     );
    //   },
    // );
  
  }

}