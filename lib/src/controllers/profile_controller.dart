import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/apps/groups/views/screens/group_members.dart';
import 'package:mukai/src/controllers/main.controller.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:developer';

class ProfileController extends MainController {
  ProfileController();

  var profile = Profile(full_name: '', id: '').obs;
  var profiles = <Profile>[].obs;
  var queriedProfiles = <Profile>[].obs;
  var selectedProfiles = <Profile>[].obs;
  var selectedProfile = Profile(email: '', id: '', full_name: '').obs;
  var filteredProfiles = <Profile>[].obs;
  XFile? pickedXFile;
  var profilePic;
  var pickedProfileXFile = ''.obs;
  var pickedProfileXFilePath = ''.obs;
  var uploadedProfileUrl = ''.obs;
  var isProfileImageUploading = false.obs;
  var isImageAdded = false.obs;
  var isProfileImageAdded = false.obs;
  var full_name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var isLoading = false.obs;
  var accountType = ''.obs;

  final GetStorage _getStorage = GetStorage();

  AuthController get authController => Get.put(AuthController());
  final dio = Dio();

  Future<Map<String, dynamic>?> getUserDetails(String id) async {
    try {
      final profileJson = await dio.get('$APP_API_ENDPOINT/auth/profiles/$id');
      /*
      final profileJson =
          await supabase.from('profiles').select().eq('id', id).single();
          */
      log('getUserDetails profileJson: $profileJson');
      return profileJson.data;
    } catch (error) {
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'Profiles Error', message: error.toString(), duration: 5);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getWalletDetails(String id) async {
    try {
      final profileJson = await supabase
          .from('wallets')
          .select()
          .eq('profile_id', id)
          // .eq('is_group_account', false)
          .single();
      return profileJson;
    } catch (error) {
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'Error', message: error.toString(), duration: 5);
      return null;
    }
  }

