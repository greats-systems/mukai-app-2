import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mukai/constants.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FileServiceController extends GetxController {
  var uuid = const Uuid();

  final GetStorage _getStorage = GetStorage();
  XFile? pickedXFile;
  var pickedProfileXFile = File('').obs;
  var pickedProfileXFilePath = ''.obs;
  var pickedLogoXFile = File('').obs;
  var pickedPostImage = File('').obs;
  var uploadedProfileUrl = ''.obs;
  var uploadedProfileID = ''.obs;
  var uploadedLogoID = ''.obs;
  var uploadedBannerID = ''.obs;
  var uploadedPostImageID = ''.obs;
  var uploadedBannerUrl = ''.obs;

  var pickedBannerXFile = File('').obs;
  var xServicesImageFiles = <XFile>[].obs;
  var xImageFiles = <XFile>[].obs;
  File? pickedIMageFile;
  List<File>? pickedFiles = [];
  String uploadedImageUrl = '';

  var isImageAdded = false.obs;
  var isProfileImageAdded = false.obs;
  var isLogoImageAdded = false.obs;
  var isBannerImageAdded = false.obs;
  var isSavingSuccess = false.obs;
  var isLoading = false.obs;
  var pickedProfileFile = File('').obs;
  var selectedImagePath = ''.obs;
  var supabase_url = ''.obs;
  late File file;

  @override
  void onInit() async {
    initializeDateFormatting(Intl.defaultLocale);
    super.onInit();
    await dotenv.load(fileName: ".env");
    isLoading.value = false;
    supabase_url.value = dotenv.get('ENV') == 'local'
        ? dotenv.get('LOCAL_SUPABASE_URL')
        : dotenv.get('SUPABASE_URL');
  }

  void onChangeImage(String image) {
    selectedImagePath.value = image;
  }

  pickImagesFromLocalStorage() async {
    xImageFiles.clear();
    ImagePicker imagePicker = ImagePicker();
    List<XFile> xFiles = await imagePicker.pickMultiImage(
        maxWidth: 600, maxHeight: 600, imageQuality: 10);
    if (xFiles.isNotEmpty) {
      xImageFiles.addAll(xFiles);
      selectedImagePath.value = xFiles[0].path.toString();
      update();
      debugPrint('$xFiles');
      debugPrint('xFiles Not Null ${xFiles[0].path}');
      isImageAdded.value = true;

      // await uploadFiles();
    }

    update();
  }

  pickImageFromLocalStorage(String source, String purpose) async {
    debugPrint('Image source $source');
    ImagePicker imagePicker = ImagePicker();
    if (source == 'Camera') {
      pickedXFile = await imagePicker.pickImage(source: ImageSource.camera);
    }
    if (source == 'Gallery') {
      pickedXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    }

    if (purpose == 'profile') {
      isLoading.value = true;
      debugPrint('Image purpose $purpose');
      File(pickedXFile!.path.toString());
      pickedProfileXFile.value = File(pickedXFile!.path.toString());
      pickedProfileXFilePath.value = pickedXFile!.path.toString();
      if (pickedProfileXFile.value.path != '') {
        var imageName = pickedXFile!.name;
        try {
          await uploadAvatarFile(
              pickedProfileXFile.value, imageName, ['avatar']);
          uploadedProfileUrl.refresh();
          pickedProfileXFile.refresh();
          isProfileImageAdded.refresh();
          isProfileImageAdded.value = true;
          isLoading.value = false;
        } catch (error) {
          isLoading.value = false;
          debugPrint(error.toString());
        }
        isLoading.value = false;
        isProfileImageAdded.value = true;
        pickedProfileXFile.refresh();
        isProfileImageAdded.refresh();
      }
      debugPrint('purpose == profile ${pickedProfileXFile.value}');
      isLoading.value = false;
    }

    if (purpose == 'logo') {
      isLoading.value = true;

      debugPrint('Image purpose $purpose');
      isLogoImageAdded.value = false;
      pickedLogoXFile.value = File(pickedXFile!.path.toString());
      pickedLogoXFile.refresh();
      isLoading.value = false;

      if (pickedLogoXFile.value.path != '') {
        var imageName = pickedXFile!.name;

        pickedLogoXFile.refresh();
        var res = await uploadFileToCloudStorage(
            pickedLogoXFile.value, imageName, ['logo']);
        if (res != null) {
          uploadedLogoID.value = res;
        }
        isLogoImageAdded.value = true;
        debugPrint('purpose == logo ${pickedLogoXFile.value}');
      }
      isLoading.value = false;
    }
    if (purpose == 'postImage') {
      isLoading.value = true;
      debugPrint('Image purpose $purpose');
      pickedPostImage.value = File(pickedXFile!.path.toString());
      pickedPostImage.refresh();
      isLoading.value = false;
      if (pickedPostImage.value.path != '') {
        pickedPostImage.refresh();
        isImageAdded.value = true;
        debugPrint('post image ${pickedPostImage.value}');
      }
      isLoading.value = false;
    }
    if (purpose == 'banner') {
      debugPrint('Image purpose $purpose');
      isLoading.value = true;
      pickedBannerXFile.value = File(pickedXFile!.path.toString());

      if (pickedBannerXFile.value.path != '') {
        try {
          var imageName = pickedXFile!.name;
          pickedBannerXFile.refresh();
          isBannerImageAdded.value = true;

          var res = await uploadFileToCloudStorage(
              pickedBannerXFile.value, imageName, ['banner']);
          if (res != null) {
            uploadedBannerID.value = res;
          }

          uploadedBannerUrl.refresh();
          pickedBannerXFile.refresh();
          isLoading.value = false;

          isBannerImageAdded.value = true;
          debugPrint('purpose == banner ${pickedBannerXFile.value}');
          isLoading.value = false;
        } catch (error) {
          isLoading.value = false;
        }
      }
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  pickOfferItemImagesFromLocalStorage() async {
    xImageFiles.clear();
    ImagePicker imagePicker = ImagePicker();
    List<XFile> xFiles = await imagePicker.pickMultiImage(
        maxWidth: 600, maxHeight: 600, imageQuality: 50);
    if (xFiles.isNotEmpty) {
      xImageFiles.addAll(xFiles);
      selectedImagePath.value = xFiles[0].path.toString();
      update();
      debugPrint('$xFiles');
      debugPrint('xFiles Not Null ${xFiles[0].path}');
      isImageAdded.value = true;
      // await uploadFiles();
    }

    update();
  }

  Future<String?> uploadAvatarFile(
    File imageFile,
    String? title,
    List<String>? tags,
  ) async {
    log("upload File: $imageFile");

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${CMS_ENDPOINT}/files"),
      );
      request.fields['type'] = "image/jpeg";
      if (title != null) {
        request.fields['title'] = title;
      }

      if (tags != null && tags.isNotEmpty) {
        request.fields['tags'] = jsonEncode(tags);
      }
      request.files.add(await http.MultipartFile.fromPath(
          'file', imageFile.path,
          contentType: MediaType('image', 'jpeg'), filename: title));

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = await http.Response.fromStream(response);
        final fileData = jsonDecode(responseData.body);
        log('file id ${fileData['data']['id']}');
        var fileId = fileData['data']['id'];
        uploadedProfileID.value = fileId;

        if (fileId != null) {
          final accountController = Get.put(AuthController());
          accountController.person.value.profile_image_id = fileId;
          accountController.person.refresh();
          final success = await updateUserAvatar(
            fileId,
          );

          if (success) {
            log("Avatar updated successfully!");
          } else {
            log("Failed to link avatar to the user.");
          }
        } else {
          log("Failed to upload avatar.");
        }
        return fileData['data']['id']; // Return the file ID
      } else {
        log("File upload failed. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error uploading file: $e");
      return null;
    }
  }

  Future<bool> updateUserAvatar(String fileId) async {
    try {
      var userId = await _getStorage.read('userId'); // }
      log("User userId. $userId");
      final updatedUser = await supabase.from('profiles');
      log("User avatar updated. $updatedUser");

      if (updatedUser != null) {
        log("User avatar updated successfully. $updatedUser");
        return true;
      } else {
        log("Failed to update avatar. Status code: ");
        return false;
      }
    } catch (e) {
      log("Error updating avatar: $e");
      return false;
    }
  }

  Future<String?> uploadFileToCloudStorage(
    File imageFile,
    String? title,
    List<String>? tags,
  ) async {
    log("upload File: $imageFile");

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${CMS_ENDPOINT}/files"),
      );
      request.fields['type'] = "image/jpeg";
      if (title != null) {
        request.fields['title'] = title;
      }

      if (tags != null && tags.isNotEmpty) {
        request.fields['tags'] = jsonEncode(tags);
      }

      request.files.add(await http.MultipartFile.fromPath(
          'file', imageFile.path,
          contentType: MediaType('image', 'jpeg'), filename: title));

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = await http.Response.fromStream(response);
        final fileData = jsonDecode(responseData.body);
        log('file id ${fileData['data']['id']}');
        var fileId = fileData['data']['id'];
        return fileId;
      } else {
        log("File upload failed. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error uploading file: $e");
      return null;
    }
  }
}
