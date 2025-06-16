import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class RestApiServiceController extends GetxController {
  final getConnect = GetConnect(timeout: const Duration(seconds: 10));
  var isLoadingServerConnection = false.obs;
  var isRestServerConnected = false.obs;
  late String apiUrl;
  late String restApiUrl;
  late String kycRestApiUrl;
  late String messagingApiUrl;
  var isServerLive = false.obs;
  var isLoading = false.obs;
  var isLoaserverErrorsding = false.obs;
  var serverErrorMessage = ''.obs;
  var serverErrors = false.obs;
  late String serverUrl;

  @override
  Future<void> onInit() async {
    super.onInit();

    await dotenv.load();
    serverUrl = dotenv.get("ENV") == 'production'
        ? dotenv.get("PRODUCTION_API")
        : dotenv.get("ENV") == 'staging'
            ? dotenv.get("STAGING_API")
            : dotenv.get("LOCAL_API");
    apiUrl = dotenv.get("ENV") == 'production'
        ? serverUrl
        : dotenv.get("ENV") == 'staging'
            ? "http://${dotenv.get('STAGING_API')}:${dotenv.get('SERVICES_API_PORT')}"
            : 'http://$serverUrl:${dotenv.get("SERVICES_API_PORT")}';
    update();

    messagingApiUrl = 'http://$serverUrl:${dotenv.get("KYC_WEBSOCKETS_PORT")}';
    update();

    kycRestApiUrl = 'http://$serverUrl:${dotenv.get("KYC_RESTAPI_PORT")}';
    update();
    debugPrint('RestApiServiceController apiUrl $apiUrl');

    await _callAPiServer();
    // await getexhibitPost();
  }

  _callAPiServer() async {
    try {
      isLoadingServerConnection.value = true;
      debugPrint('_callAPiServer() $apiUrl');
      var res = await getConnect.get('$apiUrl/business/');
      debugPrint('_callAPiServer Request status: ${res.statusCode}.');
      if (res.statusCode == 200) {
        isLoading.value = false;
        isServerLive.value = true;
        isRestServerConnected.value = true;
        isServerLive.refresh();
        isRestServerConnected.refresh();
      } else {
        isRestServerConnected.value = false;
        isServerLive.value = false;
      }

      update();
      isLoadingServerConnection.value = false;
    } on Exception catch (e) {
      isLoadingServerConnection.value = false;
      isServerLive.value = false;
      serverErrors.value = true;
      serverErrorMessage.value = 'No connection to server';
      debugPrint("Server Exception:  $e");
      update();
    }
  }
}
