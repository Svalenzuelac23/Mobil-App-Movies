import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;
  
  CardSwiper({@required this.peliculas}); //forma para crear un consturctor de manera rapida


  @override
  Widget build(BuildContext context) {

  final _screen = MediaQuery.of(context).size; //MEDIA QUERY NOS DA INFORMACION DEL TAMANO DE LA PANTALLA

    return Container(      
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          peliculas[index].uniqueId = '${ peliculas[index].id }-swiper';          
          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              // child: Image(
              //   image: AssetImage('assets/img/no-image.png'),
              // ),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detalle' , arguments: peliculas[index]),
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg') ,
                  fit: BoxFit.cover,
                ),
              )
            ),
          );         
        },
        itemCount: peliculas.length,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
        layout: SwiperLayout.STACK,
        itemWidth: _screen.width * 0.65,
        itemHeight: _screen.height * 0.50,
      ),
    );
  }
}