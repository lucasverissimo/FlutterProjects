import 'package:city_trip/model/Usuario.dart';
import 'package:city_trip/util/StatusRequisicao.dart';
import 'package:city_trip/util/UsuarioFirebase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:city_trip/util/DisposableWidget.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_directions_api/google_directions_api.dart' as GD_API;
import 'package:intl/intl.dart';


class Corrida extends StatefulWidget {

  String idRequisicao;
  Corrida(this.idRequisicao);

  @override
  _CorridaState createState() => _CorridaState();
}

class _CorridaState extends State<Corrida> with DisposableWidget {

  Completer<GoogleMapController> _controllerGMC = Completer();
  CameraPosition _myLocation;
  bool _isLoadingLocation = false;
  Set<Marker> _marcadores = {};
  Map<String, dynamic> _dadosRequisicao;
  String _textoBotao = "Aceitar Corrida";
  Color _corBotao = Color(0xffe51b23);
  Function _funcaoBotao;
  // Position _localMotorista;
  String _mensagemStatus = "";
  Position _localMotorista;
  String _statusRequisicao = StatusRequisicao.AGUARDANDO;
  bool _chegouNoPassageiro = false;
  int _inRouteWithPassasger = 0;
  Set<Polyline> _polyline = {};
  List<LatLng> polylineCoordinates = [];
  int _inRouteWithDestiny = 0;


