import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controllerGMC = Completer();
  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polyline = {};
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  _onMapCreated(GoogleMapController googleMapController){
    _controllerGMC.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controllerGMC.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        /*CameraPosition(
          target: LatLng(-23.427058, -46.345645),
          zoom: 18,
          tilt: 45,
          bearing: 30 
        )*/
        _minhaCasa
      )
    );
  }

  CameraPosition _minhaCasa = CameraPosition(
    target: LatLng(-23.427058, -46.345645),
    zoom: 16,
  );

  CameraPosition _minhaCasa3D = CameraPosition(
      bearing: 0, // rotacao da camera
      target: LatLng(-23.427058, -46.345645), // alvo padrao
      tilt: 59.440717697143555, // inclinacao do angulo para ficar em 3D, depende do zoom do mapa
      zoom: 19.151926040649414 // zoom
  );

  Future<void> _irParaCasa3d() async {
    final GoogleMapController controller = await _controllerGMC.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_minhaCasa3D));
  }


  _carregarMarcadores(){

    Set<Marker> marcadoresLocal = {};
    Marker marcadorCasa = Marker(
      markerId: MarkerId("marcador-casa"),
      position: LatLng(-23.427058, -46.345645),
      infoWindow: InfoWindow(
        title: "Minha casa :D",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueCyan
      ),
      // rotation: 90,
      onTap: (){
        print("Casa clicado!");
      }
    );

    Marker marcadorEscola = Marker(
      markerId: MarkerId("marcador-escola"),
      position: LatLng(-23.425340, -46.346901),
      infoWindow: InfoWindow(
          title: "Escola :/",
      ),
    );

    marcadoresLocal.add(marcadorCasa);
    marcadoresLocal.add(marcadorEscola);

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  _configurarPoligonos() async {

    // You can can also directly ask the permission about its status.

      // The OS restricts access, for example because of parental controls.

      Set<Polygon> listaPolygons = {};
      Polygon polygon1 = Polygon(
        polygonId: PolygonId("polygon1"),
        fillColor: Color.fromRGBO(50, 220, 50, 0.2),
        strokeColor: Colors.red,
        strokeWidth: 2,
        points: [
          LatLng(-23.422548, -46.354232),
          LatLng(-23.421657, -46.347753),
          LatLng(-23.423968, -46.342336),
          LatLng(-23.428908, -46.345234),
          LatLng(-23.426904, -46.354490),
        ],
        consumeTapEvents: true, // permite o evento de onclick (true para permitir, false para bloquear).
        onTap: (){
          print("clicado dentro da area marcada!");
        },
        zIndex: 1
      );
      Polygon polygon2 = Polygon(
        polygonId: PolygonId("polygon2"),
        fillColor: Color.fromRGBO(220, 20, 255, 0.2),
        strokeColor: Colors.orange,
        strokeWidth: 2,
        points: [
          LatLng(-23.422548, -46.354232),
          LatLng(-23.421657, -46.347753),
          LatLng(-23.423968, -46.333400),
        ],
        consumeTapEvents: true, // permite o evento de onclick (true para permitir, false para bloquear).
        onTap: (){
          print("clicado dentro da area marcada 2!");
        },
        zIndex: 2
      );

      listaPolygons.add(polygon1);
      listaPolygons.add(polygon2);

      setState(() {
        _polygons = listaPolygons;
      });



  }

  _text(String label, String hit, { bool password = false, TextEditingController controller}){
    return TextFormField(
      controller: controller,
      obscureText: password,
    );
  }

  _configurarPolylines() async {

      Set<Polyline> listaPolylines = {};
      Polyline polyline = Polyline(
        polylineId: PolylineId("polyline-1"),
        color: Colors.red,
        width: 6,
        points: [
          LatLng(-23.423968, -46.342336),
          LatLng(-23.428908, -46.345234),
          LatLng(-23.426904, -46.354490),
        ],
        startCap: Cap.roundCap, // formato do inicio da linha
        endCap: Cap.squareCap, // formato do final da linha
        jointType: JointType.bevel // formato das curvas do poligono
      );

      listaPolylines.add(polyline);

      setState(() {
        _polyline = listaPolylines;
      });
  }

  _recuperarLocalizacaoAtual() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation, // precisão da localização.
    );

    // -23.427058, -46.345645
    // print("Localização:" + position.toString());
    setState(() {
      _minhaCasa = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19
      );
      _movimentarCamera();
    });
  }

  _adicionarListenerLocalizacao() async {
    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1
    ).listen((Position position) {



      Marker marcadorUsuairo = Marker(
          markerId: MarkerId("marcador-casa"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: "Meu local",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueCyan
          ),
          // rotation: 90,
          onTap: (){
            print("Meu local clicado!!");
          }
      );


      setState(() {
        _marcadores.add(marcadorUsuairo);
        _minhaCasa = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 19
        );
        _movimentarCamera();
      });

    });
  }

  @override
  void initState() {
    super.initState();
    //_carregarMarcadores();
    // _configurarPoligonos();
    //_configurarPolylines();
    // _recuperarLocalizacaoAtual();
    _adicionarListenerLocalizacao();
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
          //mapType: MapType.hybrid,
          initialCameraPosition: _minhaCasa,
          onMapCreated: _onMapCreated,
          // markers: _marcadores,
          //polygons: _polygons, // formas geometricas criadas atraves de lat e long
          //polylines: _polyline, // igual polygons, mas cria apenas linhas sem fechar uma forma geometrica
          myLocationEnabled: true,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton.extended(
        //onPressed: _irParaCasa3d,
        onPressed: _movimentarCamera,
        label: Text('Ir para casa 3D!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
}
