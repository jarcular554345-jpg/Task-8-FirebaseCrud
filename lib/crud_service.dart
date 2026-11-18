import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String? id;
  String name;
  int quantity;
  bool isFavorite;

  Item({this.id, required this.name, required this.quantity, this.isFavorite = false});

  // Convert Firestore document to Item object
  factory Item.fromMap(Map<String, dynamic> map, String id) {
    return Item(
      id: id,
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  // Convert Item object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'isFavorite': isFavorite,
    };
  }
}

class CrudService {
  final CollectionReference _itemsRef = FirebaseFirestore.instance.collection('items');

  // READ: Stream of items
  Stream<List<Item>> getItems() {
    return _itemsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Item.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  // CREATE: Add item
  Future<void> addItem(String name, int quantity) {
    return _itemsRef.add({
      'name': name,
      'quantity': quantity,
      'isFavorite': false,
    });
  }

  // UPDATE: Edit Name and Quantity (Added for the Edit Dialog)
  Future<void> updateItem(String id, String name, int quantity) {
    return _itemsRef.doc(id).update({
      'name': name,
      'quantity': quantity,
    });
  }

  // UPDATE: Toggle favorite status
  Future<void> toggleFavorite(Item item) {
    return _itemsRef.doc(item.id).update({'isFavorite': !item.isFavorite});
  }

  // DELETE: Delete item
  Future<void> deleteItem(String id) {
    return _itemsRef.doc(id).delete();
  }
}