// import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
// import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/src/controllers/main.controller.dart';
import 'package:mukai/src/routes/app_pages.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/constants.dart' as constants;

class TransactionController extends MainController {
  AuthController get authController => Get.put(AuthController());

  TransactionController();
  final dio = Dio();
  var accountNumber = ''.obs;
  var phoneNumber = ''.obs;
  var orderId = ''.obs;
  var selectedTransferOption = ''.obs;
  var selectedTransferOptionCategory = ''.obs;
  var cartItemQty = 0.0.obs;
  var cashTendered = 0.0.obs;
  var orderChange = 0.0.obs;
  var cashinAmount = 0.0.obs;
  var cashoutAmount = 0.0.obs;
  var cashinAmountPercentage = 0.0.obs;
  var cashoutAmountPercentage = 0.0.obs;
  var transPercentage = 0.0.obs;
  var vatAmount = 0.0.obs;
  var doPrintReciept = false.obs;
  var confirmTransfer = false.obs;
  var totalCartItems = 0.obs;
  var cartTotalAmount = 0.0.obs;
  var transactions = <Transaction>[].obs;
  var selectedTransaction = Transaction().obs;
  var selectedWallet = Wallet().obs;
  var transferTransaction = Transaction().obs;
  var cashoutTransactions = <Transaction>[].obs;
  var cashinTransactions = <Transaction>[].obs;
  var wrf = false.obs;
  var isLoading = false.obs;
  var membersQueried = <Profile>[].obs;
  var selectedProfile = Profile(
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
  final GetStorage _getStorage = GetStorage();
  @override
  onInit() async {
    // getAllMembers().then((val) {});
    super.onInit();
  }

  Future<void> updateTransaction() async {
    try {} catch (error) {
      Helper.errorSnackBar(title: 'Error', message: error);
    }
  }

  Future<void> deleteTransaction(collection) async {
    try {} catch (error) {
      Helper.errorSnackBar(title: 'Error', message: error);
    }
  }

  Future<List<Profile>?> getMemberLikeID(String id) async {
    List<Profile> profilesList = [];
    log('--------- getMemberLikeID $id ----------');
    try {
      final response =
          await dio.get('$APP_API_ENDPOINT/auth/profiles/like/$id');
      final List<dynamic> jsonList = response.data;
      log(JsonEncoder.withIndent(' ').convert(jsonList));
      profilesList = jsonList.map((item) => Profile.fromMap(item)).toList();
      if (profilesList.isNotEmpty) {
        membersQueried.value = profilesList;
        membersQueried.refresh();
        await Helper.successSnackBar(
            title: 'Success', message: 'order saved', duration: 5);
        isLoading.value = false;
        transactions.refresh();
        final walletJson =
            await dio.get('$APP_API_ENDPOINT/wallets/${jsonList[0]['id']}');
        // log(JsonEncoder.withIndent(' ').convert(walletJson.data['id']));
        transferTransaction.value.receiving_wallet = walletJson.data['id'];
        log(transferTransaction.value.receiving_wallet.toString());
      } else {
        log('No profile data');
      }
      return profilesList;
    } catch (e, s) {
      log('getMemberLikeID error: $e $s');
      return [];
    }
  }

  Future<List<Profile>?> getAllMembers() async {
    List<Profile> profilesList = [];
    log('--------- getAllMembers ----------');
    try {
      final response =
          await dio.get('${constants.APP_API_ENDPOINT}/auth/profiles');
      // log(JsonEncoder.withIndent(' ').convert(response.data));
      final List<dynamic> jsonList = response.data;
      profilesList = jsonList.map((item) => Profile.fromMap(item)).toList();
      membersQueried.value = profilesList;
      membersQueried.refresh();
      await Helper.successSnackBar(
          title: 'Success', message: 'order saved', duration: 5);
      isLoading.value = false;
      transactions.refresh();
      return profilesList;
    } catch (e, s) {
      log('getAllMembers error: $e $s');
      return [];
    }
    /*
    try {
      await dio
          .get('${constants.APP_API_ENDPOINT}/auth/profiles')
          .then((response) async {
        log(response.data);
        final List<dynamic> json = response.data;
        profilesList = json.map((item) => Profile.fromMap(item)).toList();
        membersQueried.value = profilesList;
        membersQueried.refresh();
        await Helper.successSnackBar(title: 'Success', message: 'order saved');
        isLoading.value = false;
      }).catchError((error) {
        isLoading.value = false;
        if (error is PostgrestException) {
          debugPrint('PostgrestException ${error.message}');
          Helper.errorSnackBar(title: 'Error', message: error.message);
        } else {
          Helper.errorSnackBar(title: 'Error', message: error.toString());
        }
      });
      transactions.refresh();
      return profilesList;
    } catch (e) {
      Helper.errorSnackBar(title: 'Error', message: e.toString(), duration: 10);
      return profilesList;
    }
    
    try {
      await supabase.from('profiles').select('*').then((response) async {
        final List<dynamic> json = response;
        profilesList = json.map((item) => Profile.fromMap(item)).toList();
        membersQueried.value = profilesList;
        membersQueried.refresh();
        await Helper.successSnackBar(title: 'Success', message: 'order saved');
        isLoading.value = false;
      }).catchError((error) {
        isLoading.value = false;
        if (error is PostgrestException) {
          debugPrint('PostgrestException ${error.message}');
          Helper.errorSnackBar(title: 'Error', message: error.message);
        } else {
          Helper.errorSnackBar(title: 'Error', message: error.toString());
        }
      });
      transactions.refresh();
      return profilesList;
    } catch (error) {
      Helper.errorSnackBar(title: 'Error', message: error.toString());
      return profilesList;
    }
    */
  }

  Future<List<Transaction>> getAllTransaction() async {
    List<Transaction> transactionList = [];

    try {
      // var dateRangeLower = DateTime.now().month.days.toString();
      // var dateRangeUpper = DateTime.now().toString();
      await supabase.from('transactions').then((response) async {
        log('filterByProductCategory data: $response');
        final List<dynamic> json = response;
        transactionList =
            json.map((item) => Transaction.fromJson(item)).toList();
        await Helper.successSnackBar(title: 'Success', message: 'order saved');
        isLoading.value = false;

        Get.toNamed(Routes.bottomBar);
      }).catchError((error) {
        isLoading.value = false;

        if (error is PostgrestException) {
          debugPrint('PostgrestException ${error.message}');
          Helper.errorSnackBar(title: 'Error', message: error.message);
        } else {
          Helper.errorSnackBar(title: 'Error', message: error);
        }
      });
      transactions.refresh();
      return transactionList;
    } catch (error) {
      Helper.errorSnackBar(title: 'Error', message: error);
      return transactionList;
    }
  }

  Future<void> initiateTransfer() async {
    try {
      isLoading.value = true;

      // Validate required fields
      if (transferTransaction.value.amount == null ||
          transferTransaction.value.amount! <= 0) {
        throw Exception('A valid amount is required');
      }

      final userId = await _getStorage.read('userId');
      if (userId == null) {
        throw Exception('User ID not found. Please log in again.');
      }

      transferTransaction.value.account_id = userId;
      transferTransaction.value.category = 'transfer';

      log('transaction ${transferTransaction.toJson()}');
      var response = await dio.post(
        '$APP_API_ENDPOINT/transactions',
        data: transferTransaction.toJson(),
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      ).timeout(Duration(seconds: 10));
      log("transferTransaction response: ${response.toString()}");
      log("transferTransaction response data : ${response.data}");
      if (response.statusCode == 201) {
        selectedProfile.value = Profile(
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
        );
        await Helper.successSnackBar(
            title: 'Transaction Successful',
            message: response.data['message'],
            duration: 5);
        authController.initiateNewTransaction.value = false;
        final role = await _getStorage.read('account_type');
        if (role == 'coop-member') {
          Get.to(() => BottomBar(
                role: 'member',
              ));
        } else {
          Get.to(() => BottomBar(
                role: 'admin',
              ));
        }
      }

      /*
      if (response.statusCode == 200) {
        // Get.to(() => BottomBar());
      } else {
        isLoading.value = false;
        final errorData = response.data;
        final errorMessage = errorData['message'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
      */
    } on DioException catch (e) {
      isLoading.value = false;
      log('Dio error: ${e.message}');
      if (e.response != null) {
        log('Error response data: ${e.response?.data}');
        final errorMessage = e.response?.data['message'] ?? e.message;
        log(errorMessage);
      } else {
        throw Exception('Network error occurred');
      }
    } catch (e, s) {
      isLoading.value = false;
      log('Registration error: $e $s');
      // throw Exception('Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> initiateTransfer() async {
  //   try {
  //     isLoading.value = true;
  //     var userId = await _getStorage.read('userId');
  //     transferTransaction.value.account_id = userId;
  //     transferTransaction.value.category = 'transfer';
  //     log('transaction ${transferTransaction.toJson()}');
  //     await supabase
  //         .from('transactions')
  //         .insert(transferTransaction.toJson())
  //         .then((value) async {
  //       await Helper.successSnackBar(title: 'Success', message: 'order saved');
  //       isLoading.value = false;

  //       Get.toNamed(Routes.bottomBar);
  //     }).catchError((error) {
  //       isLoading.value = false;

  //       if (error is PostgrestException) {
  //         debugPrint('PostgrestException ${error.message}');
  //         Helper.errorSnackBar(title: 'Error', message: error.message);
  //       } else {
  //         Helper.errorSnackBar(title: 'Error', message: error);
  //       }
  //     });
  //   } catch (error) {
  //     log('addNewOrder error $error');
  //     isLoading.value = false;
  //     Helper.errorSnackBar(title: 'Error', message: error);
  //     return;
  //   }
  // }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      isLoading.value = true;
      log('transaction ${transaction.toJson()}');
      await supabase
          .from('transactions')
          .insert(transaction.toJson())
          .then((value) async {
        await Helper.successSnackBar(title: 'Success', message: 'order saved');
        isLoading.value = false;

        Get.toNamed(Routes.bottomBar);
      }).catchError((error) {
        isLoading.value = false;

        if (error is PostgrestException) {
          debugPrint('PostgrestException ${error.message}');
          Helper.errorSnackBar(title: 'Error', message: error.message);
        } else {
          Helper.errorSnackBar(title: 'Error', message: error);
        }
      });
    } catch (error) {
      log('addNewOrder error $error');
      isLoading.value = false;
      Helper.errorSnackBar(title: 'Error', message: error);
      return;
    }
  }

  Future<void> createCloudTransaction(Transaction transaction) async {
    try {
      await supabase.from('transactions').then((value) async {
        await Helper.successSnackBar(title: 'Success', message: 'order saved');
        isLoading.value = false;

        Get.toNamed(Routes.bottomBar);
      }).catchError((error) {
        isLoading.value = false;

        if (error is PostgrestException) {
          debugPrint('PostgrestException ${error.message}');
          Helper.errorSnackBar(title: 'Error', message: error.message);
        } else {
          Helper.errorSnackBar(title: 'Error', message: error);
        }
      });
    } catch (e) {
      log("Error updating document for  transaction id: ${transaction.id!}, Error: $e");
    }
  }

  Future<void> buyAirtime(order) async {
    try {
      isLoading.value = true;
      log('order ${order.toJson()}');

      Transaction transaction = Transaction(
          createdAt: DateTime.now().toString(),
          id: uuid.v4(),
          status: 'on create',
          transferMode: 'in-wallet',
          purpose: 'airtime',
          category: "cashout",
          amount: order.amount);
      var userId = await _getStorage.read('userId');
      order.customer = userId;
      order.transaction_id = transaction.id;
      await supabase.from('transactions').then((value) async {
        await Helper.successSnackBar(title: 'Success', message: 'order saved');
        isLoading.value = false;

        Get.toNamed(Routes.bottomBar);
      }).catchError((error) {
        isLoading.value = false;

        if (error is PostgrestException) {
          debugPrint('PostgrestException ${error.message}');
          Helper.errorSnackBar(title: 'Error', message: error.message);
        } else {
          Helper.errorSnackBar(title: 'Error', message: error);
        }
      });
    } catch (error) {
      log('addNewOrder error $error');
      isLoading.value = false;
      Helper.errorSnackBar(title: 'Error', message: error);
      return;
    }
  }

  Future<void> buyParkingTicket(Transaction transaction) async {
    try {
      isLoading.value = true;
      var userId = await _getStorage.read('userId');
      transaction.account_id = userId;
      log('transaction ${transaction.toJson()}');
      await supabase.from('transactions').then((value) async {
        await Helper.successSnackBar(title: 'Success', message: 'order saved');
        isLoading.value = false;

        Get.toNamed(Routes.bottomBar);
      }).catchError((error) {
        isLoading.value = false;

        if (error is PostgrestException) {
          debugPrint('PostgrestException ${error.message}');
          Helper.errorSnackBar(title: 'Error', message: error.message);
        } else {
          Helper.errorSnackBar(title: 'Error', message: error);
        }
      });
    } catch (error) {
      log('addNewOrder error $error');
      isLoading.value = false;
      Helper.errorSnackBar(title: 'Error', message: error);
      return;
    }
  }

  Future<void> updateCloudTransaction(Transaction transaction) async {
    try {
      Map<String, dynamic> updatedData = transaction.toJson();
      updatedData.remove('is_synced');
      await supabase.from('transactions');
      log("Updated Document for transaction id: ${transaction.id}");
    } catch (e) {
      log("Error updating document for  transaction id: ${transaction.id!}, Error: $e");
    }
  }

  Future<void> updateLocalTransaction(Transaction transaction) async {
    try {} catch (e) {
      log("Error updating document for item.inventoryId: ${transaction.id!}, Error: $e");
    }
  }
}
