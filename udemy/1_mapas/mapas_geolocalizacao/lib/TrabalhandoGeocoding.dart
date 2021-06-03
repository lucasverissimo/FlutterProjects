import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrabalhandoGeocoding extends StatefulWidget {
  @override
  _TrabalhandoGeocodingState createState() => _TrabalhandoGeocodingState();
}

class _TrabalhandoGeocodingState extends State<TrabalhandoGeocoding> {

  Completer<GoogleMapController> _controllerGMC = Completer();

  _onMapCreated(GoogleMapController googleMapController){
    _controllerGMC.complete(googleMapController);
  }

  CameraPosition _minhaLocalidade = CameraPosition(
    target: LatLng(-23.427058, -46.345645),
    zoom: 19,
  );

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controllerGMC.future;
    googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
            _minhaLocalidade
        )
    );
  }

  _recuperarLocalParaEndereco() async {

    // pegando coordenadas atraves de endereço
    List<Location> listaEnderecosCoord = await locationFromAddress("Av. Paulista, 1372");

    if(listaEnderecosCoord != null && listaEnderecosCoord.length > 0) {
      Location endereco = listaEnderecosCoord[0];

      String resultado1;
      resultado1 = "\n LAT: "+endereco.latitude.toString();
      resultado1 += "\n LONG: "+endereco.longitude.toString();
      print(resultado1);

      // pegando endereço através de coordenadas
      List<Placemark> listaEnderecos = await placemarkFromCoordinates(endereco.latitude, endereco.longitude);
      if(listaEnderecos != null && listaEnderecos.length > 0){
        Placemark endereco = listaEnderecos[0];

        String resultado;
        resultado  = "\n administrativeArea: "+endereco.administrativeArea;
        resultado += "\n subAdministrativeArea: "+endereco.subAdministrativeArea;
        resultado += "\n locality: "+endereco.locality;
        resultado += "\n subLocality: "+endereco.subLocality;
        resultado += "\n thoroughfare: "+endereco.thoroughfare;
        resultado += "\n subThoroughfare: "+endereco.subThoroughfare;
        resultado += "\n postalCode: "+endereco.postalCode;
        resultado += "\n country: "+endereco.country;
        resultado += "\n isoCountryCode: "+endereco.isoCountryCode;


        print("Resultado: "+resultado);
      }

    }


  }

  @override
  void initState() {
    super.initState();
    _recuperarLocalParaEndereco();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home - Mapas e Geolocalizaçao"),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _minhaLocalidade,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _movimentarCamera,
        label: Text('Movimentar Camera!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
}