  _getMyLocation() async {
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    Position position;
    position = await Geolocator.getLastKnownPosition();

    if(position == null){
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    }



    _exibirMarcadorPassageiro(position);
    setState(() {

      _myLocation =  CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19,
      );
      _isLoadingLocation = true;
      _moveCamera(_myLocation);
      _localMotorista = position;

    });


  }

  _moveCamera(CameraPosition cameraPosition) async {

    GoogleMapController gcm = await _controllerGMC.future;
    gcm.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition)
    );
  }

  _moveCameraBounds(LatLngBounds latLgnBounds) async {

    GoogleMapController gcm = await _controllerGMC.future;
    gcm.animateCamera(
        CameraUpdate.newLatLngBounds(
            latLgnBounds,
            100,
        ),

    );
  }

  Future _streamMoveCamara() async {
    Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.high,
        distanceFilter: 10
    ).listen((Position position) {

      if(widget.idRequisicao != null && widget.idRequisicao.isNotEmpty){

        if(_statusRequisicao != StatusRequisicao.AGUARDANDO){
          print("Request diferente de aguardando");
          UsuarioFirebase.atualizarDadosLocalizacao(widget.idRequisicao, position.latitude, position.longitude);
        }else{
          if(position != null){
            print("position diferente de null com request Aguardando");
            setState(() {
              _localMotorista = position;
            });
          }
        }

      }else{
        print("position diferente de null SEM request Aguardando");
        if(position != null){
          setState(() {
            _localMotorista = position;
          });
        }
      }
/*
      _exibirMarcadorPassageiro(position);
      _myLocation =  CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19,
      );
*/
      // _moveCamera(_myLocation);
   /*   setState(() {
        _localMotorista = position;
      });*/

      _adicionarListenerRequisicao();
    }).canceledBy(this);

  }

  _exibirMarcadorPassageiro(Position local) async {

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: pixelRatio,
        ),
        "assets/car-marker-map.png"
    ).then((BitmapDescriptor icon) {

      try {
        Marker marcadorPassageiro = Marker(
            markerId: MarkerId("marcador-motorista"),
            position: LatLng(local.latitude, local.longitude),
            infoWindow: InfoWindow(
                title: "Meu local"
            ),
            icon: icon
        );

        setState(() {
          _marcadores.add(marcadorPassageiro);
        });
      }catch(error){
        print(error);
      }

    });


  }

  _recuperarRequisicao() async {
    await Firebase.initializeApp();
    String idRequisicao = widget.idRequisicao;
    if(idRequisicao == null){
      Navigator.pop(context);
      return;
    }

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await db.collection("requisicoes")
    .doc(idRequisicao)
    .get();

    _dadosRequisicao = documentSnapshot.data();
    // _adicionarListenerRequisicao();
  }

  _adicionarListenerRequisicao() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    // String idRequisicao = _dadosRequisicao['id'];
    String idRequisicao = widget.idRequisicao;
    await db.collection("requisicoes")
    .doc(idRequisicao)
    .snapshots()
    .listen((snapshot) {
      if(snapshot.data() != null){

        _dadosRequisicao = snapshot.data();

        Map<String, dynamic> dados = snapshot.data();
        _statusRequisicao = dados["status"];

        switch(_statusRequisicao){
          case StatusRequisicao.AGUARDANDO:
            _statusAguardando();
            break;
          case StatusRequisicao.A_CAMINHO:
            _statusACaminho();
            break;
          case StatusRequisicao.VIAGEM:
            _statusEmViagem();
            break;
          case StatusRequisicao.FINALIZADA:
            _statusFinalizada();
            break;
          case StatusRequisicao.CONFIRMADA:
            _statusConfirmada();
            break;
        }

      }
    }).canceledBy(this);
  }

  _alterarBotaoPrincipal(String texto, Color cor, Function funcao){
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _funcaoBotao = funcao;
    });
  }

  _statusAguardando() async {
    _mensagemStatus = "Iniciar";
    _alterarBotaoPrincipal("Aceitar corrida", Color(0xffe51b23), () => _aceitarCorrida());

    if(_localMotorista != null) {
      double motoristaLat = _localMotorista.latitude;
      double motoristaLon = _localMotorista.longitude;
      Position position = Position(
          latitude: motoristaLat,
          longitude: motoristaLon
      );
      _exibirMarcadorPersonalizado(
          LatLng(position.latitude, position.longitude),
          "assets/car-marker-map.png",
          "marcador-motorista",
          tituloMarcador: "Motorista"
      );


      setState(() {
        CameraPosition _myLocation = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19,
        );
        _moveCamera(_myLocation);
        if (_myLocation != null) {
          _isLoadingLocation = true;
        }
      });
    }else{
      print("Sem local motorista definido");
    }
  }


  _statusACaminho() async {
    _mensagemStatus = "Em rota com o passageiro";
    if(_chegouNoPassageiro){
      _alterarBotaoPrincipal("Iniciar corrida", Color(0xffe51b23), () => _iniciarCorrida());
    }else {
      if (
      ((_dadosRequisicao["passageiro"]["latitude"]).toStringAsFixed(3) ==
          (_dadosRequisicao["motorista"]["latitude"]).toStringAsFixed(3))
          &&
          ((_dadosRequisicao["passageiro"]["longitude"]).toStringAsFixed(3) ==
              (_dadosRequisicao["motorista"]["longitude"]).toStringAsFixed(3))
      ) {
        _alterarBotaoPrincipal("Iniciar corrida", Color(0xffe51b23), () => _iniciarCorrida());
        setState(() {
          _chegouNoPassageiro = true;
        });
      } else {
        _alterarBotaoPrincipal("A caminho do passageiro", Colors.grey, () => null);
      }
    }

    double latitudePassageiro = _dadosRequisicao["passageiro"]["latitude"];
    double longitudePassageiro = _dadosRequisicao["passageiro"]["longitude"];

    double latitudeMotorista = _dadosRequisicao["motorista"]["latitude"];
    double longitudeMotorista = _dadosRequisicao["motorista"]["longitude"];

    if(_inRouteWithPassasger == 0) {
      _criarCaminhoRota(PointLatLng(latitudeMotorista, longitudeMotorista), PointLatLng(latitudePassageiro, longitudePassageiro),);
      setState(() {
        _inRouteWithPassasger = 1;
      });
    }


    _exibirDoisMarcadores(
      LatLng(latitudeMotorista, longitudeMotorista),
      LatLng(latitudePassageiro, longitudePassageiro),
    );

    var nLat, nLon, sLat, sLon;
    if(latitudeMotorista <= latitudePassageiro) {
      sLat = latitudeMotorista;
      nLat = latitudePassageiro;
    }else{
      sLat = latitudePassageiro;
      nLat = latitudeMotorista;
    }

    if(longitudeMotorista <= longitudePassageiro) {
      sLon = longitudeMotorista;
      nLon = longitudePassageiro;
    }else{
      sLon = longitudePassageiro;
      nLon = longitudeMotorista;
    }

    _moveCameraBounds(
      LatLngBounds(
          northeast: LatLng(nLat, nLon),
          southwest: LatLng(sLat, sLon)
      ),
    );
  }

  _finalizarCorrida() async {
      await Firebase.initializeApp();
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("requisicoes")
      .doc(_dadosRequisicao["id"])
      .update({
        "status":StatusRequisicao.FINALIZADA
      }).then( (value) async {

        String idPassageiro = _dadosRequisicao["passageiro"]["idUsuario"];
        db.collection("requisicao_ativa")
        .doc(idPassageiro)
        .update({
          "status": StatusRequisicao.FINALIZADA
        });


        String idMotorista = _dadosRequisicao["motorista"]["idUsuario"];
        db.collection("requisicao_ativa_motorista")
            .doc(idMotorista)
            .update({
          "status": StatusRequisicao.FINALIZADA
        });

      });


  }

  _statusFinalizada() async {

    double latitudeDestino = _dadosRequisicao["destino"]["latitude"];
    double longitudeDestino = _dadosRequisicao["destino"]["longitude"];

    double latitudeOrigem = _dadosRequisicao["origem"]["latitude"];
    double longitudeOrigem = _dadosRequisicao["origem"]["longitude"];

    double distanciaMetros = await Geolocator.distanceBetween(
        latitudeOrigem, longitudeOrigem, latitudeDestino, longitudeDestino
    );

    double km = distanciaMetros / 1000;
    double valorViagem = km * 8;
  
    var v = new NumberFormat("#,##0.00", "pt_BR");
    var valorViagemFormat = v.format(valorViagem);
    _mensagemStatus = "Viagem finalizada";
    _alterarBotaoPrincipal("Confirmar - R\$ $valorViagemFormat", Color(0xffe51b23), () => _confirmarCorrida());


    Position position = Position(
        latitude: latitudeDestino,
        longitude: longitudeDestino
    );
    _exibirMarcadorPersonalizado(
        LatLng(position.latitude, position.longitude),
        "assets/flag-marker-map.png",
        "marcador-destino",
        tituloMarcador: "Destino"
    );


    setState(() {
      CameraPosition _myLocation = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19,
      );
      _moveCamera(_myLocation);

    });

  }

  _statusConfirmada(){
      Navigator.pushReplacementNamed(context, "/painel-motorista");
  }

  _statusEmViagem() async {

    _mensagemStatus = "Em viagem";
    _alterarBotaoPrincipal("Finalizar corrida", Color(0xffe51b23), () => _finalizarCorrida());

    double latitudeDestino = _dadosRequisicao["destino"]["latitude"];
    double longitudeDestino = _dadosRequisicao["destino"]["longitude"];

    double latitudeOrigem = _dadosRequisicao["motorista"]["latitude"];
    double longitudeOrigem = _dadosRequisicao["motorista"]["longitude"];



    if(_inRouteWithDestiny == 0) {

      _criarCaminhoRota(PointLatLng(latitudeOrigem, longitudeOrigem), PointLatLng(latitudeDestino, longitudeDestino),);
      setState(() {
        _inRouteWithDestiny = 1;
      });
    }


    _exibirDoisMarcadores(
      LatLng(latitudeOrigem, longitudeOrigem),
      LatLng(latitudeDestino, longitudeDestino),
      destinyFlag: true
    );

    var nLat, nLon, sLat, sLon;
    if(latitudeOrigem <= latitudeDestino) {
      sLat = latitudeOrigem;
      nLat = latitudeDestino;
    }else{
      sLat = latitudeDestino;
      nLat = latitudeOrigem;
    }

    if(longitudeOrigem <= longitudeDestino) {
      sLon = longitudeOrigem;
      nLon = longitudeDestino;
    }else{
      sLon = longitudeDestino;
      nLon = longitudeOrigem;
    }

    _moveCameraBounds(
      LatLngBounds(
          northeast: LatLng(nLat, nLon),
          southwest: LatLng(sLat, sLon)
      ),
    );
  }


  _exibirDoisMarcadores(LatLng latLng1, LatLng latLng2, { bool destinyFlag = false}){
    setState(() {
      _marcadores.clear();
    });
    _exibirMarcadorPersonalizado(
      latLng1,
      "assets/car-marker-map.png",
      "marcador-motorista",
      tituloMarcador: "Motorista"
    );

    String flag = "";
    if(destinyFlag){
      flag = "assets/flag-marker-map.png";
    }else{
      flag = "assets/user-marker-map.png";
    }

    _exibirMarcadorPersonalizado(
      latLng2,
      flag,
      "marcador-passageiro",
      tituloMarcador: "Passageiro"
    );

  }

  _exibirMarcadorPersonalizado(LatLng local, String assetImg, String markerId, {String tituloMarcador = ""}){

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: pixelRatio,
        ),
        assetImg
    ).then((BitmapDescriptor icon) {

      try {
        Marker marcador = Marker(
            markerId: MarkerId(markerId),
            position: LatLng(local.latitude, local.longitude),
            infoWindow: InfoWindow(
                title: tituloMarcador
            ),
            icon: icon
        );

        setState(() {
          _marcadores.add(marcador);
        });
      }catch(error){
        print(error);
      }

    });
  }

  _aceitarCorrida() async {
    await Firebase.initializeApp();

    Usuario motorista = await UsuarioFirebase.getDadosUsuarioLogado();
    motorista.latitude = _localMotorista.latitude;
    motorista.longitude = _localMotorista.longitude;
    //motorista.latitude = _dadosRequisicao["motorista"]["latitude"];
    //motorista.longitude = _dadosRequisicao["motorista"]["longitude"];
    String idRequisicao = _dadosRequisicao['id'];
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("requisicoes")
    .doc(idRequisicao)
    .update({
      "motorista": motorista.toMap(),
      "status":StatusRequisicao.A_CAMINHO
    }).then((_) {

      // atualiza requisicao ativa;
      String idPassageiro = _dadosRequisicao["passageiro"]["idUsuario"];
      db.collection("requisicao_ativa")
      .doc(idPassageiro)
      .update({
        "status": StatusRequisicao.A_CAMINHO
      });

      // salva requisicao ativa para motorista
      String idMotorista = motorista.idUsuario;
      db.collection("requisicao_ativa_motorista")
      .doc(idMotorista)
      .set({
        "id_requisicao": idRequisicao,
        "id_usuario":idMotorista,
        "status": StatusRequisicao.A_CAMINHO
      });
    });

  }


  _iniciarCorrida() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("requisicoes")
    .doc(_dadosRequisicao['id'])
    .update({
      "origem":{
        "latitude": _dadosRequisicao["motorista"]["latitude"],
        "longitude": _dadosRequisicao["motorista"]["longitude"],
      },
      "status": StatusRequisicao.VIAGEM,
    });

    String idPassageiro = _dadosRequisicao["passageiro"]["idUsuario"];
    db.collection("requisicao_ativa")
    .doc(idPassageiro)
    .update({
      "status": StatusRequisicao.VIAGEM
    });

    String idMotorista = _dadosRequisicao["motorista"]["idUsuario"];
    db.collection("requisicao_ativa_motorista")
        .doc(idMotorista)
        .update({
      "status": StatusRequisicao.VIAGEM
    });
    /*
    if(_inRouteWithPassasger == 1) {
      _criarCaminhoRota(
        PointLatLng(_dadosRequisicao["motorista"]["latitude"], _dadosRequisicao["motorista"]["longitude"]),
        PointLatLng(_dadosRequisicao["destino"]["latitude"], _dadosRequisicao["destino"]["longitude"]),
      );
      setState(() {
        _inRouteWithPassasger = 2;
      });
    }*/
  }

  _confirmarCorrida() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("requisicoes")
    .doc(_dadosRequisicao['id'])
    .update({
      "status": StatusRequisicao.CONFIRMADA,
    });

    String idPassageiro = _dadosRequisicao["passageiro"]["idUsuario"];
    db.collection("requisicao_ativa")
        .doc(idPassageiro)
        .delete();

    String idMotorista = _dadosRequisicao["motorista"]["idUsuario"];
    db.collection("requisicao_ativa_motorista")
        .doc(idMotorista)
        .delete();
  }


  _criarCaminhoRota(PointLatLng origem, PointLatLng destino) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBv4vYelnpKitu-65w_QMnRO6pk3uJ8bAw",
      origem, destino,
      travelMode: TravelMode.driving,
      optimizeWaypoints: false,
    );

    _configurarPolylines(result.points);
  }
  _configurarPolylines(List<PointLatLng> coordinates) async {

    List<LatLng> listLatLng = [];
    print(coordinates.length);
    for(int i = 0; i < coordinates.length; i++){
      LatLng latLng = LatLng(coordinates[i].latitude, coordinates[i].longitude);
      listLatLng.add(latLng);
    }

    Set<Polyline> listaPolylines = {};
    Polyline polyline = Polyline(
        polylineId: PolylineId("polyline-1"),
        color: Color(0xffe51b23),
        width: 2,
        points: listLatLng,
        startCap: Cap.squareCap, // formato do inicio da linha
        endCap: Cap.roundCap, // formato do final da linha
        jointType: JointType.round // formato das curvas do poligono
    );


    listaPolylines.add(polyline);

    setState(() {
      _polyline = listaPolylines;
    });

  }

  @override
  void initState() {
    super.initState();

    _getMyLocation();
    _streamMoveCamara();

    // _adicionarListenerRequisicao();



    // _recuperarRequisicao();
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightMap = (MediaQuery.of(context).size.height / 100) * 75;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa de trajeto - "+_mensagemStatus, style: TextStyle(color: Color(0xffe51b23)),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoadingLocation == false || _myLocation == null
            ? Center(child: CircularProgressIndicator(backgroundColor: Color(0xffe51b23),),)
            : Container(
              height: heightMap,
              child: GoogleMap(
                mapType: MapType.normal,
                mapToolbarEnabled: false,
                initialCameraPosition: _myLocation,
                onMapCreated: (GoogleMapController controller) {
                  _controllerGMC.complete(controller);
                },
                myLocationEnabled: false,
                markers: _marcadores,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(
                        () => new EagerGestureRecognizer(),
                  ),
                ].toSet(),
                myLocationButtonEnabled: false,
                polylines: _polyline,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: _funcaoBotao,
                child: Text(_textoBotao),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 60),
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  textStyle: TextStyle(fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  primary: _corBotao,
                  //primary: Color(0xffDDA4A7),
                  onPrimary: Colors.white,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

