import 'dart:async';

import 'package:city_trip/model/Destino.dart';
import 'package:city_trip/model/Requisicao.dart';
import 'package:city_trip/model/Usuario.dart';
import 'package:city_trip/util/StatusRequisicao.dart';
import 'package:city_trip/util/UsuarioFirebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';


class PainelPassageiro extends StatefulWidget {
  @override
  _PainelPassageiroState createState() => _PainelPassageiroState();
}

class _PainelPassageiroState extends State<PainelPassageiro> {

  TextEditingController _controllerDestino = TextEditingController(text: "Rua Auriflama, 67, Itaquaquecetuba");
  Completer<GoogleMapController> _controllerGMC = Completer();
  CameraPosition _myLocation = null;
  bool _isLoadingLocation = false;
  bool _isLoadingRequest = false;
  bool _trueConditionSearchDriver = false;
  String _idRequisicao;
  //String _darkMapStyle;
  Set<Marker> _marcadores = {};
  // Set<Marker> _centroMapa = {};
  Position _localPassageiro;

  // controles  de exibição na tela
  bool _exibirCaixaEnderecoDestino = true;
  String _textoBotao = "Chamar Motorista";
  Color _corBotao = Color(0xffe51b23);
  Function _funcaoBotao;

  Map<String, dynamic> _dadosRequisicao;
  StreamSubscription<DocumentSnapshot> _streamSubscriptionRequisicoes;


 /* List<String> itensMenu = [
      "Configurações",  "Deslogar"
  ];*/

  _getMyLocation() async {
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    Position position;
    position = await Geolocator.getLastKnownPosition();

    if(position == null){
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    }
    /*
      setState(() {
        _exibirMarcadorPassageiro(position);
        _myLocation =  CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19,
        );
        _isLoadingLocation = true;
        _localPassageiro = position;
        _moveCamera(_myLocation);
      });
  */
  }

