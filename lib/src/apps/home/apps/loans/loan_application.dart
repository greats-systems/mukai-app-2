import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/cooperative-member-approval.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/controllers/cooperative-member-approvals.controller.dart';
import 'package:mukai/src/controllers/loan.controller.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanApplicationScreen extends StatefulWidget {
  final Group group;
  LoanApplicationScreen({
    super.key,
    required this.group,
  });

  @override
  State<LoanApplicationScreen> createState() => LoanApplicationScreenState();
}

class LoanApplicationScreenState extends State<LoanApplicationScreen> {
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
  CooperativeMemberApprovalsController cmaController =
      Get.put(CooperativeMemberApprovalsController());
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

  void fetchData() async {
    try {
      final id = await _getStorage.read('userId');
      final _role = await _getStorage.read('role');
      final borrowerWalletJson =
          await walletController.getIndividualWallets(id);
      final lenderWalletJson =
          await walletController.getGroupWallet(widget.group.id!);
      if (mounted) {
        setState(() {
          userId = id;
          role = _role;
          borrowerWallet = borrowerWalletJson;
          lenderWallet = lenderWalletJson;
          loanController.selectedCoop.value.id = widget.group.id;
        });
      }
      log('group id: ${widget.group.id}');
      log('group balance: ${lenderWallet?.balance.toString()}');
      log('LoanApplicationScreen data\nuser id: $userId\nborrower wallet:${JsonEncoder.withIndent('').convert(borrowerWallet)}\nlender wallet: ${JsonEncoder.withIndent('').convert(lenderWallet)}');
    } catch (e, s) {
      log('LoanApplicationScreen error: $e $s');
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
    cmaController.cma.value = CooperativeMemberApproval();
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
            body: Container(
              color: whiteF5Color,
              child: role == 'coop-manager'
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: height / 4, left: width / 8, right: width / 8),
                      child: loanInterestAdjustment(),
                    )
                  : loanApplicationForm(),
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
        Text(
            '*based on ${((widget.group.interest_rate) * 100).toStringAsFixed(0)}% monthly simple interest'),
        Obx(() => cmaController.isLoading.value == true
            ? const LinearProgressIndicator(
                minHeight: 1,
                color: whiteColor,
              )
            : saveButton(context)),
      ],
    );
  }

  Widget loanInterestAdjustment() {
    return ListView(children: [
      _buildInterestDropdownField(
        label: 'Monthly interest rate',
        value: collateral ?? '',
        options: [
          '0.01',
          '0.02',
          '0.05',
        ],
        onChanged: (newValue) {
          // Handle dropdown selection
          try {
            setState(() {
              interestRate = num.parse(newValue!);
            });
            cmaController.cma.value.pollDescription = 'set interest rate';
            cmaController.cma.value.profileId = userId;
            // loanController.selectedLoan.value.interestRate = interestRate;
            // cmaController.cma.value.additionalInfo = widget.;
            // loanController.selectedLoan.value.updatedAt =
            //     DateTime.now().toIso8601String();
            cmaController.cma.value.updatedAt =
                DateTime.now().toIso8601String();
            cmaController.cma.value.additionalInfo = newValue;
            cmaController.cma.value.consensusReached = false;
            cmaController.cma.value.groupId = widget.group.id!;

            log(cmaController.cma.value.toJson().toString());
          } on Exception catch (e) {
            log(e.toString());
          }
        },
      ),
      Obx(() => cmaController.isLoading.value == true
          ? const LinearProgressIndicator(
              minHeight: 1,
              color: whiteColor,
            )
          : saveInterestButton(context)),
    ]);
  }

  saveInterestButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () async {
          try {
            cmaController.createPoll();
          } on Exception catch (e, s) {
            log('saveButton error $e $s');
          }
          // Navigator.pop(context);
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
                  "Save Interest Rate",
                  style: bold18White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
      ),
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
          loanController.selectedLoan.value.interestRate =
              widget.group.interest_rate;
          loanController.selectedLoan.value.profileId = userId;
          loanController.selectedLoan.value.cooperativeId = widget.group.id!;
          loanController.selectedLoan.value.paymentAmount = paymentAmount;
          final loanResponse = await loanController.createLoan(userId!);
          if (loanResponse != null) {
            log('loan response ${loanResponse['id'].toString()}');
          }

          // Data for voting
          if (loanResponse != null) {
            cmaController.cma.value.pollDescription = 'loan application';
            cmaController.cma.value.groupId = widget.group.id!;
            cmaController.cma.value.profileId = userId;
            cmaController.cma.value.updatedAt =
                DateTime.now().toIso8601String();
            cmaController.cma.value.additionalInfo = principalAmount;
            cmaController.cma.value.consensusReached = false;
            cmaController.selectedGroup.value?.id = widget.group.id;
            cmaController.cma.value.loanId = loanResponse['id'].toString();
            cmaController.createPoll();
          } else {
            log('No response from loan creation');
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
                  "Save Loan",
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
