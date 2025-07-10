import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/components/app_bar.dart';
import 'package:mukai/src/controllers/loan.controller.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountLoanApplicationScreen extends StatefulWidget {
  AccountLoanApplicationScreen({
    super.key,
  });

  @override
  State<AccountLoanApplicationScreen> createState() => AccountLoanApplicationScreenState();
}

class AccountLoanApplicationScreenState extends State<AccountLoanApplicationScreen> {
  TextEditingController purposeController = TextEditingController();
  TextEditingController principalAmountController = TextEditingController();
  TextEditingController paybackPeriodController = TextEditingController();
  TextEditingController loanTermDaysController = TextEditingController();
  TextEditingController collateralDescriptionController =
      TextEditingController();
  TextEditingController fiatValueController = TextEditingController();

  TextEditingController monthlySubController = TextEditingController();
  TextEditingController totalSubsController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  final province_field_key = GlobalKey<DropdownSearchState>();
  final country_field_key = GlobalKey<DropdownSearchState>();
  final agritex_officer_key = GlobalKey<DropdownSearchState>();
  final district_key = GlobalKey<DropdownSearchState>();
  final town_city_key = GlobalKey<DropdownSearchState>();

  AuthController get authController => Get.put(AuthController());
  // GroupController get groupController => Get.put(GroupController());
  ProfileController get profileController => Get.put(ProfileController());
  LoanController get loanController => Get.put(LoanController());
  WalletController get walletController => Get.put(WalletController());
  late double height;
  late double width;
  Map<String, dynamic>? userJson = {};
  bool _isLoading = false;
  bool _hasCollateral = false;
  double? loanRequestAmount;
  int? paybackPeriodMonths;
  String? userId;
  String? role;
  List<Wallet>? borrowerWallet;
  Wallet? lenderWallet;
  GetStorage _getStorage = GetStorage();
  num? interestRate;
  double? principalAmount;
  num? paymentAmount;
  String? collateral;
  List<String> banks = [
    'AFC Bank',
    'BancABC',
    'CBZ Bank',
    'Ecobank',
    'FBC Bank',
    'First Capital Bank',
    'Metbank',
    'NMB Bank',
    'POSB Bank',
    'Stanbic Bank',
    'Steward Bank',
    'ZB Bank',
  ];

