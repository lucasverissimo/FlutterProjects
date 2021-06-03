
import 'package:behind_lens/Model/Database/Crud.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class PostsDB{

  FirebaseAuth _auth;
  List documentId;

  _initPostsDB() async {
      await Firebase.initializeApp();
      this._auth = FirebaseAuth.instance;
  }

  Future<String> addNewPost(Map<String, dynamic> infoPost) async {
    await _initPostsDB();

    Crud crud = Crud();
    
    if(this._auth.currentUser.uid != null){
      print("Cadastrou!");
      await crud.insertSimpleCollection(
          'users',
          this._auth.currentUser.uid,
          infoPost,
          compostCollection: true,
          compostCollectionName: 'posts',
          userAddPost: true,
      );
      this.documentId = crud.newDocumentID;
      return "ok";
    }else{
      return "Necessario realizar novo login!";
    }
  }

}