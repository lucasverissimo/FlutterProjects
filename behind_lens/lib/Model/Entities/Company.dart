

class Company{
  String _idCompany;
  String _name;
  String _photo;
  String _idUser;
  String description;


  Company(this._idCompany, this._name, this._photo, {this.description});

  String get idCompany => _idCompany;

  set idCompany(String value) {
    _idCompany = value;
  }

  String get name => _name;

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }

  set name(String value) {
    _name = value;
  }
}