  void fetchData() async {
    try {
      final id = await _getStorage.read('userId');
      final _role = await _getStorage.read('role');
      final userData = await profileController.getUserDetails(id!);
      if (mounted) {
        setState(() {
          userId = id;
          role = _role;
          userJson = userData;
          _isLoading = false;
        });
      }
      log('group balance: ${lenderWallet?.balance.toString()}');
      log('AccountLoanApplicationScreen data\nuser id: $userId\nborrower wallet:${JsonEncoder.withIndent('').convert(borrowerWallet)}\nlender wallet: ${JsonEncoder.withIndent('').convert(lenderWallet)}');
    } catch (e, s) {
      log('AccountLoanApplicationScreen error: $e $s');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    paymentAmount = 0;
    principalAmount = 0;
  }

  @override
  Widget build(BuildContext context) {
    profileController.isLoading.value = false;
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return _isLoading
        ? Center(child: LoadingShimmerWidget())
        : Scaffold(
            appBar: MyAppBar(title: 'Account loan application'),
            body: Container(
              color: whiteF5Color,
              child: loanApplicationForm(),
            ),
          );
  }

  Widget loanApplicationForm() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(fixPadding * 2.0),
      children: [
        heightBox(10),
        purposeField(),
        heightBox(10),
        principalAmountField(),
        heightBox(10),
        paybackPeriodMonthsField(),
        heightBox(10),
        totalRepaymentField(),
        heightBox(20),
        collateralSwitch(),
        heightBox(20),
        if (_hasCollateral) collateralField(),
        // saveButton(context),
      ],
    );
  }

  void saveData(BuildContext context) async {
    try {
      // Data for loan creation
      if (principalAmount != null || lenderWallet?.balance != null) {
        if (principalAmount! <
            num.tryParse(lenderWallet!.balance.toString())!) {
          loanController.selectedLoan.value.borrowerWalletId =
              borrowerWallet![0].id;
          loanController.selectedLoan.value.lenderWalletId = lenderWallet!.id;
          loanController.selectedLoan.value.profileId = userId;
          loanController.selectedLoan.value.paymentAmount = paymentAmount;
          final loanResponse = await loanController.createLoan(userId!);
          if (loanResponse != null) {
            log('loan response ${loanResponse['id'].toString()}');
          }
        }
      } else {
        Helper.warningSnackBar(title: 'Infeasible',
            message: 'The coop cannot lend that much',
            duration: 5);
      }
    } on Exception catch (e, s) {
      log('saveButton error $e $s');
    }
    // Navigator.pop(context);
    Helper.successSnackBar(
        title: 'Success', message: 'Loan application created', duration: 5);
  }

  saveButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () => saveData(context),
        child: Obx(() => profileController.isLoading.value == true
            ? const LinearProgressIndicator(
                color: whiteColor,
              )
            : Container(
                width: double.maxFinite,
                margin: const EdgeInsets.fromLTRB(fixPadding * 2.0,
                    fixPadding * 2.0, fixPadding * 2.0, fixPadding * 3.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: buttonShadow,
                ),
                child: const Text(
                  "Save Individual Loan",
                  style: bold18White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
      ),
    );
  }

  purposeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purpose',
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              loanController.selectedLoan.value.loanPurpose = value;
              loanController.selectedLoan.refresh();
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: purposeController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  collateralField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collateral Type',
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: DropdownButtonFormField<String>(
            value: loanController.selectedLoan.value.collateralDescription,
            items: const [
              DropdownMenuItem(
                value: 'vehicle',
                child: Text('Vehicle'),
              ),
              DropdownMenuItem(
                value: 'house',
                child: Text('House'),
              ),
              DropdownMenuItem(
                value: 'savings account',
                child: Text('Savings Account'),
              ),
            ],
            onChanged: (value) {
              loanController.selectedLoan.value.collateralDescription = value;
              loanController.selectedLoan.refresh();
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
            style: semibold14Black,
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down, color: primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ],
    );
  }

  collateralSwitch() {
    return Row(
      children: [
        Text(
          'Any collateral?',
          style: semibold14Black,
        ),
        const Spacer(), // Pushes the switch to the right
        Switch(
          value: _hasCollateral,
          onChanged: (value) {
            if (mounted) {
              setState(() {
                _hasCollateral = value;
              });
            }
          },
        ),
      ],
    );
  }

  principalAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Principal amount',
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              final amount = double.tryParse(value) ?? 0;
              loanController.selectedLoan.update((val) {
                val?.principalAmount = amount;
              });
              loanController.calculateRepayAmount();
              setState(() {
                principalAmount = double.tryParse(value);
              });
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: principalAmountController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  paybackPeriodMonthsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payback period (months)',
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              final months = int.tryParse(value) ?? 0;
              loanController.selectedLoan.update((val) {
                val?.loanTermMonths = months;
              });
              loanController.calculateRepayAmount();
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: paybackPeriodController,
            decoration: InputDecoration(
              border: InputBorder.none,
              // hintText: 'Purpose for loan',
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  totalRepaymentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total repayment amount (\$)',
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
            child: Obx(
          () => TextField(
            onChanged: (value) {
              setState(() {
                paymentAmount = num.tryParse(value);
              });
            },
            enabled: false,
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: loanController.selectedLoan.value.paymentAmount
                  ?.toStringAsFixed(2),
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        ))
      ],
    );
  }

  boxWidget({required Widget child}) {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: screenBGColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: recShadow,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: recWhiteColor,
        ),
        child: child,
      ),
    );
  }

  BoxDecoration bgBoxDecoration = BoxDecoration(
    color: recColor,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: recShadow,
  );
}
