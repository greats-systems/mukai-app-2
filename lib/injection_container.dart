import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/controllers/main.controller.dart';
import 'package:get/get.dart';

Future<void> init() async {
  Get.put(MainController());
  Get.put(AuthController());
  Get.put(ProfileController());
  Get.put(TransactionController());
  Get.put(AuthController());
}
