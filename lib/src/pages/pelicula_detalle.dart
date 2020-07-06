import 'package:flutter/material.dart';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // DE ESTA FORMA ESTAMOS RECIBIENDO ARGUMENTOS CON EL PUSHNAMED DE UNA PAGINA A OTRA
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      // LOS SLIDER SON ELEMENTOS QUE HACEN CIERTAS COSAS CUANDO HACEMOS CIERTAS COSAS O MOVEMOS EL SCROLL
      body: CustomScrollView(
        // ESTOS SON LOS CHILDRENS
        slivers: <Widget>[
          _crearAppBar(pelicula),
          // ACA ESTMOS HACIENDO UNA LISTA DE SLIVER PERO QUE NO TIENEN NINGUN EFECTO, ESE SLIVERLIST ES COMO UN LISTVIEW
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox( height: 10.0),
                _posterTitulo(context, pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _crearCasting( pelicula),

              ]
            ),
          )
        ],
      )
    );
  }

  Widget _crearAppBar(Pelicula pelicula){

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style:  TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ) ,
    );

  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula){
    print(pelicula.uniqueId);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          //EL HERO HACE UNA AMINACION QUE HACE QUE UN WIDGET QUE APARECE EN OTRA PAGINA, SE ANIME Y HAGA LA TRANSICION CON UN EFECTO
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect (
              borderRadius: BorderRadius.circular(20.0) ,
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox( width: 20.0 ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title , style: Theme.of(context).textTheme.headline6 , overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle1 , overflow:  TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString() ,style: Theme.of(context).textTheme.subtitle1,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion( Pelicula pelicula) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify
      )
    );

  }

  Widget _crearCasting( Pelicula pelicula ){

    final peliculaProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliculaProvider.getCast( pelicula.id.toString() ),
      builder: ( context, AsyncSnapshot<List> snapshot ) {
        
        if(snapshot.hasData){
          return _crearActoresPageView( snapshot.data );
        } else {
          return Center(child: CircularProgressIndicator());
        }

      },
    );   

  }

  Widget _crearActoresPageView( List<Actor> actores ){

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          initialPage: 1,
          viewportFraction: 0.3
        ),
        itemCount: actores.length,
        itemBuilder: (context, i){
          return _actorTarjeta(actores[i]);
        },
      ),
    );

  }

  Widget _actorTarjeta( Actor actor ){

    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage( actor.getFoto() ),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              fit: BoxFit.cover,
              height: 150.0,
              width: 100.0,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            //style: Theme.of(context).textTheme.caption,
          )
        ],
      ),

    );


  }

}
