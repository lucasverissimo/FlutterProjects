
class Usuario{
  String _idUsuario;
  String _nome;
  String _email;
  String _senha;
  String _tipoUsuario;
  double _latitude;
  double _longitude;

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  Usuario();


  String verificaTipoUsuario(bool tipoUsuario){
    return tipoUsuario ? "motorista" : "passageiro";
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {};

    if(this._idUsuario != null){
      map['idUsuario'] = this._idUsuario;
    }
    if(this._nome != null){
      map['nome'] = this._nome;
    }
    if(this._email != null){
      map['email'] = this._email;
    }
    if(this._senha != null){
      map['senha'] = this._senha;
    }
    if(this._tipoUsuario != null){
      map['tipoUsuario'] = this._tipoUsuario;
    }

    if(this._latitude != null){
      map['latitude'] = this._latitude;
    }

    if(this._longitude != null){
      map['longitude'] = this._longitude;
    }

    return map;
  }


  String get tipoUsuario => _tipoUsuario;

  set tipoUsuario(String value) {
    _tipoUsuario = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }
}