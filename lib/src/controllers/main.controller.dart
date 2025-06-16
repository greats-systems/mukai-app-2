import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

class MainController extends GetxController {
  late String serverUrl;
  late String apiUrl;
  var uuid = const Uuid();

  /// Loads when app Launch from main.dart
  @override
  onInit() async {
    super.onInit();
    await dotenv.load();
    // serverUrl = dotenv.get("ENV") == 'production'
    //     ? dotenv.get("PRODUCTION_API")
    //     : dotenv.get("ENV") == 'staging'
    //         ? dotenv.get("STAGING_API")
    //         : dotenv.get("LOCAL_API");
    // apiUrl = dotenv.get("ENV") == 'production'
    //     ? "https://$serverUrl"
    //     : dotenv.get("ENV") == 'staging'
    //         ? "http://${dotenv.get('STAGING_API')}:${dotenv.get('SERVICES_API_PORT')}"
    //         : 'http://$serverUrl:${dotenv.get("SERVICES_API_PORT")}';
    update();
  }
}
