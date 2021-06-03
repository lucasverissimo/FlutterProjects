import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Crud{

  FirebaseFirestore _db;
  List newDocumentID;
  int numberDocuments = 0;

  _initCrud() async {
    await Firebase.initializeApp();
    this._db = FirebaseFirestore.instance;
  }

  Future<String> insertSimpleCollection(
      String collectionName,
      String document,
      Map<String, dynamic>val,
      {bool compostCollection = false, bool dynamicAdd = true, String compostDocument, String compostCollectionName, bool userAddPost = false }
  ) async {
    
    await _initCrud();

    try{
      if(compostCollection == true){

        if(dynamicAdd == true){
          await _db.collection(collectionName)
              .doc(document)
              .collection(compostCollectionName)
              .add(val).then((docs){
                this.newDocumentID = [
                  document,
                  docs.id
                ];
              });
          if(userAddPost == true){
            print('chegou aqui1!');
            dynamic r = await readingCollection('users',  document: document, compostCollection: true, compostCollectionName: 'posts', onlyCount: true);
            print('chegou aqui 2!');
            Map<String, dynamic> updateUser = {
              "lastActivity": DateTime.now().toUtc(),
              'numberPosts': this.numberDocuments,
            };
            dynamic r2 = await updateSimpleCollection(collectionName, document, updateUser);
            print('chegou aqui 3!');
            return 'ok';
          }
          return "ok";
        }else{
          await _db.collection(collectionName)
              .doc(document)
              .collection(compostCollectionName)
              .doc(compostDocument)
              .set(val);
          return "ok";
        }


      }else{
        await _db.collection(collectionName)
            .doc(document)
            .set(val);
        return "ok";
      }
      
    }catch(error){
      return "Erro ao realizar cadastro - Erro: "+error.toString();
    }
      
  }

  Future<String> updateSimpleCollection(String collectionName, String document, Map<String, dynamic> map, {bool compostCollection = false, String compostCollectionName }) async{
    await _initCrud();

    print(map);
    try{
      if(compostCollection == true){
        await _db.collection(collectionName).doc(document).update(map);
        return "ok";
      }else{
        await _db.collection(collectionName).doc(document).update(map);
        return "ok";
      }
      
    }catch(error){
      return "Erro ao atualizar dados - Erro: "+error.toString();
    }
    
  }

  Future<dynamic> readingCollection(
      String collectionName,
      {String document, compostCollection = false, String compostDocument, String compostCollectionName, bool onlyCount = false, int limit = 1}
  ) async {
    await _initCrud();

    // simple collection
    if(compostCollection == false){

      if(document == null){

        List<Map> map = [];
        QuerySnapshot data = await _db.collection(collectionName).get();

        this.numberDocuments = data.docs.length;
        if(onlyCount == false) {
          for(DocumentSnapshot item in data.docs){
            map.add(item.data());
          }
          return map;
        }
      }else{

        DocumentSnapshot data = await _db.collection(collectionName).doc(document).get();
        Map<String, dynamic> map = data.data();
        map["id"] = document;
        this.numberDocuments = 1;
        if(onlyCount == false) {
          return map;
        }
      }
    }else{

      // compost collection
      if(document == null){

        return null;
      }else{

        if(compostDocument == null){

          List<Map> map = [];
          QuerySnapshot data = await _db
              .collection(collectionName)
              .doc(document)
              .collection(compostCollectionName)
              .limit(limit)
              .orderBy('datePost', descending: true)
              .get();

          this.numberDocuments = data.docs.length;

          if(onlyCount == false) {
            for (DocumentSnapshot item in data.docs) {
              Map<String, dynamic> dbItem = item.data();
              dbItem["id"] = item.id;
              map.add(dbItem);
            }
            return map;
          }

        }else{

          DocumentSnapshot data = await _db.collection(collectionName).doc(document).collection(compostCollectionName).doc(compostDocument).get();
          Map<String, dynamic> map = data.data();
          map["id"] = document;
          this.numberDocuments = 1;
          if(onlyCount == false) {
            return map;
          }

        }

      }

    }



  }


  Future<List> searchDb(String collectionName, String queryString) async {
    await _initCrud();
    QuerySnapshot result;
    List<Map> map = [];

    result = await this._db.collection(collectionName)
    //.where('name', isEqualTo: queryString)
    .where("name", isGreaterThanOrEqualTo: queryString)
    .where("name", isLessThanOrEqualTo: queryString+"\uf8ff")
    // .orderBy('name', descending: true)
    .get();

    if(result.docs.length > 0) {
      for (DocumentSnapshot item in result.docs) {
        print(item.data());
        map.add(item.data());
      }
      return map;
    }else{
      return [];
    }

  }

}