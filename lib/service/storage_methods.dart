import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageServices {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> uploadImagesInStorage(
      {required String childName,
      required Uint8List file,
      required bool isPost}) async {
    //storage has an file structure how we want to save the images in folders
    //to make folders and all that stuf we have ref in storage.
    //this ref provides us folder structure
    //first child is main folder name another child is for subfolder in that
    Reference ref = storage.ref().child(childName).child(auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    //now we want to add images in that folders so we do like as we do below
    UploadTask uploadTask = ref.putData(file);

    //tasksnapshot gives us info about task is it complete or ongoing
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
