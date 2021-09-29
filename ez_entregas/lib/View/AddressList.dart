// lista de endereços cadastrados
import 'package:ez_entregas/Components/AppBarDefault.dart';
import 'package:ez_entregas/Components/DefaultInputTextField.dart';
import 'package:ez_entregas/Model/AddressModel.dart';
import 'package:flutter/material.dart';

class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {


  List<Map<String, dynamic>> _addressList = [];

  List<String> _itensMenu = ["Editar", "Excluir"];

  Future<dynamic> _SelectedPopupMenu(String item, BuildContext bc){
    print(item);

    AddressModel _address = AddressModel();

    return showDialog(
        barrierDismissible: true,
        context: bc,
        builder: (context) => AlertDialog(
          title: Text("Editar endereço"),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(bc).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 4,
                        child: textField(_address.cCep, "CEP:", keyboardType: TextInputType.number),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 4,
                        child: textField(_address.cNum, "Número:"),
                      ),
                    ],
                  ),
                  textField(_address.cStreet, "Rua:", readOnly: true),
                  textField(_address.cNeigh, "Bairro:", readOnly: true),
                  textField(_address.cCity, "Cidade:", readOnly: true),
                  textField(_address.cComp, "Complemento:"),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancelar", style: TextStyle(color: Color(0xfff76636)),)
            ),
            TextButton(
                onPressed: (){
                  print("Salvar");
                  Navigator.pop(context);
                },
                child: Text("Salvar alterações", style: TextStyle(color: Color(0xff40cf43)),)
            ),
          ],
        ),
    );
  }

  @override
  void initState() {
    super.initState();

    List<Map<String, dynamic>> address = [];
    for(int i = 0; i < 5; i++){
      address.add({
        'logradouro':'Rua Castroville',
        'numero':'115',
        'bairro':'Jardim California',
        'cidade':'Itaquaquecetuba',
        'cep':'08584-260',
        'complemento':'Ap. 27',
        'padrao': i == 0,
      });
    }

    setState(() {
      _addressList = address;
    });

    print(_addressList);
  }

  @override
  Widget build(BuildContext context) {

    BuildContext bc = context;

    return Scaffold(
      appBar: appBarDefault("Endereços cadastrados"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Text(
                    "Sua lista de",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff666666)),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Endereços",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xff000000)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _addressList.length,
                itemBuilder: (context, index){
                  Map<String, dynamic> address = _addressList[index];
                  return ListTile(
                    title: Text(address['logradouro']),
                    subtitle: Text(address['cidade']+', '+address['cep']),
                    leading: address['padrao'] == true ? Icon(Icons.where_to_vote, color: Color(0xff40cf43),): Icon(Icons.location_on_rounded, color: Color(0xffdddddd)),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String item){
                        _SelectedPopupMenu(item, bc);
                      },
                      color: Color(0xffffffff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                            width: 2,
                            color: Color(0xffcccccc)
                        ),
                      ),
                      child: Icon(Icons.more_vert, color: Color(0xff888888),),
                      itemBuilder: (context){
                        return _itensMenu.map((String item){
                          if(address['padrao'] == true && item == 'Excluir'){
                            return null;
                          }else{
                            return PopupMenuItem<String>(
                              value: item,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  item == "Excluir"
                                      ? Icons.delete_outlined
                                      : Icons.edit_rounded,
                                  color: item == 'Excluir' ? Color(0xfff76636) : Color(0xff40cf43),
                                ),
                                label: Text(item, style: TextStyle(color: Colors.black, fontSize: 14),),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(0)),
                                ),
                              ),
                            );
                          }

                        }).toList();
                      },

                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
