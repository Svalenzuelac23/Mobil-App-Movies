import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  //ESTA ES UNA FUNCION CALL BACK
  final Function siguientePagina;

  MovieHorizontal({ @required this.peliculas, @required this.siguientePagina });

  @override
  Widget build(BuildContext context) {

    final _screen = MediaQuery.of(context).size;

    final _pageController = new PageController(
      initialPage: 1,
      viewportFraction: 0.30
    );

    //ESTE ES EL METODO QUE ESTA ESCUCHANDO EL SCROLL DEL PAGEVIEW PARA SABER LA POSICION DEL SCROLL
    _pageController.addListener(() {
      
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        siguientePagina();
      }
    });
    
    return Container(
      height: _screen.height * 0.2 ,
      // LA DIFERENCIA ENTRE EL PAGEVIEW Y EL PAGEVIEW BUILDER ES QUE EL BUILDER VA IR RENDERIZANDO A DEMANDA SEGUN SEA LA NECESARIDAD
      // EN CAMBIO EL PAGEVIEW RENDERIZA AL MISMO TIEMPO, Y SI SON MUCHOS ITEMS PUEDE DAR PROBLEMA DE MEMORIA
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // EL CHILDREN DE UTILIZA SOLO PARA EL PAGEVIEW
        // children: _tarjetas(context),
        itemCount: peliculas.length, // ACA LE DEFINIMOS CUANTOS SERAN LOS ITEMS QUE TIENE QUE RENDERIZAR POR TODOS
        itemBuilder: (context, i){ // EL I ES EL INDEX DEL PAGEVIEW
          return _tarjeta(context, peliculas[i]);
        },
      ),
    );      
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula){

    pelicula.uniqueId = '${ pelicula.id }-pageview';

    final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),        
        child: Column(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect (
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 135.0,
                  //width: 50.0,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis, //ACA LE ESTAMOS DICIENDO QUE NOS PONGA 3 PUNTOS SI EL TEXTO ES MUY LARGO
              style: Theme.of(context).textTheme.caption, // USAMOS EL THEMA DE NUESTRA APLICACION
            )
          ],
        ) ,
      );

      // EL GESTURE DETECTOR ES PARA CAPTAR ALGUN GESTO QUE SE HAGA SOBRE ALGO, TIENE MUCHOS EVENTOS
      return GestureDetector(
        child: tarjeta,
        onTap: (){
          // ACA ESTAMOS NAVEGANDO DE UNA PAGINA A OTRA MEDIANTE EL TAP EN UNA TARJETA
          Navigator.pushNamed(context, 'detalle' , arguments: pelicula);
        },
      );
  }

  // List<Widget> _tarjetas(BuildContext context){

  //   return peliculas.map((pelicula) {

  //     return Container(
  //       margin: EdgeInsets.only(right: 15.0),        
  //       child: Column(
  //         children: <Widget>[
  //           ClipRRect (
  //             borderRadius: BorderRadius.circular(20.0),
  //             child: FadeInImage(
  //               image: NetworkImage(pelicula.getPosterImg()),
  //               placeholder: AssetImage('assets/img/no-image.jpg'),
  //               fit: BoxFit.cover,
  //               height: 135.0,
  //             ),
  //           ),
  //           SizedBox(height: 5.0),
  //           Text(
  //             pelicula.title,
  //             overflow: TextOverflow.ellipsis, //ACA LE ESTAMOS DICIENDO QUE NOS PONGA 3 PUNTOS SI EL TEXTO ES MUY LARGO
  //             style: Theme.of(context).textTheme.caption, // USAMOS EL THEMA DE NUESTRA APLICACION
  //           )
  //         ],
  //       ) ,
  //     );

  //   }).toList();

  // }

}