// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:mukai/brick/models/auth.model.dart';
import 'package:mukai/brick/models/coop.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/classes/session_manager.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/firebase_api.dart';
import 'package:mukai/main.dart';
import 'package:mukai/network_service.dart';
import 'package:mukai/src/apps/auth/views/admin_register_coop.dart';
import 'package:mukai/src/apps/auth/views/login.dart';
import 'package:mukai/src/apps/auth/views/member_register_coop.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/src/routes/app_pages.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/constants/hardCodedCities.dart';
import 'package:mukai/utils/constants/hardCodedCountries.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// 1048336443350-aongaja6tp71ggdrodjau92u2o73frb4.apps.googleusercontent.com
class AuthBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class AuthController extends GetxController {
  var uuid = const Uuid();
  final dio = Dio();
  final SessionManager _sessionManager = SessionManager(GetStorage(), Dio());

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      await _sessionManager.restoreSession();
      if (await _sessionManager.isLoggedIn()) {
        // Get user data if needed
        final userId = _getStorage.read('userId');
        if (userId != null) {
          await _loadUserData(userId);
        }
      }
    } catch (e) {
      log('Auth initialization error: $e');
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final response = await dio.get(
          '${EnvConstants.APP_API_ENDPOINT}/auth/profiles/$userId',
          options: Options(
            headers: {
              'apikey': _getStorage.read('access_token'),
              'Authorization': 'Bearer ${_getStorage.read('access_token')}',
              'Content-Type': 'application/json',
            },
          ));
      // Update your profile controller with the user data
      profileController.profile.value = Profile.fromMap(response.data);
    } catch (e, s) {
      log('Failed to load user data: $e $s');
    }
  }

  ProfileController get profileController => Get.put(ProfileController());
  var isSessionLogged = true.obs;
  var initiateNewTransaction = false.obs;

  var isProfileLoaded = false.obs;
  final getConnect = GetConnect(timeout: const Duration(seconds: 30));

  final GetStorage _getStorage = GetStorage();
  final NetworkService _networkService = NetworkService();
  var filteredCooperatives = [].obs;
  var cooperative_name = ''.obs;
  var cooperative_category = 'Agricultural Cooperatives'.obs;
  var cooperative_category_options = [
    "Agricultural Cooperatives",
    "Consumer Cooperatives",
    "Worker Cooperatives",
    "Housing Cooperatives",
    "Credit Unions (Financial Cooperatives)",
    "Energy Cooperatives",
    "Healthcare Cooperatives",
    "Artisan/Craft Cooperatives",
    "Retail Cooperatives",
    "Fishing Cooperatives",
    "Transportation Cooperatives",
    "Education Cooperatives",
    "Technology Cooperatives",
    "Food Cooperatives (Food Co-ops)",
    "Producer Cooperatives",
    "Multi-stakeholder Cooperatives",
    "Platform Cooperatives",
    "Community Land Trusts",
    "Mutual Aid Networks",
    "Buying Clubs (Purchasing Cooperatives)"
  ].obs;
  var account_type = 'coop-member'.obs;
  var account_type_options = [
    'coop-member',
    'coop-manager',
  ].obs;

  var specialization = 'Warehouse/Storage Facilities'.obs;
  var specialization_options = [
    'Warehouse/Storage Facilities',
    'Transporter',
    'Trainer',
    'Consultant',
    'Financial Institution',
    'Inputs Distributor',
    'Inputs Manufacturer',
    'Machinery Distributor/Hardware',
    'Machinery Manufacturer',
    'Branding and Packaging'
  ].obs;
  late List<String> genderList = [
    'male',
    'female',
    'other',
  ];
  var selectedGender = 'male'.obs;
  var date_of_birth = DateTime(DateTime.now().year - 16).obs;
  var phoneNumber = ''.obs;
  var otp_secret = ''.obs;
  var userId = ''.obs;
  var fullName = ''.obs;
  var firstName = ''.obs;
  var phone = ''.obs;
  var lastName = ''.obs;
  var nationalIdNumber = ''.obs;
  var email = ''.obs;

  var password = ''.obs;
  var loginOption = 'email'.obs;
  var isLoading = false.obs;
  var addAuthData = false.obs;
  final count1 = 0.obs;
  final count2 = 0.obs;
  final list = [56].obs;
  final messages = [56].obs;
  var person = Profile(
    first_name: '',
    last_name: '',
    account_type: '',
    gender: '',
    profile_image_id: '',
    profile_image_url: '',
    phone: '',
    city: '', country: '',
    // location: Location(city: 'name', country: 'country', collectionId: 0),
    id: '',
    email: '', full_name: '',
  ).obs;
  var xImageFiles = <XFile>[].obs;
  var imageFiles = <File>[].obs;
  var subscription = 0.obs;

  var nIDFileUrl = ''.obs;
  var passportFileUrl = ''.obs;
  var profileImageUrl = ''.obs;
  var uploadedImageUrl = ''.obs;
  var propertyOwnershipUrl = ''.obs;

  var nIDFile = File('').obs;
  var passportFile = File('').obs;
  var propertyOwnershipFile = File('').obs;
  var profileImageFile = File('').obs;

  var landMapFile = File('').obs;
  var pickedXFile = File('').obs;

  var isImageAdded = false.obs;
  var isPDAdded = false.obs;
  var isNIDAdded = false.obs;

