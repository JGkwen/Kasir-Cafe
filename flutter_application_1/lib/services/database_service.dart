import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_kasir/models/product.dart';

const String MENUS_COLLECTION_REF = "menus";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Koleksi referensi ke Firestore
  late final CollectionReference<menus> _menusRef;

  DatabaseService() {
    _menusRef = _firestore.collection(MENUS_COLLECTION_REF).withConverter(
      fromFirestore: (snapshots, _) {
        // Mengambil data dari Firestore dan mengonversinya menjadi objek menus
        return menus.fromFirestore(snapshots);
      },
      toFirestore: (menu, _) {
        // Mengonversi objek menus ke format Map untuk disimpan di Firestore
        return menu.toMap();
      },
    );
  }

  // Menambahkan menu baru ke Firestore
  Future<void> addMenu(menus menu) async {
    try {
      await _menusRef.add(menu);
    } catch (e) {
      print("Error adding menu: $e");
      rethrow;
    }
  }

  // Mengambil semua menu dari Firestore
  Future<List<menus>> getMenus() async {
    try {
      QuerySnapshot<menus> snapshot = await _menusRef.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error getting menus: $e");
      rethrow;
    }
  }

  // Mengambil satu menu berdasarkan ID
  Future<menus?> getMenuById(String id) async {
    try {
      DocumentSnapshot<menus> snapshot = await _menusRef.doc(id).get();
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    } catch (e) {
      print("Error getting menu by id: $e");
      rethrow;
    }
  }

  // Memperbarui menu berdasarkan ID
  Future<void> updateMenu(menus menu) async {
    try {
      await _menusRef.doc(menu.id).update(menu.toMap());
    } catch (e) {
      print("Error updating menu: $e");
      rethrow;
    }
  }

  // Menghapus menu berdasarkan ID
  Future<void> deleteMenu(String id) async {
    try {
      await _menusRef.doc(id).delete();
    } catch (e) {
      print("Error deleting menu: $e");
      rethrow;
    }
  }
}
