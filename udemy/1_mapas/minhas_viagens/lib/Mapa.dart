import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'DisposableWidget.dart';

class Mapa extends StatefulWidget {

  String idViagem;

  Mapa({this.idViagem});

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> with DisposableWidget {

  Completer<GoogleMapController> _controllerGMC = Completer();
  CameraPosition _initialCamera;
  Set<Marker> _marcadores = {};


  _movimentarCamera() async {
      GoogleMapController googleMapController = await _controllerGMC.future;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          _initialCamera
        )
      );
  }

  _minhaLocalizacao() async {


    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 1,
    ).listen((Position position) {
      setState(() {
        _initialCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 19
        );
        _movimentarCamera();
      });
    }).canceledBy(this);



  }

  _adicionarMarcador(LatLng latlng) async {

    print(latlng.toString());

    List<Placemark> listaEnderecos = await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    print(listaEnderecos.toString());
    if(listaEnderecos != null && listaEnderecos.length > 0){
      Placemark endereco = listaEnderecos[0];
      String rua = endereco.thoroughfare;

      Marker marcador = Marker(
        markerId: MarkerId("marcador-${latlng.latitude}-${latlng.latitude}"),
        position: latlng,
        infoWindow: InfoWindow(
          title: rua,
        ),
      );

      setState(() {
        _marcadores.add(marcador);
      });

      await Firebase.initializeApp();
      FirebaseFirestore db = FirebaseFirestore.instance;

      Map<String, dynamic> viagem = Map();
      viagem['titulo'] = rua;
      viagem['latitude'] = latlng.latitude;
      viagem['longitude'] = latlng.longitude;

      await db.collection('viagens')
      .add(viagem).then((value){
          print('Sucesso!');
      }).catchError((onError){
        print("Erro ao salvar na base de dados!\nErro: "+onError.toString());
        return false;
      });

    }


  }

  _recuperaViagemPeloID(String idViagem) async {
    if(idViagem != null){
      Firebase.initializeApp();
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentSnapshot documentSnapshot = await db.collection('viagens').doc(idViagem).get();
      
      Map<String, dynamic> dados = documentSnapshot.data();

      print(dados);
      
      String titulo = dados['titulo'];
      LatLng latLng = LatLng(dados['latitude'], dados['longitude']);

      Marker marcador = Marker(
        markerId: MarkerId("marcador-${latLng.latitude}-${latLng.latitude}"),
        position: latLng,
        infoWindow: InfoWindow(
          title: titulo,
        ),
      );

      setState(() {
        _marcadores.add(marcador);
        _initialCamera = CameraPosition(
            target: latLng,
            zoom: 18
        );
        _movimentarCamera();
      });
      
    }else{

      _minhaLocalizacao();
    }
  }


  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }
  @override
  void initState() {    
    _recuperaViagemPeloID(widget.idViagem);
    super.initState();

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa"),
        backgroundColor: Color(0xff0066cc),
      ),
      body: Container(
        child: _initialCamera == null
        ? Container(child: Center(child: CircularProgressIndicator(),),)
        : GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _initialCamera,
          markers: _marcadores,
          onMapCreated: (GoogleMapController controller){
            _controllerGMC.complete(controller);
          },
          myLocationEnabled: true,
          onLongPress: _adicionarMarcador,
        ),
      ),
    );
  }
}