// Farmer Data Models
  var farm_id = ''.obs;
  var farm_size = ''.obs;
  var farm_name = ''.obs;
  var farm_arable_land = ''.obs;
  var farm_area_irrigation = ''.obs;
  var farm_geo_coordinates = ''.obs;
  var physical_address = ''.obs;
  var farm_type = 'A1'.obs;

  var farm_type_options = [
    'A1',
    'A2',
    'Communal',
    'Small Scale Commercial',
    'Large Scale Commercial',
    'Resettlement',
    'Irrigation Scheme',
    'Peri-Urban',
    'None',
  ].obs;
  var farm_ownership = 'Owned'.obs;
  var farm_ownership_options = [
    'Owned',
    'On-Rental',
    'Joint Venture',
    'Gvt Offer Letter',
    'None',
  ].obs;

  var farm_infrastructure = ['Dam'].obs;
  var farm_infrastructure_options = [
    'Dam',
    'Greenhouse',
    'Borehole',
    'Ban',
    'Warehouse',
    'Silos',
    'None',
  ].obs;

  var farm_implements = ['Tractors'].obs;
  var farm_implements_options =
      ['Tractors', 'Combine Harvesters', 'Boom Sprayers'].obs;

  var nearest_gmb_depot = ''.obs;
  var nearest_gmb_depot_options = [
    '',
    'None',
  ].obs;
  var agritex_officers = <Profile>[].obs;
  var selected_agritex_officer = Profile().obs;
  var agritex_officer_options = [
    '',
    'None',
  ].obs;

  var district = 'A1'.obs;
  var district_options = [
    'A1',
    'A2',
    'Communal',
    'Small Scale Commercial',
    'Large Scale Commercial',
    'Resettlement',
    'Irrigation Scheme',
    'Peri-Urban',
    'None',
  ].obs;

  var city = City(name: 'Harare', country: 'Zimbabwe').obs;
  var country = Country(code: 'ZW', name: 'Zimbabwe').obs;
  var province = 'Harare'.obs;
  var selected_country = 'Zimbabwe'.obs;
  var province_options = [
    "Bulawayo",
    "Harare",
    "Manicaland",
    "Mashonaland Central",
    "Mashonaland East",
    "Mashonaland West",
    "Masvingo",
    "Matabeleland North",
    "Matabeleland South",
    "Midlands"
  ];
  var selected_coop = Cooperative().obs;
  var coops_options = <Cooperative>[].obs;
  var subsOptions = [1, 5, 10, 20, 25];
  var province_options_with_districts = [
    {
      "Bulawayo": ["Bulawayo"]
    },
    {
      "Harare": ["Harare"]
    },
    {
      "Manicaland": [
        "Buhera",
        "Chimanimani",
        "Chipinge",
        "Makoni",
        "Mutare",
        "Mutasa",
        "Nyanga"
      ]
    },
    {
      "Mashonaland Central": [
        "Bindura",
        "Guruve",
        "Mazowe",
        "Mbire",
        "Mount Darwin",
        "Muzarabani",
        "Mukumbura",
        "Rushinga",
        "Shamva"
      ]
    },
    {
      "Mashonaland East": [
        "Chikomba",
        "Goromonzi",
        "Marondera",
        "Mudzi",
        "Murehwa",
        "Mutoko",
        "Seke",
        "Uzumba-Maramba-Pfungwe",
        "Wedza"
      ]
    },
    {
      "Mashonaland West": [
        "Chegutu",
        "Hurungwe",
        "Kariba",
        "Makonde",
        "Mhondoro-Ngezi",
        "Zvimba",
        "Sanyati",
        "Kadoma"
      ]
    },
    {
      "Masvingo": [
        "Bikita",
        "Chiredzi",
        "Chivi",
        "Gutu",
        "Masvingo",
        "Mwenezi",
        "Zaka"
      ]
    },
    {
      "Matabeleland North": [
        "Binga",
        "Bubi",
        "Hwange",
        "Lupane",
        "Nkayi",
        "Tsholotsho",
        "Umguza"
      ]
    },
    {
      "Matabeleland South": [
        "Beitbridge",
        "Bulilima",
        "Gwanda",
        "Insiza",
        "Mangwe",
        "Matobo",
        "Umzingwane"
      ]
    },
    {
      "Midlands": [
        "Chirumhanzu",
        "Gokwe North",
        "Gokwe South",
        "Gweru",
        "Kwekwe",
        "Mberengwa",
        "Shurugwi",
        "Zvishavane"
      ]
    }
  ].obs;
  var ward = ''.obs;
  var town_city = "Harare".obs;
  var town_city_options = [
    {
      "Bulawayo": ["Bulawayo"],
      "Harare": ["Harare", "Chitungwiza", "Epworth", "Norton"],
      "Manicaland": [
        "Mutare",
        "Chipinge",
        "Chimanimani",
        "Nyanga",
        "Rusape",
        "Buhera",
        "Hauna",
        "Penhalonga"
      ],
      "Mashonaland Central": [
        "Bindura",
        "Shamva",
        "Guruve",
        "Mount Darwin",
        "Concession",
        "Glendale",
        "Mazowe"
      ],
      "Mashonaland East": [
        "Marondera",
        "Mutoko",
        "Murehwa",
        "Wedza",
        "Chivhu",
        "Rufaro",
        "Mahusekwa"
      ],
      "Mashonaland West": [
        "Chinhoyi",
        "Kariba",
        "Chegutu",
        "Kadoma",
        "Banket",
        "Mhangura",
        "Raffingora",
        "Zvimba"
      ],
      "Masvingo": [
        "Masvingo",
        "Chiredzi",
        "Gutu",
        "Zaka",
        "Bikita",
        "Mwenezi",
        "Ngundu",
        "Rutenga"
      ],
      "Matabeleland North": [
        "Hwange",
        "Lupane",
        "Victoria Falls",
        "Binga",
        "Nkayi",
        "Tsholotsho",
        "Jotsholo"
      ],
      "Matabeleland South": [
        "Gwanda",
        "Beitbridge",
        "Plumtree",
        "Filabusi",
        "Esigodini",
        "Colleen Bawn"
      ],
      "Midlands": [
        "Gweru",
        "Kwekwe",
        "Shurugwi",
        "Zvishavane",
        "Redcliff",
        "Mberengwa",
        "Gokwe",
        "Lalapanzi"
      ]
    }
  ].obs;
  var selected_province_districts_options = ["Harare"].obs;
  var selected_country_options = ["Zimbabwe"].obs;
  var selected_country_city_options = ["Harare"].obs;
  var selected_city = "".obs;
  var selected_province = "".obs;
  var selected_province_town_city_options =
      ["Harare", "Chitungwiza", "Epworth", "Norton"].obs;
  var selected_district_ward_options =
      ["Harare", "Chitungwiza", "Epworth", "Norton"].obs;
  var selected_subs_options = [1, 5, 10, 20, 25].obs;

  /*
  @override
  onInit() {
    super.onInit();
    isLoading.value = false;
    // checkAccount().then((value) => {
    //       log(
    //         'authentication check successful',
    //       )
    //     });
  }
  */

  initialize() {
    isLoading.value = false;
  }

  updateUser() {}

  final accessToken = GetStorage().read('access_token');

  Future<List<String>> getCitiesFromCountry(String countryName) async {
    log('Fetching cities for country: $countryName');
    try {
      var headers = {'Content-Type': 'application/json'};
      // Updated endpoint to the correct one (https, and latest path)
      var request = http.Request(
        'POST',
        Uri.parse('https://countriesnow.space/api/v0.1/countries/cities'),
      );
      request.body = json.encode({"country": countryName.toLowerCase()});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        if (responseData.isEmpty) {
          log('Empty response body');
          return [];
        }
        log('Response data: $responseData');
        var jsonResponse = json.decode(responseData);
        if (jsonResponse['error'] == false && jsonResponse['data'] != null) {
          return List<String>.from(jsonResponse['data']);
        } else {
          log('API returned error: ${jsonResponse['msg']}');
        }
      } else if (response.statusCode == 301 || response.statusCode == 302) {
        log('Endpoint moved. Please check the API URL.');
      } else {
        log('Failed with status: ${response.reasonPhrase}');
      }
    } catch (e, s) {
      log('Exception occurred: $e\n$s');
    }

    return [];
  }

  Future<bool> isAccountSessionValid() async {
    try {
      log('Check is account auth session valid?');
      var sessionId = await _getStorage.read('sessionId'); // }
      if (sessionId != null) {
        log('session is valid');
        isSessionLogged.value = true;
        return isSessionLogged.value;
      } else {
        log('session is not valid');
        isSessionLogged.value = false;
        return isSessionLogged.value;
      }
    } on TimeoutException catch (e) {
      // Handle timeout exception
      log('Request timed out: $e');
      isSessionLogged.value = false;
      isLoading.value = false;
      isLoading.refresh();
      log('session is not valid');
      return isSessionLogged.value;
    } catch (error) {
      // Handle any other errors
      log('An error occurred: $error');
      log('session is not valid');
      return isSessionLogged.value;
    }
  }

  /// Setting initial screen

  Future<void> setInitialScreen(String role) async {
    try {
      final sessionStatus = await isAccountSessionValid();
      if (!sessionStatus) {
        await logout();
        return;
      }

      // await getAccount();

      // Simplified check - just verify we have a user
      if (role == 'coop-manager') {
        Get.offAll(() => const BottomBar(
              role: 'coop-manager',
            ));
      } else {
        // Get.offAll(() => MemberHomeScreen());
        throw UnimplementedError();
      }
    } catch (e) {
      log('Error in setInitialScreen: $e');
      await logout();
    }
  }

  Future<List<dynamic>?> filterCooperatives() async {
    // List<dynamic> productList = [];
    try {
      coops_options.clear();
      selected_coop.value = Cooperative();
      await supabase
          .from('cooperatives')
          .select('''id,name,category,city, province_state''')
          .match({
            'category': cooperative_category.value,
            // 'province_state': province.value,
            // 'city': town_city.value
          })
          .or('province_state.eq.${province.value},city.eq.${town_city.value}')
          .then((response) {
            log('filterByProductCategory data: $response');
            final List<dynamic> json = response;
            isLoading.value = false;
            if (json.isNotEmpty) {
              coops_options.value =
                  json.map((item) => Cooperative.fromMap(item)).toList();
              update();
            } else {
              isLoading.value = false;
              log('filterByProductCategory graph occurred: ');
            }
          });
      return filteredCooperatives;
    } catch (error) {
      log('error $error');
      isLoading.value = false;
      if (error is PostgrestException) {
        debugPrint('PostgrestException ${error.message}');
        Helper.errorSnackBar(
            title: 'Error', message: error.message, duration: 10);
      } else if (error is DioException) {
        debugPrint('DioException ${error.response}');
        Helper.errorSnackBar(
            title: 'Error', message: error.response.toString(), duration: 10);
      }
      return filteredCooperatives;
    }
  }

  Future<void> getAcountCooperatives(String userId) async {
    log('getAcountCooperatives profileID userId: $userId');
    try {
      isLoading.value = true;
      final response = await dio
          .get('${EnvConstants.APP_API_ENDPOINT}/cooperatives/$userId');
      if (response.statusCode == 200) {
        var data = response.data['data'];
        final List<dynamic> json = data;
        isLoading.value = false;
        log('getAcountCooperatives data: $json');
        if (json.isNotEmpty) {
          coops_options.value =
              json.map((item) => Cooperative.fromMap(item)).toList();
          update();
        } else {
          isLoading.value = false;
          log('No cooperatives found');
        }
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      // log('getWalletDetailsByID error: $e');
      isLoading.value = false;
      Helper.errorSnackBar(title: 'Error', message: e.toString(), duration: 10);
    }
  }

  Future<bool> getAccount() async {
    try {
      final User? user = supabase.auth.currentUser;
      if (user == null) return false;

      final user_data = await supabase
          .from('profile')
          .select('*')
          .eq('email', user.email!)
          .single();

      if (user_data.isNotEmpty) {
        person.value = Profile.fromMap(user_data);
        isProfileLoaded.value = true;
        return true;
      }
      return false;
    } catch (e) {
      log('Error in getAccount: $e');
      return false;
    }
  }

  Future<List<Profile>?> getAgritexOfficers(String district) async {
    log('======================================================');
    log('get Agritex Officers');
    log('======================================================');
    isLoading.value = true;
    agritex_officers.clear();
    final user_data = await supabase.from('profiles').select('*');
    // .match({'account_type': 'agritex_officer', 'district': district});
    if (user_data.isNotEmpty) {
      agritex_officers.value =
          user_data.map((item) => Profile.fromMap(item)).toList();
      isLoading.value = false;
      return agritex_officers;
    }
    isLoading.value = false;
    return agritex_officers;
  }

  Future<void> login() async {
    try {
      isLoading.value = true;
      var isNetworkConnected = await _networkService.isConnected();
      final response = await GetConnect().get(EnvConstants.APP_API_ENDPOINT);
      log('isNetworkConnected && response.statusCode $isNetworkConnected ${response.statusCode!}');

      if (isNetworkConnected && response.statusCode != null) {
        if (phoneNumber.isNotEmpty) {
          userId.value = uuid.v4();

          await supabase.auth
              .signInWithOtp(
                phone: phoneNumber.value,
                channel: OtpChannel.sms,
              )
              .timeout(Duration(seconds: 15));
          Get.toNamed(Routes.otp);
        }
      } else {
        isLoading.value = false;
        Get.defaultDialog(
            backgroundColor: primaryColor.withOpacity(0.9),
            title: 'Authentication',
            middleText: 'Network Connection Error, Try again later',
            textConfirm: 'OK',
            confirmTextColor: Colors.white,
            buttonColor: recColor,
            onConfirm: () {
              Get.back();
            });
      }
    } catch (error) {
      debugPrint('Login Error $error');
      if (error is PostgrestException) {
        debugPrint('PostgrestException ${error.message.toLowerCase()}');
        if (error.message.toLowerCase().contains(
            'clientException with socketException: connection failed')) {
          Get.defaultDialog(
              backgroundColor: primaryColor.withOpacity(0.9),
              title: 'Network Connection Error',
              middleText: 'Try again later',
              textConfirm: 'OK',
              confirmTextColor: Colors.white,
              buttonColor: recColor,
              onConfirm: () {
                Get.back();
              });
        } else {
          Helper.errorSnackBar(title: 'Error', message: error.message);
        }
      }
      await logout();
      isLoading.value = false;
      Get.defaultDialog(
          middleText: error.toString(),
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          });
    }
  }

  Future<void> createUser() async {
    try {
      isLoading.value = true;
      try {
        person.value.password = password.value;
        person.value.first_name = fullName.value;
        person.value.last_name = lastName.value;
        person.value.phone = phoneNumber.value;
        person.value.email = email.value;
        person.value.account_type = 'client';
        person.refresh();
        log('person ${person.value.toMap()} ');
        isLoading.value = false;
        // Get.to(() => const BuildUserModelProfileScreen());
      } catch (error) {
        isLoading.value = false;

        if (error is PostgrestException) {
          log('createdUser error ${error.message}');
          Helper.errorSnackBar(title: 'Error', message: error.message);
        } else {
          log('createdUser  error $error');
          Helper.errorSnackBar(title: 'Error', message: error);
        }
      }
    } catch (error) {
      isLoading.value = false;
      if (error is PostgrestException) {
        log('createdUser error ${error.message}');
        Helper.errorSnackBar(title: 'Error', message: error.message);
      } else {
        Helper.errorSnackBar(title: 'Error', message: error);
      }
    }
  }

  Future<String?> fetchUserId() async {
    final id = await _getStorage.read('userId');
    return id;
  }

  Future<void> signin() async {
    try {
      isLoading.value = true;
      log('Attempting login with email: ${email.value}');

      final response = await dio.post(
        '${EnvConstants.APP_API_ENDPOINT}/auth/login',
        data: {
          'email': email.value,
          'password': password.value,
        },
      ).timeout(const Duration(seconds: 30)); // Add timeout

      log('Response received: ${JsonEncoder.withIndent(' ').convert(response.data)}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Successful login response');
        final authResponse = AuthResponse.fromJson(response.data);
        if (authResponse.session == null || authResponse.user == null) {
          log('Session or user data missing in response');
          // throw Exception('Invalid authentication response');
        }

        // Save session data
        await _saveSessionData(authResponse);
        // await checkAccount();
        // Navigate based on account type
        profileController.profile.value
          ..first_name = response.data['user']['first_name']
          ..last_name = response.data['user']['last_name']
          ..phone = response.data['user']['phone']
          ..email = response.data['user']['email']
          ..account_type = response.data['user']['account_type'];
        userId.value = response.data['user']['id'];
        // await _getStorage.write('userId', response.data['user']['id']);
        // await _getStorage.write('accessToken', response.data['access_token']);
        await _getStorage.write('role', response.data['user']['account_type']);
        await _getStorage.write(
            'first_name', response.data['user']['first_name']);
        await _getStorage.write(
            'last_name', response.data['user']['last_name']);
        await _getStorage.write('phone', response.data['user']['phone']);
        await _getStorage.write('email', response.data['user']['email']);
        await _handleSuccessfulLogin();
      } else if (response.statusCode == 401) {
        _handleFailedLogin(response);
      } else {
        _handleFailedLogin(response);
      }
    } on DioException catch (e) {
      log('DioError during login: ${e}');
      isLoading.value = false;
      Helper.errorSnackBar(
        title: 'Error',
        message:
            e.response?.data['message'] ?? 'Login failed. Please try again.',
      );
    } on TimeoutException {
      log('Login timeout');
      isLoading.value = false;
      Helper.errorSnackBar(
        title: 'Timeout',
        message: 'Login request timed out. Please try again.',
      );
    } catch (error, stack) {
      log('Unexpected login error: $error $stack');
      isLoading.value = false;
      Helper.errorSnackBar(
        title: 'Error',
        message: 'An unexpected error occurred during login.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveSessionData(AuthResponse authResponse) async {
    try {
      await _sessionManager.saveSession(
        accessToken: authResponse.session!.accessToken,
        refreshToken: authResponse.session!.refreshToken!,
        userId: authResponse.user!.id,
        email: authResponse.user!.email!,
        expiresAt: DateTime.parse(authResponse.session!.expiresAt!.toString()),
      );
      await _getStorage.write(
          'refresh_token', authResponse.session!.refreshToken!);
      await _getStorage.write(
          'access_token', authResponse.session!.accessToken);
      await _getStorage.write('email', email.value);
      await _getStorage.write('password', password.value);
      await _getStorage.write('sessionId', authResponse.session!.accessToken);
      await _getStorage.write(
          'sessionExpiration', authResponse.session!.expiresAt);
      await _getStorage.write('userId', authResponse.user!.id);
      await _getStorage.write('role', authResponse.user!.role);
      log('Session data saved successfully');
    } catch (e) {
      log('Error saving session data: $e');
      throw Exception('Failed to save session data');
    }
  }

  // d475de43-c9ef-4510-9823-7b31e3fc92e0

  Future<void> _handleSuccessfulLogin() async {
    log(person.value.toString());
    try {
      // log('Handling successful login for $accountType');

      // Force navigation after successful login
      final role = await _getStorage.read('account_type');
      log('_handleSuccessfulLogin role: $role');
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Get.offAll(() => BottomBar());
      });

      // log('Navigation triggered for $accountType');
    } catch (e) {
      log('Error handling successful login: $e');
      throw Exception('Failed to handle post-login navigation');
    }
  }

  void _handleFailedLogin(Response response) {
    log('Login failed with status: ${response.statusCode}');
    isLoading.value = false;
    Helper.errorSnackBar(
      title: 'Error',
      message: response.data['message'] ??
          'Login failed. Please check your credentials.',
    );
  }

  Future<void> loginEmailnPassword() async {
    try {
      isLoading.value = true;
      if (email.value != '' && password.value != '') {
        final AuthResponse res = await supabase.auth.signInWithPassword(
          email: email.value,
          password: password.value,
        );
        final Session? session = res.session;
        log('session ${session!.toJson()}');
        if (session.accessToken.isNotEmpty) {
          await _getStorage.write('sessionId', session.accessToken);
          await _getStorage.write('sessionExpire', session.expiresIn);
          await checkAccount();
        } else {
          isLoading.value = false;
          Helper.errorSnackBar(title: 'Authentication not successful');
        }
      } else {
        isLoading.value = false;
        Get.to(() => LoginScreen());
      }
    } catch (error) {
      isLoading.value = false;
      if (error is PostgrestException) {
        if (error.code == '404') {
          Get.defaultDialog(
              backgroundColor: primaryColor.withOpacity(0.9),
              title: 'Network Connection Error',
              middleText: 'Try again later',
              textConfirm: 'OK',
              confirmTextColor: Colors.white,
              buttonColor: recColor,
              onConfirm: () {
                Get.back();
              });
        } else {
          Get.defaultDialog(
              middleText: error.toString(),
              textConfirm: 'OK',
              confirmTextColor: Colors.white,
              onConfirm: () {
                Get.back();
              });
        }
      }
      Get.defaultDialog(
          middleText: error.toString(),
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          });
    }
  }

  Future<void> verify() async {
    try {
      isLoading.value = true;
      if (otp_secret.value != '') {
        log('otp_secret.value ${otp_secret.value} $userId');
        final AuthResponse res = await supabase.auth.verifyOTP(
          type: OtpType.signup,
          token: otp_secret.value,
          phone: userId.value,
        );
        final Session? session = res.session;
        final User? user = res.user;

        if (session!.accessToken.isNotEmpty) {
          await _getStorage.write('sessionId', session.accessToken);
          await _getStorage.write('sessionExpire', session.expiresAt);
          await checkAccount();
        } else {
          Helper.errorSnackBar(title: 'Account not registered successfully');
        }
      } else {
        isLoading.value = false;
        Get.to(() => LoginScreen());
      }
    } catch (error) {
      isLoading.value = false;
      Get.defaultDialog(
          middleText: error.toString(),
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          });
    }
  }

  Future<void> verifyPhone() async {
    try {
      isLoading.value = true;
      log('wallet docs ${phoneNumber.value} ${fullName.value}');
      var isNetworkConnected = await _networkService.isConnected();
      final response = await GetConnect().get(EnvConstants.APP_API_ENDPOINT);
      if (isNetworkConnected && response.statusCode != null) {
        Map<String, dynamic> token = {};
        final AuthResponse res = await supabase.auth.verifyOTP(
          type: OtpType.signup,
          token: otp_secret.value,
          phone: phoneNumber.value,
        );
        final Session? session = res.session;
        final User? user = res.user;
        if (token['userId'] != '') {
          log('token.userId ${token['userId']}');
          await _getStorage.write('userId', token['userId']);
          final res = await supabase.auth.admin.createUser(AdminUserAttributes(
            emailConfirm: true,
            phoneConfirm: true,
            email: email.value,
            phone: phoneNumber.value,
            userMetadata: {'name': fullName.value},
          ));
          Get.toNamed(Routes.otp);
          isLoading.value = false;
        } else {
          isLoading.value = false;
          // Get.to(()=>LoginScreen());
          Helper.warningSnackBar(
              title: 'Warning', message: 'OTP Code sending failed');
        }
      } else {
        isLoading.value = false;

        Get.defaultDialog(
            backgroundColor: primaryColor.withOpacity(0.9),
            title: 'Authentication',
            middleText: 'Network Connection Error, Try again later',
            textConfirm: 'OK',
            confirmTextColor: Colors.white,
            buttonColor: recColor,
            onConfirm: () {
              Get.back();
            });
      }
    } catch (error) {
      log('$error');
      isLoading.value = false;
      Get.defaultDialog(
          middleText: error.toString(),
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          });
    }
  }

  Future<void> updateAccount(String userId) async {
    var response = await dio.put(
      '${EnvConstants.APP_API_ENDPOINT}/auth/update-account/$userId',
      data: {
        'id': userId,
        'avatar':
            profileImageUrl.value.isNotEmpty ? profileImageUrl.value : null,
        'national_id_url':
            nIDFileUrl.value.isNotEmpty ? nIDFileUrl.value : null,
        'passport_url':
            passportFileUrl.value.isNotEmpty ? passportFileUrl.value : null,
      },
      options: Options(
        validateStatus: (status) {
          return status! < 500; // Don't throw for 4xx errors
        },
      ),
    );
    log(response.toString());
  }

  Future<void> registerUser() async {
    try {
      isLoading.value = true;
      if (phoneNumber.value.isEmpty) {
        throw Exception('Phone number is required');
      }
      if (password.value.isEmpty) {
        throw Exception('Password is required');
      }
      if (firstName.value.isEmpty || lastName.value.isEmpty) {
        throw Exception('First and last name are required');
      }
      final fMCToken = await FirebaseApi.getFirebaseMessagingToken();
      var auth_data = {
        'first_name': firstName.value,
        'last_name': lastName.value,
        'email': email.value,
        'phone': phoneNumber.value,
        'account_type': account_type.value,
        'push_token': fMCToken,
        'password': password.value,
        'country': selected_country.value,
        'city': selected_city.value,
        'gender': selectedGender.value,
        'date_of_birth': date_of_birth.value.toString(),
        'national_id_number': nationalIdNumber.value,
        'national_id_url': null,
        'passport_url': null,
        'avatar': null,
      };

      // log('Auth data: ${EnvConstants.APP_API_ENDPOINT}');
      // final x = (
      //   '${EnvConstants.APP_API_ENDPOINT}/auth/create-account',
      //   data: auth_data,
      //   options: Options(
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Accept': 'application/json',
      //       'apikey': EnvConstants.SUPABASE_ROLE_KEY,
      //       'Authorization': 'Bearer ${EnvConstants.SUPABASE_ROLE_KEY}',
      //     },
      //   ).toString(),
      // ).toString();
      // log(x);
      var auth_response = await dio.post(
        '${EnvConstants.APP_API_ENDPOINT}/auth/create-account',
        data: auth_data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'apikey': EnvConstants.SUPABASE_ROLE_KEY,
            'Authorization': 'Bearer ${EnvConstants.SUPABASE_ROLE_KEY}',
          },
        ),
      );
      log(auth_response.data.toString());
      if (auth_response.data == null || auth_response.data == '') {
        Helper.errorSnackBar(
            title: 'Empty response',
            message: 'Empty response received from server',
            duration: 5);
        return;
      }
      await _getStorage.write('userId', auth_response.data['user']['id']);
      userId.value = auth_response.data['user']['id'];
      var chatParams = {
        'profile_id': userId.value,
        'most_recent_content': 'pending approval'
      };
      await dio.post('${EnvConstants.APP_API_ENDPOINT}/chats',
          data: chatParams);
      // final walletJson =
      //     await dio.post('${EnvConstants.APP_API_ENDPOINT}/wallets', data: walletParams);
      // await _getStorage.write('walletId', walletJson.data['id']);
      if (auth_response.statusCode == 201) {
        // await _getStorage.write(
        //     'account_type', auth_response.data['user']['account_type']);

        await _getStorage.write(
            'role', auth_response.data['user']['account_type']);
        if (account_type.value == 'coop-member') {
          AuthDataResponse new_auth_data =
              AuthDataResponse.fromJson(auth_response.data);
          if (profileImageFile.value.path.isNotEmpty) {
            profileImageUrl.value = (await uploadFile(profileImageFile.value))!;
          }
          if (nIDFile.value.path.isNotEmpty) {
            nIDFileUrl.value = (await uploadFile(nIDFile.value))!;
          }
          if (profileImageUrl.value.isNotEmpty ||
              nIDFile.value.path.isNotEmpty) {
            await updateAccount(new_auth_data.user.id);
          }

          Helper.successSnackBar(
              title: 'Mukai Community Welcome you  ',
              message: 'Your account successfully created',
              duration: 5);
          Get.to(() => MemberRegisterCoopScreen());
          // Get.to(() => BottomBar());
        } else if (account_type.value == 'coop-manager') {
          Helper.successSnackBar(
              title: 'Mukai Community Welcome you  ',
              message: 'Your account successfully created',
              duration: 5);
          Get.to(() => AdminRegisterCoopScreen());
        }
      } else {
        isLoading.value = false;
        final errorData = auth_response.data;
        final errorMessage = errorData['message'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
      addAuthData.value = false;
    } on DioException catch (e) {
      isLoading.value = false;
      addAuthData.value = false;
      log('Dio error: $e');
      if (e.response != null) {
        log('Error response data: ${e.response?.data}');
        final errorMessage = e.response?.data['message'] ?? e.message;
        log(errorMessage);
        return;
      } else {
        log('Network error occurred');
        return;
      }
    } catch (e, s) {
      isLoading.value = false;
      log('Registration error: $e $s');
      return;
      // throw Exception('Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Why am I being redirected to the member UI instead of the admin UI after this function executes?

  Future<void> registerCoop() async {
    try {
      isLoading.value = true;
      if (cooperative_name.value.isEmpty) {
        throw Exception('Cooperative name is required');
      }
      var admin_id = await _getStorage.read('userId');
      var req_data = {
        'admin_id': admin_id,
        'name': cooperative_name.value,
        'city': town_city.value,
        'country': city.value.country,
        'province_state': province.value,
        'category': cooperative_category.value,
        "description": null,
        "logo": null,
        "vision_statement": null,
        "mission_statement": null,
        "monthly_sub": subscription.value,
        // "wallet_id": null,
      };

      log('req_data: $req_data');
      var response = await dio.post(
        '${EnvConstants.APP_API_ENDPOINT}/cooperatives',
        data: req_data,
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      log(response.toString());
      if (response.statusCode == 201) {
        Helper.successSnackBar(
            title: 'Well Done',
            message: 'Your cooperative successfully created',
            duration: 5);
        _handleSuccessfulLogin();
      } else {
        isLoading.value = false;
      }
    } on DioException catch (e) {
      isLoading.value = false;
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Error response data: ${e.response?.data}');
        final errorMessage = e.message;
        log('registerCoop error: ${e.response}');
      } else {
        throw Exception('Network error occurred');
      }
    } catch (e) {
      isLoading.value = false;
      log('Registration error: $e');
      throw Exception('Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> upadateMemberProfile() async {
    try {
      isLoading.value = true;

      var req_data = {
        // 'coop_id': selected_coop.value.id,
        'member_id': userId.value,
        'request_type': 'new account',
        'status': 'unresolved',
        'cooperative_id': selected_coop.value.id,
        'city': town_city.value,
        'country': city.value.country,
        'province_state': province.value,
        'category': cooperative_category.value
      };
      log('req_data: $req_data');
      // log('${APP_API_ENDPOINT}/cooperative_member_requests');
      var response = await dio.post(
        '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_requests',
        data: req_data,
      );
      log('response: ${JsonEncoder.withIndent(' ').convert(response.data)}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Helper.successSnackBar(
            title: 'Well Done',
            message:
                'Your request to join ${selected_coop.value.name} successfully sent',
            duration: 5);
        Get.to(() => BottomBar(
              role: 'member',
            ));
      }
    } on DioException catch (e) {
      isLoading.value = false;
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Error response data: ${e.response?.data}');
        if (e.response?.data['message'] ==
            'A request for this member already exists') {
          isLoading.value = false;
          Helper.successSnackBar(
              title: 'Well Done',
              message: 'A request for this member already exists',
              duration: 5);
          Get.to(() => BottomBar(
                role: 'member',
              ));
        } else {
          final errorMessage = e.response?.data['message'] ?? e.message;
          Helper.errorSnackBar(
              title: 'Error', message: errorMessage, duration: 5);
        }
      } else {
        throw Exception('Network error occurred');
      }
    } catch (e) {
      isLoading.value = false;
      log('Registration error: $e');
      // throw Exception('Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> memberCoopRequest() async {
    try {
      isLoading.value = true;

      var req_data = {
        // 'coop_id': selected_coop.value.id,
        'member_id': userId.value,
        'request_type': 'new account',
        'status': 'unresolved',
        'cooperative_id': selected_coop.value.id,
        'city': town_city.value,
        'country': city.value.country,
        'province_state': province.value,
        'category': cooperative_category.value
      };
      log('req_data: $req_data');
      // log('${APP_API_ENDPOINT}/cooperative_member_requests');
      var response = await dio.post(
        '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_requests',
        data: req_data,
      );
      log('response: ${JsonEncoder.withIndent(' ').convert(response.data)}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Helper.successSnackBar(
            title: 'Well Done',
            message:
                'Your request to join ${selected_coop.value.name} successfully sent',
            duration: 5);
        Get.to(() => BottomBar(
              role: 'member',
            ));
      }
    } on DioException catch (e) {
      isLoading.value = false;
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Error response data: ${e.response?.data}');
        if (e.response?.data['message'] ==
            'A request for this member already exists') {
          isLoading.value = false;
          Helper.successSnackBar(
              title: 'Well Done',
              message: 'A request for this member already exists',
              duration: 5);
          Get.to(() => BottomBar(
                role: 'member',
              ));
        } else {
          final errorMessage = e.response?.data['message'] ?? e.message;
          Helper.errorSnackBar(
              title: 'Error', message: errorMessage, duration: 5);
        }
      } else {
        throw Exception('Network error occurred');
      }
    } catch (e) {
      isLoading.value = false;
      log('Registration error: $e');
      // throw Exception('Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerProvider() async {
    try {
      isLoading.value = true;
      if (phoneNumber.value.isEmpty) {
        throw Exception('Phone number is required');
      }
      if (password.value.isEmpty) {
        throw Exception('Password is required');
      }
      if (firstName.value.isEmpty || lastName.value.isEmpty) {
        throw Exception('First and last name are required');
      }
      final fMCToken = await FirebaseApi.getFirebaseMessagingToken();
      var auth_data = {
        'first_name': firstName.value,
        'last_name': lastName.value,
        'email': email.value,
        'phone': phoneNumber.value,
        'account_type': account_type.value,
        'push_token': fMCToken,
        'password': password.value,
        'national_id_url': null,
        'passport_url': null,
        'avatar': null,
      };

      log('Auth data: $auth_data');
      var response = await dio.post(
        '${EnvConstants.APP_API_ENDPOINT}/accounts/create-account',
        data: auth_data,
        options: Options(
          validateStatus: (status) {
            return status! < 500; // Don't throw for 4xx errors
          },
        ),
      );
      if (response.statusCode == 200) {
        AuthDataResponse new_auth_data =
            AuthDataResponse.fromJson(response.data);
        log('Registration successful: $new_auth_data');
        if (profileImageFile.value.path.isNotEmpty) {
          profileImageUrl.value = (await uploadFile(profileImageFile.value))!;
        }
        if (nIDFile.value.path.isNotEmpty) {
          nIDFileUrl.value = (await uploadFile(nIDFile.value))!;
        }
        if (profileImageUrl.value.isNotEmpty || nIDFile.value.path.isNotEmpty) {
          var response = await dio.put(
            '${EnvConstants.APP_API_ENDPOINT}/accounts/update-account/${new_auth_data.data.userId}',
            data: {
              'id': new_auth_data.data.userId,
              'avatar': profileImageUrl.value.isNotEmpty
                  ? profileImageUrl.value
                  : null,
              'national_id_url':
                  nIDFileUrl.value.isNotEmpty ? nIDFileUrl.value : null,
              'passport_url': passportFileUrl.value.isNotEmpty
                  ? passportFileUrl.value
                  : null,
            },
            options: Options(
              validateStatus: (status) {
                return status! < 500; // Don't throw for 4xx errors
              },
            ),
          );
          if (response.statusCode == 200) {
            isLoading.value = false;
            log('Account successfully updated');
            Helper.successSnackBar(
                title: 'Mukai Community Welcome you  ',
                message: 'Your account successfully created',
                duration: 5);
          }
        }
      } else {
        isLoading.value = false;
        final errorData = response.data;
        final errorMessage = errorData['message'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      isLoading.value = false;
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Error response data: ${e.response?.data}');
        final errorMessage = e.response?.data['message'] ?? e.message;
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error occurred');
      }
    } catch (e) {
      isLoading.value = false;
      log('Registration error: $e');
      throw Exception('Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    try {
      isLoading.value = true;
      log('register ${phoneNumber.value}, ${firstName.value}\npassword: ${password.value}');
      final fMCToken = await FirebaseApi.getFirebaseMessagingToken();
      log('device fMCToken $fMCToken');
      var auth_data = {
        'first_name': firstName.value,
        'last_name': lastName.value,
        'email': email.value,
        'phone': phoneNumber.value,
        'account_type': account_type.value,
        'push_token': fMCToken,
      };
      // var signup_data = await supabase.auth
      //     .signUp(email: email.value, password: password.value, data: auth_data);
      log(' auth_data: $auth_data');

      var response = await dio.post(
          '${EnvConstants.APP_API_ENDPOINT}/accounts/create-account',
          data: auth_data);
      log('response user: ${response.data}');
      if (response.data['statusCode'] == 200) {
        AuthDataResponse new_auth_data =
            AuthDataResponse.fromJson(response.data);
        log('response new_auth_data: $new_auth_data');
        await _getStorage.write('userId', response.data['user']['id']);
        userId.value = response.data['user']['id'];
        _handleSuccessfulLogin();
      }
    } catch (error) {
      log('Error: $error');
      isLoading.value = false;
      Get.defaultDialog(
          middleText: error.toString(),
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            // Get.back();
          });
    }
  }

  changeProfile(String id) async {
    if (profileImageFile.value.path.isNotEmpty) {
      profileImageUrl.value = (await uploadFile(profileImageFile.value))!;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      // update();

      // 1. Get raw user ID string from storage
      final userId = await _getStorage.read('userId');
      if (userId == null || userId.isEmpty) {
        throw Exception('No user ID found');
      }

      // 2. Call logout endpoint with raw user ID in URL
      final response = await dio
          .post(
            '${EnvConstants.APP_API_ENDPOINT}/auth/logout/$userId',
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Authorization':
                    'Bearer ${await _getStorage.read('accessToken')}',
              },
            ),
          )
          .timeout(const Duration(seconds: 10));
      log(response.toString());

      // 3. Clear local data regardless of API response
      await _clearLocalData();
      Get.offAll(() => LoginScreen());
    } on DioException catch (e) {
      // Even if API fails, clear local data
      await _clearLocalData();
      Get.offAll(() => LoginScreen());
      log('Logout API error: ${e.message}');
    } catch (e) {
      await _clearLocalData();
      Get.offAll(() => LoginScreen());
      log('Logout error: $e');
    } finally {
      isLoading.value = false;
      // update();
    }
  }

  Future<void> _clearLocalData() async {
    await _getStorage.erase();
    // Clear any other local repositories if needed
  }

  Future<void> checkAccount() async {
    isLoading.value = true;
    try {
      // var sessionId = await _getStorage.read('sessionId');
      final AuthResponse res = await supabase.auth.refreshSession();
      final session = res.session;
      log('checkAccount session $session');
      if (session != null) {
        log('checkAccount sessionId logged');
        final User? user = supabase.auth.currentUser;
        if (user != null) {
          var profile = Profile.fromMap(user.toJson());
          person.value = Profile.fromMap(user.toJson());
          person.refresh();
          final fMCToken = await FirebaseApi.getFirebaseMessagingToken();
          log('sessionId fMCToken $fMCToken');
          if (profile.push_token == null || profile.push_token != fMCToken) {
            await supabase
                .from('profile')
                .update({'push_token': fMCToken}).eq('id', profile.id!);
          }
          profileController.profile(profile);
          await _getStorage.write('userId', user.id); // }
          final Session? session = supabase.auth.currentSession;
          if (session != null && session.accessToken.isNotEmpty) {
            await _getStorage.write('session', session.toString());
          }
          isLoading.value = false;
          isSessionLogged.value = true;
          isLoading.value = false;
          log('profile.wallet_address ${profile.wallet_address}');
          if (profile.wallet_address == null) {
            await createUserWallet(profile);
          }
          log('profile.account_type: ${profile.account_type}');
          if (profile.account_type == null ||
              profileController.profile.value.account_type!.isEmpty) {
            Get.toNamed(Routes.editProfile);
          } else {
            Get.toNamed(Routes.bottomBar);
          }
        }
      } else {
        log('checkAccount sessionId not logged');
        isLoading.value = false;
        isSessionLogged.value = false;
        await logout();
      }
    } catch (error) {
      isLoading.value = false;
      isLoading.value = true;
      log('session error $error');
      await logout();
    }
  }

  Future<void> createUserWallet(Profile user) async {
    try {
      String user_id = user.id!;
      debugPrint('Create  User Wallet');
      debugPrint(user_id);
      var call = {
        "op": "createkey",
        "params": [
          {"name": "pwd", "value": user_id}
        ]
      };
      var response = await GetConnect()
          .post('https://testnet.toronet.org/api/keystore', call);

      if (response.body['result'] == true) {
        user.wallet_address = response.body['address'];
        log('user wallet address ${user.wallet_address}');
        try {
          final data = await supabase
              .from('user_extended')
              .update({
                'wallet_address': user.wallet_address,
                "wallet_balance": 10000
              })
              .eq('id', user_id)
              .select();

          log('usersCollectionId updateDocument ${data.single}');
        } catch (error) {
          log('usersCollectionId error $error');

          if (error is PostgrestException) {
            debugPrint('PostgrestException ${error.message}');
            Helper.errorSnackBar(title: 'Error', message: error.message);
          }
        }
      }
      isLoading.value = false;
      await checkAccount();
    } catch (error) {
      if (error is PostgrestException) {
        debugPrint('PostgrestException ${error.message}');
        Helper.errorSnackBar(title: 'Error', message: error.message);
      }
      throw error.toString().isEmpty
          ? 'Something went wrong. Please Try Again'
          : error.toString();
    }
    isLoading.value = false;
  }

  pickFileLocalStorage(String purpose) async {
    xImageFiles.clear();
    imageFiles.clear();
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    log('uploadedImageUrl: ${uploadedImageUrl.value}');
    if (xFile != null) {
      if (purpose == 'nID') {
        nIDFile.value = File(xFile.path);
      }
      if (purpose == 'propertyOwnership') {
        propertyOwnershipFile.value = File(xFile.path);
      }
      if (purpose == 'landMap') {
        landMapFile.value = File(xFile.path);
      }
      if (purpose == 'profileImage') {
        profileImageFile.value = File(xFile.path);
      }
      isImageAdded.value = true;
      update();
      uploadedImageUrl.value = (await uploadFile(File(xFile.path)))!;
      log('uploadedImageUrl: ${uploadedImageUrl.value}');
    }
    update();
  }

  Future<String?> uploadFile(File file) async {
    try {
      final fileExt = file.path.split('.').last;
      final fileName = '${uuid.v4()}.$fileExt';
      final filePath = 'images/$fileName';
      log('uploadFile filePath: ${filePath}');
      // await supabase.storage.from('kycfiles').remove(['']); // remove all files
      // await supabase.storage.deleteBucket('kycfiles');
      // await supabase.storage
      //     .createBucket('kycfiles', const BucketOptions(public: true));
      final String fullPath = await supabase.storage.from('kycfiles').upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      if (fullPath.isNotEmpty) {
        print('Upload error: ${fullPath}');
      } else {
        print('Uploaded: ${fullPath}');
      }
      return null;
    } catch (e, s) {
      log('uploadImages error: $e $s');
      return null;
    }
  }
}
