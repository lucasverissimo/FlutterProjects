import 'dart:async';

import 'package:behind_lens/Model/Database/PostsDB.dart';
import 'package:behind_lens/Model/Database/UploadDB.dart';
import 'package:behind_lens/Model/Entities/Posts.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostsController{

  TaskSnapshot snapshot;
  String progressUpload = "";
  List documentId;

  Future<String> addNewPost(Posts post) async {

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    UploadDB upDb = UploadDB();

    await upDb.uploadStorage("posts", post.imageFile, imageName, profile: false,);
    Timer.periodic(new Duration(milliseconds: 100), (timer) async {

      this.progressUpload = upDb.progressUpload;
      if(upDb.progressUpload == "Upload concluido!"){

        timer.cancel();

        this.progressUpload = "Upload concluido, cadastrando...";
        this.snapshot = upDb.snapshot;
        String urlImagePost = await this.snapshot.ref.getDownloadURL();
        Map<String, dynamic> dataPost = {
          "image":urlImagePost,
          "description": post.description,
          "datePost": post.datePost
        };


        PostsDB postsDB = PostsDB();
        this.progressUpload =  await postsDB.addNewPost(dataPost);
        this.documentId = postsDB.documentId;

      }

    });

  }

}