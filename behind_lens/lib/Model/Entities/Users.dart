

class Users{
  int _idUser;
  String _name;
  String _email;
  String photo;
  String idCompany;
  String _pass;
  String _birthDate;
  String _description;
  String _profession;

  Users(this._name, this._email, {this.idCompany, this.photo});

  int get idUser => _idUser;

  set idUser(int value) {
    _idUser = value;
  }


  String get profession => _profession;

  set profession(String value) {
    _profession = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }



  String get birthDate => _birthDate;

  set birthDate(String value) {
    _birthDate = value;
  }

  String get pass => _pass;

  set pass(String value) {
    _pass = value;
  }


  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "name": this.name,
      "email": this.email
    };
    if(this.description != null){
      if(this.description.length > 0) {
        map['description'] = this.description;
      }else{
        map['description'] = '';
      }
    }else{
      map['description'] = '';
    }

    if(this.profession != null){
      if(this.profession.length > 0) {
        map['profession'] = this.profession;
      }else{
        map['profession'] = '';
      }
    }else{
      map['profession'] = '';
    }

    if(this.birthDate != null){
      map['birthDate'] = this.birthDate;
    }
    if(this.idCompany != null){
      map['idCompany'] = this.idCompany;
    }

    return map;
  }

}