  _moveCamera(CameraPosition cameraPosition) async {

    GoogleMapController gcm = await _controllerGMC.future;
    gcm.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition)
    );
  }

  _streamMoveCamara() async {
    Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.high,
        distanceFilter: 2
    ).listen((Position position) {

      if(_idRequisicao != null && _idRequisicao.isNotEmpty){
        // atualiza local do passageiro se ele tiver uma requisicao
        UsuarioFirebase.atualizarDadosLocalizacao(_idRequisicao, position.latitude, position.longitude);
      }else{

        setState(() {
          _localPassageiro = position;
        });
        _statusMotoristaNaoChamado();
      }
    });

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

  _deslogarUsuario() async {
    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _escolhaItemMenu(String escolha){

    switch(escolha){
      case "Deslogar":
        _deslogarUsuario();
        break;
      case "Configurações":
        break;
    }

  }

 /* Future _loadMapStyles() async {
    _darkMapStyle  = await rootBundle.loadString('assets/map_style.json');
    final controller = await _controllerGMC.future;
    controller.setMapStyle(_darkMapStyle);
  }*/

  _exibirMarcadorPassageiro(Position local) async {

    _marcadores.clear();
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: pixelRatio,
        ),
        "assets/user-marker-map.png"
    ).then((BitmapDescriptor icon) {

      try {
        Marker marcadorPassageiro = Marker(
            markerId: MarkerId("marcador-passageiro"),
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

  _chamarMotorista() async {
      String enderecoDestino = _controllerDestino.text;
      if(enderecoDestino.isNotEmpty){
        List<Location> listaEnderecos = await locationFromAddress(enderecoDestino);

        if(listaEnderecos != null && listaEnderecos.length > 0){
          Location latlang = listaEnderecos[0];

          Destino destino = Destino();
          destino.latitude = latlang.latitude;
          destino.longitude = latlang.longitude;

          List<Placemark> dadosEnderecos = await placemarkFromCoordinates(destino.latitude, destino.longitude);
          if(dadosEnderecos != null && dadosEnderecos.length > 0){
            destino.cidade = dadosEnderecos[0].subAdministrativeArea;
            destino.cep = dadosEnderecos[0].postalCode;
            destino.bairro = dadosEnderecos[0].subLocality;
            destino.rua = dadosEnderecos[0].street;
            destino.numero = dadosEnderecos[0].subThoroughfare;

            String enderecoConfirmacao;
            enderecoConfirmacao = "\nCidade: "+destino.cidade;
            enderecoConfirmacao += "\nRua: "+destino.rua;
            enderecoConfirmacao += "\nBairro: "+destino.bairro;
            enderecoConfirmacao += "\nCEP: "+destino.cep;

            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Text("Confirmação do endereço"),
                    content: Text(enderecoConfirmacao),
                    contentPadding: EdgeInsets.all(16),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancelar", style: TextStyle(color: Color(0xff000000)),),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                          ),
                      ),
                      TextButton(
                        onPressed: (){
                          _salvarRequisicao(destino);
                          Navigator.pop(context);
                        },
                        child: Text("Aceitar", style: TextStyle(color: Color(0xffe51b23)),),
                        style: ElevatedButton.styleFrom(
                          primary : Colors.transparent
                        ),
                      ),
                    ],
                  );
                }
            );

          }

        }

      }
  }

  Future _salvarRequisicao(Destino destino) async {
    await Firebase.initializeApp();

    Usuario passageiro = await UsuarioFirebase.getDadosUsuarioLogado();
    passageiro.latitude = _localPassageiro.latitude;
    passageiro.longitude = _localPassageiro.longitude;
    Requisicao requisicao = Requisicao();
    await requisicao.initGetIdRequisicao;
    requisicao.destino = destino;
    requisicao.passageiro = passageiro;
    requisicao.status = StatusRequisicao.AGUARDANDO;

    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("requisicoes").doc(requisicao.id).set(requisicao.toMap());

    Map<String, dynamic> requisicaoAtiva = {};
    requisicaoAtiva["id_requisicao"] = requisicao.id;
    requisicaoAtiva["id_usuario"] = passageiro.idUsuario;
    requisicaoAtiva["status"] = StatusRequisicao.AGUARDANDO;

    db.collection("requisicao_ativa")
    .doc(passageiro.idUsuario)
    .set(requisicaoAtiva);

    // _statusAguardando();
    if(_streamSubscriptionRequisicoes == null) {
      _adicionarListenerRequisicao(requisicao.id);
    }
  }

  _cancelarCorrida() async {
    await Firebase.initializeApp();
    User firebaseUser = await UsuarioFirebase.getUsuarioAtual();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("requisicoes")
    .doc(_idRequisicao)
    .update({
      "status":StatusRequisicao.CANCELADA
    }).then((_){
      db.collection("requisicao_ativa")
      .doc(firebaseUser.uid)
      .delete();
    });
  }


 /* _cameraMove(CameraPosition position){
    // este codigo pega a posicao central do mapa, mas deve ser usado com o mapa isolado em uma tela, pois ele aciona muitas vezes o setState
    print("Teste");
    Marker marcadorCentral = Marker(
        markerId: MarkerId("marcador-central"),
        position: LatLng(position.target.latitude, position.target.longitude),
        infoWindow: InfoWindow(
            title: "Meu local"
        ),
    );

    setState(() {
      _marcadores.clear();
      _marcadores.add(marcadorCentral);
    });
  }*/

  _alterarBotaoPrincipal(String texto, Color cor, Function funcao){
    setState(() {
      _textoBotao = texto;
      _corBotao = cor;
      _funcaoBotao = funcao;
    });
  }

  _statusMotoristaNaoChamado(){
    _exibirCaixaEnderecoDestino = true;
    _alterarBotaoPrincipal("Chamar Motorista", Color(0xffe51b23), () => _chamarMotorista());

    if(_localPassageiro != null) {
      Position position = Position(
          latitude: _localPassageiro.latitude,
          longitude: _localPassageiro.longitude
      );
      _exibirMarcadorPassageiro(position);
      _myLocation = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19,
      );
      _moveCamera(_myLocation);

      setState(() {
        _isLoadingRequest = true;
        _isLoadingLocation = true;
      });
    }else{
      print("Local do passageiro não existe - status motorista não chamado");
    }
  }

  _statusAguardando(){
    _exibirCaixaEnderecoDestino = false;
    _alterarBotaoPrincipal("Cancelar", Color(0xff000000), () => _cancelarCorrida());

   /* Position position = Position(
        latitude: _dadosRequisicao["passageiro"]["latitude"],
        longitude: _dadosRequisicao["passageiro"]["longitude"]
    );*/

    Position position = Position(
        latitude: _localPassageiro.latitude,
        longitude: _localPassageiro.longitude
    );
    _exibirMarcadorPassageiro(position);
    _myLocation =  CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 19,
    );
    _moveCamera(_myLocation);

    setState(() {
      _isLoadingRequest = true;
      _isLoadingLocation = true;
    });

  }

  _statusACaminho(){
    print("Status a caminho!");
    _exibirCaixaEnderecoDestino = false;
    _alterarBotaoPrincipal("Motorista a caminho", Colors.grey, () => null);


    double latitudePassageiro = _dadosRequisicao["passageiro"]["latitude"];
    double longitudePassageiro = _dadosRequisicao["passageiro"]["longitude"];

    double latitudeMotorista = _dadosRequisicao["motorista"]["latitude"];
    double longitudeMotorista = _dadosRequisicao["motorista"]["longitude"];

    _exibirDoisMarcadores(
      LatLng(latitudeMotorista, longitudeMotorista),
      LatLng(latitudePassageiro, longitudePassageiro),
      "Motorista",
      "Passageiro",
      "assets/car-marker-map.png",
      "assets/user-marker-map.png"
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

    _myLocation =  CameraPosition(
      target: LatLng(latitudePassageiro, longitudePassageiro),
      zoom: 19,
    );

    setState(() {
      _isLoadingRequest = true;
      _isLoadingLocation = true;
    });

  }

  _statusEmViagem(){

    _exibirCaixaEnderecoDestino = false;
    _alterarBotaoPrincipal("Em viagem", Colors.grey, () => null);


    double latitudeDestino = _dadosRequisicao["destino"]["latitude"];
    double longitudeDestino = _dadosRequisicao["destino"]["longitude"];

    double latitudeOrigem = _dadosRequisicao["motorista"]["latitude"];
    double longitudeOrigem = _dadosRequisicao["motorista"]["longitude"];

    _exibirDoisMarcadores(
      LatLng(latitudeOrigem, longitudeOrigem),
      LatLng(latitudeDestino, longitudeDestino),
      "Passageiro",
      "Destino",
      "assets/user-marker-map.png",
      "assets/flag-marker-map.png"
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

    _myLocation =  CameraPosition(
      target: LatLng(latitudeOrigem, longitudeOrigem),
      zoom: 19,
    );

    setState(() {
      _isLoadingRequest = true;
      _isLoadingLocation = true;
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

    _exibirCaixaEnderecoDestino = false;
    _alterarBotaoPrincipal("Total - R\$ $valorViagemFormat", Color(0xffe51b23), () => null);


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
    if(_streamSubscriptionRequisicoes != null){
      _streamSubscriptionRequisicoes.cancel();
      _exibirCaixaEnderecoDestino = true;
      _alterarBotaoPrincipal("Chamar Motorista", Color(0xffe51b23), () => _chamarMotorista());
      _dadosRequisicao = {};
    }
  }


  _exibirDoisMarcadores(LatLng latLng1, LatLng latLng2, String titulo1, String titulo2, String icon1, String icon2){
    setState(() {
      _marcadores.clear();
    });
    _exibirMarcadorPersonalizado(
        latLng1,
        icon1,
        "marcador-1",
        tituloMarcador: titulo1
    );
    _exibirMarcadorPersonalizado(
        latLng2,
        icon2,
        "marcador-2",
        tituloMarcador: titulo2
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

  _recuperarListenerRequisicaoAtiva() async {
    await Firebase.initializeApp();
    User firebaseUser = await UsuarioFirebase.getUsuarioAtual();
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await db.collection("requisicao_ativa")
    .doc(firebaseUser.uid)
    .get();
    if(documentSnapshot.data() != null){
      Map<String, dynamic> dados = documentSnapshot.data();

      _idRequisicao = dados["id_requisicao"];
      _adicionarListenerRequisicao(_idRequisicao);
    }else{

      _statusMotoristaNaoChamado();
    }
  }

  _adicionarListenerRequisicao(String idRequisicao) async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    _streamSubscriptionRequisicoes = await db.collection("requisicoes")
        .doc(idRequisicao)
        .snapshots().listen((snapshot) {
      if(snapshot.data() != null){

        Map<String, dynamic> dados = snapshot.data();

        _dadosRequisicao = dados;
        _idRequisicao = dados['id_requisicao'];

        switch(dados['status']){
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

      }else{
        _statusMotoristaNaoChamado();
      }

      if(_isLoadingRequest == false){
        setState(() {
          _isLoadingRequest = true;
        });
      }
    });


  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscriptionRequisicoes.cancel();
  }

  @override
  void initState() {
    super.initState();
   // _loadMapStyles();
    _recuperarListenerRequisicaoAtiva();
    // _getMyLocation();
    _streamMoveCamara();
  }

  @override
  Widget build(BuildContext context) {

    double heightMap = (MediaQuery.of(context).size.height / 100) * 75;
    double widthColumnInputsMap = (MediaQuery.of(context).size.width / 100) * 95;


    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha seu destino", style: TextStyle(color: Color(0xffe51b23)),),
       /* actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaItemMenu,
            itemBuilder: (context){

              return itensMenu.map((String item){
                return PopupMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList();

            }
          ),
        ],*/

      ),
      drawer: _exibirCaixaEnderecoDestino == false ? null : Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffe51b23), width: 5)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Image.asset("assets/logo.png", height: 120,),
                ),
              ),
            ),
            ListTile(
              title: Text('Configurações', style: TextStyle(fontSize: 18),),
              onTap: () => _escolhaItemMenu("Configurações"),
              leading: Icon(Icons.settings, color: Color(0xffe51b23),),
            ),
            ExpansionTile(
              title: Text("Categorias", style: TextStyle(fontSize: 18),),
              leading: Icon(Icons.more_outlined, color: Color(0xffe51b23),),
              children: [
                ListTile(
                  title: Text("Opção 1", style: TextStyle(fontSize: 14),),
                  onTap: (){},
                ),
                ListTile(
                  title: Text("Opção 2", style: TextStyle(fontSize: 14),),
                  onTap: (){},
                ),
              ],
            ),
            ListTile(
              title: Text('Sair', style: TextStyle(fontSize: 18),),
              onTap: ()  => _escolhaItemMenu("Deslogar"),
              leading: Icon(Icons.logout, color: Color(0xffe51b23),),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoadingLocation == false || _isLoadingRequest == false
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: CircularProgressIndicator(backgroundColor: Color(0xffe51b23),)
                ),
              )
            : Container(
              height: heightMap,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffcccccc), width: 5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _myLocation,
                    mapToolbarEnabled: false,
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
                   /* onCameraMove: (lastPosition){
                      _cameraMove(lastPosition);
                    },*/
                  ),
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(5))
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Image.asset("assets/simple-logo.png", width: 30,),
                      ),
                    ),
                    bottom: 0,
                    left: 0,
                  ),
                  Visibility(
                      visible: _exibirCaixaEnderecoDestino,
                      child: Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(padding: EdgeInsets.only(top: 15)),
                            Container(
                              width: widthColumnInputsMap,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffaaaaaa), width: 1),
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white
                              ),
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.location_on_outlined, color: Color(0xffe51b23), size: 24,),
                                    ),
                                    hintText: "Meu Local",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 0, top: 10, right: 15, bottom: 10)
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 5)),
                            Container(
                              width: widthColumnInputsMap,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffaaaaaa), width: 1),
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.local_taxi_outlined, color: Color(0xffe51b23), size: 24,),
                                    ),
                                    hintText: "Digite o destino",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 0, top: 10, right: 15, bottom: 10)
                                ),
                                controller: _controllerDestino,
                              ),
                            )
                          ],
                        ),
                      ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
               /* onPressed: _trueConditionSearchDriver
                   ?(){
                    _trueConditionSearchDriver = !_trueConditionSearchDriver;
                  }
                  : null,*/
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
      ),
    );
  }
}
