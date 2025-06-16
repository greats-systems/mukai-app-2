// import 'dart:developer';
// import 'package:beetrootapp/src/app_bindings/provider/adapter.dart';

// import 'package:beetrootapp/main.dart';
// import 'package:beetrootapp/src/features/chats/schema/chat.dart';
// import 'package:beetrootapp/src/features/chats/schema/message.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:isar/isar.dart';

// class ChatRepository extends Adapter<Chat> {
//   final GetStorage _getStorage = GetStorage();

//   Future<void> clearAllObjects() async {
//     List<int> ids = [];
//     for (var doc in await getAllObjects()) {
//       ids.add(doc.isarId);
//     }
//     await isar.writeTxn(() async {
//       await isar.chats.deleteAll(ids);
//     });
//     _getStorage.remove('sale_order_isarId');
//     debugPrint('cleared All Chat Objects');
//   }

//   @override
//   Future<void> createObject(Chat collection) async {
//     await isar.writeTxn(() async {
//       isar.chats.put(collection);
//     });
//   }

//   @override
//   Future<void> createMultipleObjects(List<Chat> collection) async {
//     await isar.writeTxn(() async {
//       await isar.chats.putAll(collection);
//     });
//   }

//   @override
//   Future<void> deleteMultipleObject(List<int> ids) async {
//     await isar.chats.deleteAll(ids);
//   }

//   @override
//   Future<void> deleteObject(Chat collection) async {
//     if (collection.isarId != null) {
//       await isar.writeTxn(() async {
//         await isar.chats.delete(collection.isarId!);
//       });
//     }
//     ;
//   }

//   @override
//   Future<List<Chat>> getAllObjects() async {
//     return isar.chats.where().findAll();
//   }

//   Future<List<Chat>> getAllMarketplaceChatsObjects(
//       String trading_platforms) async {
//     return await isar.chats.where().findAll();
//   }

//   Future<Chat?> getObjectByDBId(String id) {
//     return isar.chats.where().filter().idEqualTo(id).findFirst();
//   }

//   @override
//   Future<Chat?> getObjectById(int id) {
//     return isar.chats.get(id);
//   }

//   @override
//   Future<void> getObjectsById(List<int> ids) {
//     return isar.chats.getAll(ids);
//   }

//   @override
//   Future<void> updateObject(Chat collection) async {
//     await isar.writeTxn(() async {
//       await isar.chats.put(collection);
//     });
//   }

//   Future<void> saveChatWithMessageLinks(Chat collection, Message item) async {
//     log('collection ${collection.toJson()}');
//     log('Message ${item}');
//     await isar.writeTxn(() async {
//       collection.messages.add(item);
//       collection.messages.save();
//     });
//     log('updated chat messages; ${collection.messages}');
//   }

//   Future<void> updateObjectLinks(Chat collection, Message item) async {
//     log('updateObject isarId ${collection.isarId}');
//     debugPrint('chat id ${collection.id}');
//     await isar.writeTxn(() async {
//       isar.messages.put(item);
//     });
//     await isar.writeTxn(() async {
//       final chat = await isar.chats
//           .where()
//           .filter()
//           .chatIdEqualTo(collection.chatId)
//           .findFirst();
//       ;
//       if (chat != null) {
//         chat.messages.add(item);
//         chat.messages.save();
//         // await isar.chats.put(chat);
//         log('updateObject chat; ${chat.toJson()}');
//       }
//     });
//   }
// }
