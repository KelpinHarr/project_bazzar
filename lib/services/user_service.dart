import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:project_bazzar/models/user_model.dart';


const String ITEM_COLLECTION_REF = "users";

// class UserService extends GetxController {
//   // static UserService get instance => Get.find();

//   final _db = FirebaseFirestore.instance;

//   Future<UserModel> getUserDetails(String name) async {
//     final snapshot = await _db.collection("users").where("name", isEqualTo: name).get();
//     final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

//     return userData;
//   }

//   Future<List<UserModel>> getAllUser() async {
//     final snapshot = await _db.collection("users").get();
//     final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();

//     return userData;
//   }
// }

class UserService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;

  UserService() {
    _usersRef =
        _firestore.collection(ITEM_COLLECTION_REF).withConverter<UserModel>(
            fromFirestore: (snapshots, _) => UserModel.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (user, _) => user.toJson());
  }

  Stream<QuerySnapshot> getUsers() {
    return _usersRef.snapshots();
  }
}