import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_bazzar/models/barang.dart';

const String ITEM_COLLECTION_REF = "items";

class ItemService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _itemsRef;

  ItemService() {
    _itemsRef =
        _firestore.collection(ITEM_COLLECTION_REF).withConverter<Barang>(
            fromFirestore: (snapshots, _) => Barang.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (barang, _) => barang.toJson());
  }

  Stream<QuerySnapshot> getItems(){
    return _itemsRef.snapshots();
  }

  void addItem(Barang barang) async {
    _itemsRef.add(barang);
  }
}
