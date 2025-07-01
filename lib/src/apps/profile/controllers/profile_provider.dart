import 'dart:developer';

import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/main.dart';
import 'package:mukai/network_service.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import 'package:mukai/constants.dart' as constants;

class ProfileProvider {
  static final ProfileProvider instance = ProfileProvider._internal();

  final NetworkService _networkService = NetworkService();

  final GetStorage _getStorage = GetStorage();

  ProfileProvider._internal() {}

  ProfileProvider() {}

  createProfile(Map map) async {
    try {
      var data = {
        'first_name': map['name'],
        'phone': map['phone'],
        'email': map['email'],
        'id': map['userId'],
        'account_type': 'admin'
      };
      log('createProfile data $data');

      await supabase.from('profiles').then((value) {
        log('createProfile success $value');

        Helper.successSnackBar(title: 'Success', message: 'post created');
      }).catchError((error) {
        log('createProfile failed $error');
        if (error is PostgrestException) {
          debugPrint('PostgrestException ${error.message}');
          Helper.errorSnackBar(title: 'Error', message: error.message);
        }
      });
    } catch (error) {
      Helper.errorSnackBar(title: 'Error', message: 'Something went wrong');
    }
  }

  getProfiles() async {
    return await supabase.from('profiles');
  }
// filterUsersByFirstLastName

  filterUsersByFirstLastName({required String id}) async {
    return await supabase.from('profiles');
  }

  getProfile({required String id}) async {
    return await supabase.from('profiles');
  }

  getAccountProfiles({required String id}) async {
    return await supabase.from('profiles');
  }

  Future<Profile> updateProfileFCM(String id, String fMCToken) async {
    final document = await supabase.from('profiles');
    return Profile.fromMap(document.data);
  }

  Future<Profile> updateProfile(Profile profile) async {
    final document = await supabase.from('profiles');

    return Profile.fromMap(document.data);
  }

  Future updateProfileAuthorId(String postId, String authorId) async {
    await supabase.from('profiles');
  }

  Future deleteProfile(String postId) async {
    await supabase.from('profiles');
  }
}
