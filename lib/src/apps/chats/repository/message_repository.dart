// import 'package:beetrootapp/main.dart';
// import 'package:beetrootapp/src/features/chats/schema/message.dart';
// import 'package:beetrootapp/src/app_bindings/provider/adapter.dart';

// import 'package:flutter/foundation.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:isar/isar.dart';

// class MessageRepository extends Adapter<Message> {
//   final GetStorage _getStorage = GetStorage();

//   Future<void> clearAllObjects() async {
//     List<int> ids = [];
//     for (var doc in await getAllObjects()) {
//       ids.add(doc.isarId);
//     }
//     await isar.writeTxn(() async {
//       await isar.messages.deleteAll(ids);
//     });
//     _getStorage.remove('sale_order_isarId');
//     debugPrint('cleared All Message Objects');
//   }

//   @override
//   Future<void> createObject(Message collection) async {
//     log('coll ${collection.toJson()}');
//     await isar.writeTxn(() async {
//       isar.messages.put(collection);
//     });
//   }

//   @override
//   Future<void> createMultipleObjects(List<Message> collection) async {
//     await isar.writeTxn(() async {
//       await isar.messages.putAll(collection);
//     });
//   }

//   @override
//   Future<void> deleteMultipleObject(List<int> ids) async {
//     await isar.messages.deleteAll(ids);
//   }

//   @override
//   Future<void> deleteObject(Message collection) async {
//     await isar.writeTxn(() async {
//       await isar.messages.delete(collection.isarId!);
//     });
//   }

//   @override
//   Future<List<Message>> getAllObjects() async {
//     return isar.messages.where().findAll();
//   }

//   Future<List<Message>> getAllMarketplaceMessagesObjects(
//       String trading_platforms) async {
//     return await isar.messages.where().findAll();
//   }

//   Future<Message?> getObjectByDBId(String id) {
//     return isar.messages.where().filter().idEqualTo(id).findFirst();
//   }

//   @override
//   Future<Message?> getObjectById(int id) {
//     return isar.messages.get(id);
//   }

//   @override
//   Future<void> getObjectsById(List<int> ids) {
//     return isar.messages.getAll(ids);
//   }

//   @override
//   Future<void> updateObject(Message collection) async {
//     await isar.writeTxn(() async {
//       await isar.messages.put(collection);
//     });
//   }
// }
