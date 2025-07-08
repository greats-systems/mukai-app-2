/*
import 'package:flutter/material.dart';

class SetSavingsScreen extends StatefulWidget {
  const SetSavingsScreen({super.key});

  @override
  State<SetSavingsScreen> createState() => _SetSavingsScreenState();
}

class _SetSavingsScreenState extends State<SetSavingsScreen> {
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
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/home/apps/savings/set_milestone.dart';
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

class SetSavingsScreen extends StatefulWidget {
  final Group group;
  SetSavingsScreen({
    super.key,
    required this.group,
  });

  @override
  State<SetSavingsScreen> createState() => SetSavingsScreenState();
}

class SetSavingsScreenState extends State<SetSavingsScreen> {
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
        walletController.setSaving.value.profileId = id;
        walletController.setSaving.refresh();
        setState(() {
          userId = id;
          profile_wallet_id = wallet_id;
          profile_wallet_balance = balance.toString();
        });
      }
      log('group id: ${widget.group.id}');
      log('SetSavingsScreen data\nuser id: $userId\nsender wallet:${JsonEncoder.withIndent('').convert(senderWallet)}\nreceiver wallet: ${JsonEncoder.withIndent('').convert(receiverWallet)}');
    } catch (e, s) {
      log('SetSavingsScreen error: $e $s');
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
              title: const Text('Set Savings Plan'),
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
                            'Wallet Address',
                            style: bold16Black,
                          ),
                          widthBox(10),
                          if (profile_wallet_id != null)
                            Text(
                              '... ${profile_wallet_id?.substring(28, 36)}',
                              style: semibold14Grey,
                            ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Balance',
                            style: bold16Black,
                          ),
                          widthBox(10),
                          Text(
                            '\$${profile_wallet_balance ?? 0.0}',
                            style: semibold14Grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  height20Space,
                  _buildDropdownField(
                    label: 'Lock Feature',
                    value: lock_parameter ?? '',
                    options: [
                      'amount',
                      'date',
                      'milestone',
                      'event',
                    ],
                    onChanged: (newValue) {
                      // Handle dropdown selection
                      walletController.setSaving.update((val) {
                        val?.lockFeature = newValue;
                      });

                      setState(() {
                        lock_parameter = newValue;
                      });
                    },
                  ),
                  heightBox(10),
                  purposeField(),
                  heightBox(10),
                  // descriptionField(),
                  if (lock_parameter == 'amount') principalAmountField(),
                  if (lock_parameter == 'date')
                    datePickerField(
                      label: 'Select Date',
                      selectedDate: selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                        walletController.setSaving.update((val) {
                          val?.lockDate = date?.toIso8601String();
                        });
                      },
                    ),
                  if (lock_parameter == 'milestone') milestoneField(),
                  if (lock_parameter == 'event') eventField(),
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

  saveButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () async {
          try {
            loanController.selectedCoop.value.id = widget.group.id;
            loanController.sendingWallet.value.id = senderWallet![0].id;
            loanController.receivingWallet.value.id = receiverWallet!.id;
            loanController.createLoan(userId!);
          } on Exception catch (e, s) {
            log('saveButton error $e $s');
          }
          Navigator.pop(context);
          Helper.successSnackBar(
              title: 'Success',
              message: 'Loan application created',
              duration: 5);
        },
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
                  "Save Loan",
                  style: bold18White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
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
        final uuid = Uuid().v4().substring(20, 36);
        walletController.setSaving.value.unlockKey = uuid;
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: whiteColor,
              title: const Text('Important: Save Your Code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'A unique code has been generated for your savings plan. Please screenshot or write down this code. You will need it to access or recover your plan.',
                  ),
                  const SizedBox(height: 16),
                  SelectableText(
                    uuid,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Keep this code safe!'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await walletController.setSavingPlan();
                    Get.back(result: true);
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
        
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
              "Save Portfolio",
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
          'Amount (US\$)',
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
