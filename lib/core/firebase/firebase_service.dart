import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo_app/firebase_options.dart';

class FirebaseService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  //Ajouter les autres service (store,...)
  //final _firebaseStorage = FirebaseStorage.instance;
 
  static Future<FirebaseService> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return FirebaseService();
  }
 
  FirebaseAuth getAuth() {
    return _firebaseAuth;
  }
 
  FirebaseFirestore getFireStore() {
    return _firestore;
  }
}