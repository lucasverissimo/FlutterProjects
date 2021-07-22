import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx_aula_01/ControllersMobX/controllerbasetelalogin.dart';
import 'package:mobx_aula_01/ControllersMobX/controllerlistasobservaveis.dart';
import 'package:mobx_aula_01/ControllersMobX/item_lista_controller.dart';
import 'package:provider/provider.dart';

class ListasObservaveis extends StatefulWidget {
  const ListasObservaveis({Key? key}) : super(key: key);

  @override
  _ListasObservaveisState createState() => _ListasObservaveisState();
}

class _ListasObservaveisState extends State<ListasObservaveis> {

  ControllerListasObservaveis _controllerListasObservaveis = ControllerListasObservaveis();
  
  _dialog(){
    showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: Text("Adicionar item"),
            content: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Digite uma descrição..."
              ),
              onChanged: _controllerListasObservaveis.setNovoItem,
            ),
            actions: [
              TextButton(
                  onPressed: (){ Navigator.pop(context); },
                  child: Text("Cancelar", style: TextStyle(
                      color: Colors.red
                  ),)
              ),
              TextButton(
                  onPressed: () {
                    _controllerListasObservaveis.adicionarItem();
                    _controllerListasObservaveis.setNovoItem('');
                    Navigator.pop(context);
                  },
                  child: Text("Salvar")
              )
            ],
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    
    final controller = Provider.of<ControllerTelaLogin>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${controller.email}",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      body: Observer(
        builder: (_){
          return ListView.builder(
            itemCount: _controllerListasObservaveis.listaItens.length,
            itemBuilder: (_, indice){

              ItemListaController item = _controllerListasObservaveis.listaItens[indice];
              return Observer(
                  builder: (_) {
                    return ListTile(
                      title: Text(
                        item.titulo,
                        style: TextStyle(
                            decoration: item.marcado ? TextDecoration.lineThrough : null
                        ),
                      ),
                      leading: Checkbox(
                        value: item.marcado,
                        onChanged: (value){
                          item.alterarMarcado(value!);
                        },
                      ),
                      onTap: (){
                        item.marcado = !item.marcado;
                      },
                    );
                  }
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          _dialog();
        },
      ),
    );
  }
}
