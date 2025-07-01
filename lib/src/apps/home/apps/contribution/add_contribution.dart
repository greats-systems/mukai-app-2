/*
import 'package:flutter/material.dart';

class AddContributionScreen extends StatefulWidget {
  const AddContributionScreen({super.key});

  @override
  State<AddContributionScreen> createState() => _AddContributionScreenState();
}

class _AddContributionScreenState extends State<AddContributionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar(title: 'Loan Application'),
      body: Center(child: Text('Loan application')));
  }
}
*/

import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/eva.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/home/apps/savings/set_milestone.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/controllers/loan.controller.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/group.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddContributionScreen extends StatefulWidget {
  final Group group;
  AddContributionScreen({
    super.key,
    required this.group,
  });

  @override
  State<AddContributionScreen> createState() => AddContributionScreenState();
}

class AddContributionScreenState extends State<AddContributionScreen> {
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
  TransactionController get transactionController =>
      Get.put(TransactionController());
  AuthController get authController => Get.put(AuthController());
  GroupController get groupController => Get.put(GroupController());
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
  String? profile_wallet_id;
  String? profile_wallet_balance;
  List<Wallet>? senderWallet;
  Wallet? receiverWallet;
  GetStorage _getStorage = GetStorage();
  num? interestRate;
  String? lock_parameter;
  DateTime? selectedDate;
  void fetchData() async {
    try {
      final id = await _getStorage.read('userId');
      var wallet_id = _getStorage.read('profile_wallet_id');
      var balance = _getStorage.read('profile_wallet_balance');
      log('profile_wallet_id: $wallet_id');
      if (mounted) {
        walletController.setSaving.value.walletId = wallet_id;
        walletController.setSaving.value.walletId = wallet_id;
        walletController.setSaving.value.profileId = id;
        walletController.setSaving.refresh();
        setState(() {
          userId = id;
          profile_wallet_id = wallet_id;
          profile_wallet_balance = balance.toString();
        });
      }
      log('group id: ${widget.group.id}');
      log('AddContributionScreen data\nuser id: $userId\nsender wallet:${JsonEncoder.withIndent('').convert(senderWallet)}\nreceiver wallet: ${JsonEncoder.withIndent('').convert(receiverWallet)}');
    } catch (e, s) {
      log('AddContributionScreen error: $e $s');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
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
            appBar: AppBar(
              title: const Text('Add Contribution Record'),
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: Container(
              color: whiteF5Color,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(fixPadding * 2.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Receiving Wallet',
                            style: bold16Black,
                          ),
                          widthBox(10),
                          if (widget.group.wallet_id != null)
                            Text(
                              '... ${widget.group.wallet_id?.substring(28, 36)}',
                              style: semibold14Grey,
                            ),
                        ],
                      ),
                    ],
                  ),
                  height20Space,
                  accountNumberField(),
                  heightBox(10),
                  heightBox(20),
                  Obx(() => transactionController.isLoading.value == true
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: LoadingShimmerWidget())
                      : transactionController.selectedProfile.value.id != null
                          ? Column(
                              children: [
                                detailsField(),
                                heightBox(20),
                                principalAmountField(),
                              ],
                            )
                          : SizedBox()),
                  heightBox(10),
                  heightBox(height * 0.05),
                  Obx(() => walletController.isLoading.value
                      ? const Center(
                          child: LinearProgressIndicator(
                          minHeight: 1,
                          color: primaryColor,
                        ))
                      : savePlanButton())
                ],
              ),
            ),
          );
  }

  accountNumberField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        onChanged: (value) async {
          transactionController.accountNumber.value = value;
          if (value.length > 4) {
            await transactionController.getProfileByIDSearch(value);
          }
        },
        style: medium14Black,
        cursorColor: primaryColor,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: greyB5Color), // Border color when not focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor), // Border color when focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
          hintText: "Enter Account-ID",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Icon(
              Icons.wallet,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  detailsField() {
    return Card(
      color: primaryColor.withAlpha(100),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paying Account',
              style: TextStyle(
                  color: whiteF5Color,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Phone Number:\t',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: whiteF5Color),
                ),
                Text(
                  '${transactionController.selectedProfile.value.phone}',
                  style: TextStyle(color: whiteF5Color),
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'First Name:\t',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: whiteF5Color),
                ),
                Text(
                  '${transactionController.selectedProfile.value.first_name}',
                  style: TextStyle(color: whiteF5Color),
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Name:\t',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: whiteF5Color),
                ),
                Text(
                  '${transactionController.selectedProfile.value.last_name}',
                  style: TextStyle(color: whiteF5Color),
                  // style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (transactionController.selectedProfile.value.wallet_id != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Wallet ID:\t',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: whiteF5Color),
                  ),
                  Text(
                    "${transactionController.selectedProfile.value.wallet_id?.substring(0, 8)}...${transactionController.selectedProfile.value.wallet_id?.substring(28, 36)}",
                    style: TextStyle(color: whiteF5Color),
                    // style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget datePickerField({
    required String label,
    required DateTime? selectedDate,
    required ValueChanged<DateTime?> onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: semibold14Black),
        heightSpace,
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              builder: (context, child) {
                return Localizations.override(
                  context: context,
                  locale: const Locale('en', 'ZW'),
                  child: child!,
                );
              },
              context: context,
              initialDate:
                  selectedDate ?? DateTime.now().add(const Duration(days: 2)),
              firstDate: DateTime.now().add(const Duration(days: 2)),
              lastDate: DateTime(now.year + 10),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: boxWidget(
            child: Padding(
              padding: EdgeInsets.all(fixPadding * 1.5),
              child: Text(
                selectedDate != null
                    ? "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}"
                    : "Select date",
                style: semibold14Black,
              ),
            ),
          ),
        ),
      ],
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
              walletController.setSaving.update(
                (val) {
                  val?.purpose = value;
                },
              );
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

  Widget _buildInterestDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: semibold14Black),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value.isNotEmpty ? value : null,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            hint: Text(
              'Select interest rate',
              style: TextStyle(color: Colors.black),
            ),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  '${(num.parse(value) * 100).toStringAsFixed(0)}%', // Show as percentage
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an interest rate';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: semibold14Black,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButton<String>(
            dropdownColor: whiteColor,
            value: value.isNotEmpty ? value : null,
            hint: Text(
              'Select an option',
              style: TextStyle(color: Colors.black),
            ),
            isExpanded: true,
            underline: const SizedBox(), // Remove default underline
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  Utils.trimp(option),
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // _buildDropdownField(
  //                 label: 'Collateral',
  //                 value: widget.loan.collateralDescription ?? '',
  //                 options: [
  //                   'Car',
  //                   'House',
  //                   'Savings account',
  //                 ],
  //                 onChanged: (newValue) {
  //                   // Handle dropdown selection
  //                   setState(() {
  //                     widget.loan.status = newValue;
  //                   });
  //                 },
  //               )
  Widget milestoneField() {
    return MilestoneInputWidget(
      onMilestonesChanged: (milestones) {
        walletController.setSaving.value.lockMilestones = milestones;
        walletController.setSaving.refresh();
      },
    );
  }

  savePlanButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => walletController.isLoading.value == true
            ? Column(
                children: [
                  SizedBox(
                      width: width * 0.6,
                      child: const LinearProgressIndicator(
                        color: primaryColor,
                      )),
                  Text(
                    "please wait ...",
                    style: semibold14LightWhite,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  goBackButton(),
                  setSavingPlanButton(),
                ],
              )),
      ],
    );
  }

  goBackButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
        // transactionController.selectedProfile.value.email = '';
      },
      child: Container(
        width: width * 0.35,
        height: height * 0.05,
        decoration: BoxDecoration(
          color: greyColor,
          borderRadius: BorderRadius.circular(10.0),
          // boxShadow: buttonShadow,
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(
              Eva.chevron_left_outline,
              color: whiteF5Color,
            ),
            Text(
              "Cancel",
              style: bold18WhiteF5,
            ),
          ],
        ),
      ),
    );
  }

  setSavingPlanButton() {
    return GestureDetector(
      onTap: () async {
        var transaction = Transaction(
          id: Uuid().v4(),
          transactionType: 'contribution',
          transferCategory: 'cash',
          transferMode: 'cash',
          account_id: userId,
          purpose: 'contribution',
          status: 'completed',
          narrative: 'contribution record keeping',
          amount: double.parse(principalAmountController.text),
          receiving_wallet: widget.group.wallet_id,
          sending_wallet: transactionController.selectedProfile.value.wallet_id,
        );
        await transactionController.addTransaction(transaction);
      },
      child: Container(
        width: width * 0.45,
        height: height * 0.05,
        decoration: BoxDecoration(
          color: authController.farm_name.isNotEmpty ? greyColor : primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          // boxShadow: buttonShadow,
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Save",
              style: bold18WhiteF5,
            ),
            Iconify(
              Eva.chevron_right_outline,
              color: whiteF5Color,
            )
          ],
        ),
      ),
    );
  }

  eventField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event description',
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            maxLines: 3,
            onChanged: (value) {
              walletController.setSaving.value.lockEvent = value;
              walletController.setSaving.refresh();
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: collateralDescriptionController,
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

  collateralSwitch() {
    return Row(
      children: [
        Text(
          'Any lock_parameter?',
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
          'Amount',
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              final amount = double.tryParse(value) ?? 0;
              walletController.setSaving.update((val) {
                val?.lockAmount = amount;
              });
              loanController.calculateRepayAmount();
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
