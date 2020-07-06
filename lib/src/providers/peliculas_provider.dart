
import 'package:http/http.dart' as http; //ACA LE ESTOY PONIENDO UN ALIAS PARA PODER PONER EL ALIAS PARA LLAMAR LOS ELEMENTOS

import 'dart:async'; //ESTA IMPORTACION ES PARA USAR LOS STREAMS
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';


class PeliculasProvider{

  String _apiKey   = '33fb168e90f5644cd64c6afe296bdf89';
  String _url      = 'api.themoviedb.org';
  String _lenguage = 'es-ES';

  int _popularesPage = 0;
  bool _cargando     = false;

  List<Pelicula> _populares = new List();  

  //ACA ESTMOS CREADNO EL STREAM CONTROLLER
  //EL BROADCAST ES PARA QUE VARIOS LUGARES PUEDAN ESCIUCHAR EL MISMO STREAM
  //LOS TIPOS DE STREAM SON SINGLE Y EL BROADCAST
  final _popularesStreamController = new StreamController<List<Pelicula>>.broadcast(); 

  //ESTE GETTER ES PARA AGREGAR INFORMACION AL STREAM
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  //ESTE GETTER NOS PERMITE ESCUCHAR LA INFORMACION DEl STREAM
  Stream<List<Pelicula>> get popularesStream  => _popularesStreamController.stream;

  // SI NO PONEMOS ESTE METODO EL CONTROLLER DA ERROR, YA QUEDEMOS CERRAR EL STREAM CUANDO YA NO ES VA A UTILIZAR
  void dispose(){
    _popularesStreamController?.close();
  }

  //ACA ESTMOS AHORRANDO CODIGO, Y UNIFICANDO EL PROCESAR LA RESPUESTA EN DE AMBOS METODOS CREADOS
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async{

    final resp = await http.get(url); // USAMOS EL AWAIT PARA ESPERAR LA RESPUESTA, SI NO TUVIERA AWAIT LA VARIABLE RESP SERIA UN FUTURE
    final decodedData = json.decode(resp.body); //ESTAMOS OBTENIENDO SOLO EL BODY DE LA PETICION HTTP
    final peliculas = new Peliculas.fromJsonList(decodedData['results']); //ACA ESTAMOS CREANDO UNA NUEVA INSTANCIA DE LA CLASE PELICULAS Y MEDIANTE EL CONTRUCTOR
    //ESTAMOS RECORRIENDO EL MAPA Y PASANDOLO A NUESTRA CLASE  

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing',{ //URI NOS PERMITE ARMAR UNA URL MAS FACIL QUE ARMAR LA URL MANUAL
      'api_key'  : _apiKey,
      'language' : _lenguage
    });

    return _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {

    //ACA ESTAMOS HACIENDO UNA VALIDACION PARA NO CARGAR MAS PELICULAS SI YA HAY UNA CARGA EN PROCESO
    if(_cargando) return [];

    _popularesPage ++;

    //COMO NO ESTA CARGANDO ENTONCES HACEMOS LA CONSULTA A LA API Y PONEMOS TRUE PARA QUE NO HAGAMOS OTRA CONSULTA
    //SI LA ANTERIOR AUN ESTA CARGANDO
    _cargando =true;

    final url = Uri.https(_url, '3/movie/popular',{ //URI NOS PERMITE ARMAR UNA URL MAS FACIL QUE ARMAR LA URL MANUAL
      'api_key'  : _apiKey,
      'language' : _lenguage,
      'page'     : _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);

    //ACA ESTAMOS ENVIANDO LA INFORMACION AL STREAM
    popularesSink(_populares);

    // ACA YA TERMINO LA CARGA Y PODEOMS VOVLER A CAONSULTAR POR MAS PELICULAS POPULARES
    _cargando=false;
    return resp;


    //ESTE RETURN ES LA FORMA VIEJA CON LA QUE SE HIZO
    //return _procesarRespuesta(url);
  }

  Future<List<Actor>> getCast(String peliId) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key'  : _apiKey,
      'language' : _lenguage
    });

    final resp = await http.get(url);
    final decodedData = json.decode( resp.body );
    final cast = Cast.fromJsonList( decodedData['cast'] );

    return cast.actores;
  }

  Future<List<Pelicula>> busarPelicula( String query ) async {

    final url = Uri.https(_url, '3/search/movie',{ //URI NOS PERMITE ARMAR UNA URL MAS FACIL QUE ARMAR LA URL MANUAL
      'api_key'  : _apiKey,
      'language' : _lenguage,
      'query'    : query
    });

    return _procesarRespuesta(url);
  }
}