  Future<List<dynamic>?> getProfileWallet(String id) async {
    List<dynamic>? profileWallet = [];
    log('getProfileWallets profile_id: $id');
    try {
      final walletJson = await dio.get('$APP_API_ENDPOINT/wallets/$id');
      log('getProfileWallets walletJson: ${JsonEncoder.withIndent(' ').convert(walletJson.data['data'])}');
      if (walletJson.data.isNotEmpty) {
        final json = [walletJson.data['data'][0]];
        profileWallet= json.map((item) => item).toList();
        /*
      final profileJson =
          await supabase.from('wallets').select().eq('profile_id', id);
          */
        // profileWallets = json.map((item) => item).toList();
        // return profileWallets;
        // log(json);
      }
      return profileWallet;
    } catch (error) {
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'GetProfileWallet Error',
          message: error.toString(),
          duration: 10);
      return null;
    }
  }

  Future<List<dynamic>?> getProfileWallets(String id) async {
    List<dynamic>? profileWallets = [];
    log('getProfileWallets profile_id: $id');
    try {
      final profileJson =
          await dio.get('$APP_API_ENDPOINT/wallets/$id');
      log('getProfileWallets profileJson: ${JsonEncoder.withIndent(' ').convert(profileJson.data['data'])}');
      if (profileJson.data.isNotEmpty) {
        final json = profileJson.data['data'];
        /*
      final profileJson =
          await supabase.from('wallets').select().eq('profile_id', id);
          */
        profileWallets = json.map((item) => item).toList();
        return profileWallets;
      }
      return null;
    } catch (error) {
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'GetProfileWallets Error',
          message: error.toString(),
          duration: 10);
      return null;
    }
  }

  /*
  Future<List<Map<String, dynamic>>?> getProfileWallets(String id) async {
    List<Map<String, dynamic>> profileWallets = [];
    log('getProfileWallets profile_id: $id');
    try {
      final profileJson = await dio.get('$APP_API_ENDPOINT/wallets/$id');
      log('getProfileWallets profileJson: ${JsonEncoder.withIndent(' ').convert(profileJson.data['data'])}');
      final json = profileJson.data['data'];
      /*
      final profileJson =
          await supabase.from('wallets').select().eq('profile_id', id);
          */
      profileWallets = json.map((item) => item).toList();
      return profileWallets;
    } catch (error) {
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'GetProfileWallets Error',
          message: error.toString(),
          duration: 5);
      return null;
    }
  }
  */

  Future<void> updateUser() async {
    try {
      isLoading.value = true;
      await supabase.from('profiles').update({
        'first_name': profile.value.first_name,
        'last_name': profile.value.last_name,
        "phone": profile.value.phone,
        'city': profile.value.city,
        'country': profile.value.country,
        'province_state': profile.value.province_state,
      }).eq('id', profile.value.id!);
      await authController.checkAccount();
      isLoading.value = false;
      Helper.successSnackBar(
          title: 'Success', message: 'User account updated', duration: 5);
    } catch (error) {
      debugPrint('updateUser error $error');
      if (error is PostgrestException) {
        debugPrint('PostgrestException ${error.message}');
        Helper.errorSnackBar(
            title: 'Error', message: error.message, duration: 5);
      }
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'Error',
          message: 'Something went wrong on updateUser',
          duration: 5);
    }
  }

  Future<List<Profile>?> getProfiles() async {
    List<Profile> profiles = [];
    try {
      isLoading.value = true;
      await supabase.from('profiles').select('*').then((value) async {
        List<Map<String, dynamic>> json = value;
        if (value != '') {
          profiles = json.map((item) => Profile.fromMap(item)).toList();
        }
        isLoading.value = false;
        return profiles;
      }).catchError((error) {
        isLoading.value = false;
        if (error is PostgrestException) {
          debugPrint('PostgrestException ${error.message}');
          Helper.errorSnackBar(
              title: 'Error', message: error.message, duration: 5);
        }
        return profiles;
      });
      return profiles;
    } catch (error) {
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'Error', message: 'Something went wrong', duration: 5);
      return profiles;
    }
  }

  Future<Map<String, dynamic>?> getAcceptedMemberProfileByID(String id) async {
    // Profile? profile;
    try {
      isLoading.value = true;
      final memberIdJson = await supabase
          .from('cooperative_member_requests')
          .select('member_id')
          .eq('id', id)
          .single();
      final String profile_id = memberIdJson['member_id'];
      log(profile_id);
      final profileJson = await supabase
          .from('profiles')
          .select()
          .eq('id', profile_id)
          .single();
      return profileJson;
    } catch (error) {
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'Error', message: 'Something went wrong', duration: 5);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMemberProfileByID(String id) async {
    // Profile? profile;
    try {
      isLoading.value = true;
      final profileJson =
          await supabase.from('profiles').select().eq('id', id).single();
      return profileJson;
    } catch (error) {
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'Error', message: 'Something went wrong', duration: 5);
      return null;
    }
  }

  Future<List<Profile>?> filterProfiles(String query) async {
    List<Profile> profiles = [];
    try {
      isLoading.value = true;
      await supabase
          .from('profiles')
          .select('*')
          .textSearch('first_name', query,
              type: TextSearchType.plain, config: 'english')
          .then((value) async {
        List<Map<String, dynamic>> json = value;
        if (value != '') {
          profiles = json.map((item) => Profile.fromMap(item)).toList();
        }
        isLoading.value = false;
        return profiles;
      }).catchError((error) {
        isLoading.value = false;
        if (error is PostgrestException) {
          debugPrint('PostgrestException ${error.message}');
          Helper.errorSnackBar(
              title: 'Error', message: error.message, duration: 5);
        }
        return profiles;
      });
      return profiles;
    } catch (error) {
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'Error', message: 'Something went wrong', duration: 5);
      return profiles;
    }
  }

  Future<Profile?> updateProfile(Profile user) async {
    try {
      isLoading.value = true;
      if (_getStorage.read('userId') != null) {
        var userId = _getStorage.read('userId');
        user.id = userId;
        await supabase
            .from('profiles')
            .update({})
            .eq('id', userId)
            .then((value) async {
              if (value != '') {
                profile.value = Profile.fromMap(value as Map<String, dynamic>);
                log("updated user ${profile.value.toMap()}");
                await _getStorage.write('full_name', profile.value.full_name);
              }
              isLoading.value = false;

              return profile;
            })
            .catchError((error) {
              isLoading.value = false;

              if (error is PostgrestException) {
                debugPrint('PostgrestException ${error.message}');
                Helper.errorSnackBar(
                    title: 'Error', message: error.message, duration: 5);
              }
              return error;
            });
      }
    } catch (error) {
      isLoading.value = false;

      Helper.errorSnackBar(
          title: 'Error', message: 'Something went wrong', duration: 5);
    }
    return null;
  }

  Future<Profile?> updateMemberRequest(String? request_id, status) async {
    log('updateMemberRequest request_id: $request_id');
    if (request_id != null) {
      try {
        isLoading.value = true;
        final response = await supabase
            .from('cooperative_member_requests')
            .update({'status': status}).eq('member_id', request_id);
        log(response);
        final insertGroupMemberResponse =
            await supabase.from('group_members').insert({
          'cooperative_id': null,
          'member_id': request_id,
          // 'group_id': group_id,
        });
      } catch (error) {
        isLoading.value = false;
        Helper.errorSnackBar(
            title: 'Error', message: 'Something went wrong', duration: 5);
      }
      return null;
    } else {
      log('User ID is null');
      return null;
    }
  }

  Future<Profile?> getUser() async {
    try {
      log("getUser ${_getStorage.read('userId')}");

      isLoading.value = true;
      if (_getStorage.read('userId') != null) {
        String id = _getStorage.read('userId');
        log("userId  $id");
      }
    } catch (error) {
      isLoading.value = false;

      Helper.errorSnackBar(
          title: 'Error', message: 'Something went wrong', duration: 5);
    }
    return null;
  }

  getCloudImage() async {
    try {
      log("get CloudImage ");
    } catch (error) {
      log("get profile error $error");

      if (error is PostgrestException) {
        debugPrint('PostgrestException ${error.message}');
        Helper.errorSnackBar(
            title: 'Error', message: error.message, duration: 5);
      }
    }
  }

  selectProfile(String source, String profile_id) async {
    isLoading.value = true;

    debugPrint('selectProfile source $source profile_id $profile_id');

    isProfileImageUploading.value = true;
    ImagePicker imagePicker = ImagePicker();
    if (source == 'Camera') {
      pickedXFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
      );
    }
    if (source == 'Gallery') {
      pickedXFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );
    }
    if (pickedXFile!.path != '') {
      var file = File(pickedXFile!.path);
      try {
        var url = await uploadKYCFile(file);
        await supabase.from('profiles').update({
          'avatar': url,
        }).eq('id', profile_id);
        AuthController authController = Get.put(AuthController());
        await authController.getAccount();
        isLoading.value = false;
      } catch (error) {
        isLoading.value = false;
        log('Image uploading  cancelled');
        Helper.errorSnackBar(
            title: 'Error', message: 'Image uploading  cancelled', duration: 5);
      }
    } else {
      isLoading.value = false;
      Helper.errorSnackBar(
          title: 'Error', message: 'Image selection cancelled', duration: 5);
    }
  }

  Future<String?> uploadKYCFile(File file) async {
    isLoading.value = true;
    try {
      log('uploading file ${file}');
      final fileExt = file.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$fileExt';
      final filePath = 'images/$fileName';
      log('... filePath ${filePath}');
      isLoading.value = false;
      return supabase.storage.from('kycfiles').upload(filePath, file);
    } catch (e, s) {
      isLoading.value = false;
      log('uploadImages error: $e $s');
      return null;
    }
  }
}
