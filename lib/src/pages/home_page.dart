import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();
  

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cine'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
          ],
        ),
      ),
    );
  }


  Widget _swiperTarjetas(){

  return FutureBuilder(
    future: peliculasProvider.getEnCines() ,
    //initialData: InitialData,
    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
      
      if(snapshot.hasData){
        return CardSwiper(
          peliculas: snapshot.data,
        );
      } else{
        return Container(
          height: 400.0,
          child: Center(
            child: CircularProgressIndicator()
          )
        );
      }
    },
  ); 
  
}

  Widget _footer(BuildContext context){

    return Container(
      width: double.infinity,      
      //color: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[          
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subtitle1)),
          SizedBox(height: 5.0,),  

          StreamBuilder(
            stream: peliculasProvider.popularesStream ,            
            builder: (BuildContext context, AsyncSnapshot snapshot){

              if(snapshot.hasData){
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  //ACA LE ESTAMOS PASADADO COMO REFERENCIA ESTA FUNCION AL WIDGET MOVIE HORIZONTAL
                  siguientePagina: peliculasProvider.getPopulares, 
                );
              }else{
                return Center(child: CircularProgressIndicator());
              }              
            },
          ), 


          //DIFERENCIA ENTRE STREAM BUILDER Y UN FUTURE BUILDER ES QUE EL FUTURE SOLO SE EJECUTA UNA VEZ Y EL STREAM
          //CADA VEZ QUE RECIBE INFORMACION       
          // FutureBuilder(
          //   future: peliculasProvider.getPopulares(),            
          //   builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
              
          //     //SOLO PARA IMPRIMIR EL NOMBRE DE LO QUE ESTOY RECIBIENDO
          //     // snapshot.data?.forEach((pelicula) { 
          //     //   print(pelicula.title);
          //     // });

          //     if(snapshot.hasData){
          //       return MovieHorizontal(peliculas: snapshot.data);
          //     }else{
          //       return Center(child: CircularProgressIndicator());
          //     }
          //   },
          // ),
        ],
        
      ),
    );
  }

}