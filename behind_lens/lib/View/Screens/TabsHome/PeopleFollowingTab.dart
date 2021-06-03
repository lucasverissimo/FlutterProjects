import 'package:behind_lens/Controller/User/UserController.dart';
import 'package:behind_lens/Model/Entities/Users.dart';
import 'package:flutter/material.dart';
import 'package:behind_lens/View/Common/ItemListUserCommon.dart';

class PeopleFollowingTab extends StatefulWidget {
  @override
  _PeopleFollowingTabState createState() => _PeopleFollowingTabState();
}

class _PeopleFollowingTabState extends State<PeopleFollowingTab> {

  TextEditingController _controllerSearch = TextEditingController();
  String _errorReturn = '';
  String _messageReturn = 'Aqui ira aparecer os\nresultados de sua busca!';


  List<Map> _usersList = [
    /*Users("Gabrielle Aplin", "gabrielle_aplin@teste.com.br", idCompany: "Company Name", photo: "assets/user-example-image.jpg"),
    Users("Gabrielle Aplin", "gabrielle_aplin@teste.com.br", idCompany: "Company Name", photo: "assets/user-example-image.jpg"),
    Users("Gabrielle Aplin", "gabrielle_aplin@teste.com.br", idCompany: "Company Name", photo: "assets/user-example-image.jpg"),
    Users("Gabrielle Aplin", "gabrielle_aplin@teste.com.br", idCompany: "Company Name", photo: "assets/user-example-image.jpg"),
    Users("Gabrielle Aplin", "gabrielle_aplin@teste.com.br", idCompany: "Company Name", photo: "assets/user-example-image.jpg"),
    Users("Gabrielle Aplin", "gabrielle_aplin@teste.com.br", idCompany: "Company Name", photo: "assets/user-example-image.jpg"),
    Users("Gabrielle Aplin", "gabrielle_aplin@teste.com.br", idCompany: "Company Name", photo: "assets/user-example-image.jpg"),
    Users("Gabrielle Aplin", "gabrielle_aplin@teste.com.br", idCompany: "Company Name", photo: "assets/user-example-image.jpg"),
    Users("Gabrielle Aplin", "gabrielle_aplin@teste.com.br", idCompany: "Company Name", photo: "assets/user-example-image.jpg"),
    Users("Gabrielle Aplin", "gabrielle_aplin@teste.com.br", idCompany: "Company Name", photo: "assets/user-example-image.jpg"),*/
  ];

  _searchUsers() async {

    if(_controllerSearch.text.length < 3){
      setState(() {
        _errorReturn = 'Preencha o campo corretamente!';
      });
    }else{
        setState(() {
          _errorReturn = '';
          _messageReturn = 'Buscando...';
        });

        UserController userController = UserController();
        List r = await userController.searchUsers(_controllerSearch.text);

        if(r.length > 0) {
          setState(() {
            _usersList = r;
            _messageReturn = '';
          });
        }else{
          setState(() {
            _messageReturn = 'Nenhum usuario encontrado!';
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff444444),
              borderRadius: BorderRadius.circular(5)
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: TextField(
                      controller: _controllerSearch,
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                          hintText: "Digite o nome do usuário...",
                          hintStyle: TextStyle(color: Color(0xff888888)),
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          filled: true, // ativa ou desativa cor de fundo
                          fillColor: Color(0xff222222), // cor de fundo, so funciona se filled estiver true
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)),
                          //prefixIcon: IconButton(icon: Icon(Icons.camera_alt, color: Color(0xff075e54), ), onPressed: (){},)
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: (){
                    _searchUsers();
                  },
                  backgroundColor: Color(0xff222222),
                  child: Icon(
                    Icons.search_rounded,
                    color: Color(0xfffe386b),
                  ),
                  mini: true,
                ) ,
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            child: Text(
              _errorReturn,
              style: TextStyle(color: Colors.yellow, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          _usersList.length == 0
          ? Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              _messageReturn,
              style: TextStyle(
                color: Color(0xff888888),
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          )
          : Padding(
            padding: EdgeInsets.only(top: 30),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _usersList.length,
                itemBuilder: (context, index){
                  return Container();
                  return ItemListUserCommon(context, _usersList[index], "user");
                }
            ),
          ),
        ],
      ),
    );
  }
}
