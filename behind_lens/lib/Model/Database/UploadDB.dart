import 'dart:io';

import 'package:behind_lens/Model/Database/Crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class UploadDB {

  FirebaseStorage _storage;
  Reference _root;
  String progressUpload = "";
  TaskSnapshot snapshot;
  FirebaseAuth _auth;

  _initUploadDB() async {
    await Firebase.initializeApp();
    this._storage = FirebaseStorage.instance;
    this._root = this._storage.ref();
    this._auth = FirebaseAuth.instance;
  }


  Future uploadStorage(String path, File image, String name, {bool profile = false}) async {
    await _initUploadDB();


    Reference file;
    if(profile == true){
      file = this._root.child("images").child(path).child(name+'.jpg');
    }else{
      file = this._root.child("images").child(path).child(this._auth.currentUser.uid).child(name+'.jpg');
    }

    UploadTask task = file.putFile(image);

    task.snapshotEvents.listen((TaskSnapshot storageEvent) async {

      if(storageEvent.state == TaskState.running){
        this.progressUpload = "Upload em progresso!";

      }else
      if(storageEvent.state == TaskState.success){

        this.progressUpload = "Upload concluido!";
        this.snapshot = storageEvent;
        String urlImage = await this.snapshot.ref.getDownloadURL();
        if(profile == true) {
          Crud crud = Crud();
          crud.updateSimpleCollection('users', name, {'profileImage': urlImage});
        }
      }else{
        this.progressUpload = "Erro ao fazer upload!";
      }

    });

  }


}