import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/loading_shimmer.dart';

class ManualTransferToWalletWidget extends StatefulWidget {
  ManualTransferToWalletWidget({super.key});

  @override
  State<ManualTransferToWalletWidget> createState() =>
      _ManualTransferToWalletWidgetState();
}

class _ManualTransferToWalletWidgetState
    extends State<ManualTransferToWalletWidget> {
  // final walletProfileWidget_key = GlobalKey<DropdownSearchState>();
  TransactionController get transactionController =>
      Get.put(TransactionController());
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GetStorage _getStorage = GetStorage();
  late double height;
  late double width;
  // final dropDownKey = GlobalKey<DropdownSearchState>();
  String? userId;
  String? walletId;

  void _fetchData() async {
    final id = await _getStorage.read('userId');
    final wallet_id = await _getStorage.read('walletId');
    setState(() {
      userId = id;
      walletId = wallet_id;
      transactionController.transferTransaction.value.sending_wallet = walletId;
    });
    log('ManualTransferToWalletWidget userId: $userId and walletId: $walletId');
  }

  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        height20Space,
        accountNumberField(),
        heightBox(20),
        Obx(() => transactionController.isLoading.value == true
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: LoadingShimmerWidget())
            : transactionController.selectedProfile.value.id != null
                ? Column(
                    children: [detailsField(), heightBox(20), amountField()],
                  )
                : SizedBox())
      ],
    );

    // Obx(() => transactionController.confirmTransfer.value == true
    //     ? ConfirmTransferWidget()
    //     : Column(
    //         children: [
    //           height20Space,
    //           accountNumberField(),
    //           heightBox(20),
    //           if (transactionController.selectedProfile.value.id != null)
    //             Column(
    //               children: [detailsField(), heightBox(20), amountField()],
    //             )
    //         ],
    //       ));
  }

  mobileNumberField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: IntlPhoneField(
        // focusNode: FocusNode(onKeyEvent: ),
        keyboardType: TextInputType.phone,
        onChanged: (value) => {
          transactionController.phoneNumber.value = value.completeNumber,
        },
        controller: phoneController,
        disableLengthCheck: true,
        showCountryFlag: false,
        dropdownTextStyle: semibold15Grey,
        initialCountryCode: "ZW",
        dropdownIconPosition: IconPosition.trailing,
        dropdownIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: greyColor,
        ),
        style: medium14Black,
        dropdownDecoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: greyColor, width: 2.0),
          ),
        ),
        pickerDialogStyle: PickerDialogStyle(backgroundColor: dialogBgColor),
        flagsButtonMargin: const EdgeInsets.symmetric(
            horizontal: fixPadding, vertical: fixPadding / 1.5),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey), // Border color when not focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor), // Border color when focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
          hintText: "Enter your mobile number",
          hintStyle: medium15Grey,
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
              'Recieving Account',
              style: TextStyle(
                  color: blackOrignalColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email:\t',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${transactionController.selectedProfile.value.email}',
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${transactionController.selectedProfile.value.first_name}',
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${transactionController.selectedProfile.value.last_name}',
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${transactionController.selectedProfile.value.wallet_id?.substring(0, 8)}...${transactionController.selectedProfile.value.wallet_id?.substring(28, 36)}",
                    // style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
      // ddd167ff-b10c-496f-9e33-afb22114375d
      // 597023af-78ef-47a0-818b-027d7d8d9ad4
      child: TextField(
        onChanged: (value) async {
          // transactionController
          //     .transferTransaction.value.receiving_account_number = value,
          transactionController.accountNumber.value = value;
          if (value.length > 4) {
            await transactionController.getProfileByIDSearch(value);
          }

          // transactionController.getAllMembers()
        },
        style: medium14Black,
        cursorColor: primaryColor,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey), // Border color when not focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor), // Border color when focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          // 2faa7105-915a-4971-9616-f1f7a713bdcd
          contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
          hintText: "Enter Account Number",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Icon(
              Icons.person_outline,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  amountField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        onChanged: (value) {
          try {
            transactionController.transferTransaction.value.amount =
                double.parse(value);
            log(transactionController.transferTransaction.value.amount
                .toString());
          } catch (e, s) {
            log('$e $s');
          }
        },
        style: medium14Black,
        cursorColor: primaryColor,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey), // Border color when not focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: primaryColor), // Border color when focused
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
          hintText: "Enter Amount",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Iconify(
              Ri.money_dollar_circle_fill,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
/*
  Widget walletProfileWidget() {
  return Obx(() {
    if (transactionController.membersQueried.isEmpty) {
      return SizedBox(); // Don't show dropdown if no results
    }

    return Container(
      // ... existing container styling
      child: DropdownSearch<Profile>(
        items: transactionController.membersQueried,
        selectedItem: transactionController.selectedProfile.value,
        onChanged: (Profile? profile) {
          if (profile != null) {
            transactionController.selectedProfile.value = profile;
            // Auto-fill other fields if needed
            phoneController.text = profile.phone ?? '';
          }
        },
        dropdownBuilder: (context, selectedItem) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              selectedItem?.first_name ?? 'Select Profile',
              style: medium14Black,
            ),
          );
        },
        popupProps: PopupProps.menu(
          itemBuilder: (context, profile, isSelected) => ListTile(
            title: Text(profile.first_name ?? 'No name'),
            subtitle: Text(profile.id ?? 'No ID'),
          ),
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "Search profiles...",
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  });
}
*/

  Widget walletProfileWidget() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: whiteF5Color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: recShadow,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Obx(() {
          final selectedCoop = transactionController.selectedProfile.value;
          return DropdownSearch<Profile>(
            compareFn: (item1, item2) => item1 == item2,
            onChanged: (value) {
              log('selectedProfile.value.name ${transactionController.selectedProfile.value.first_name}');
              log('selectedProfile.value.id ${transactionController.selectedProfile.value.id}');
              transactionController.selectedProfile.value = value!;
            },
            // key: walletProfileWidget_key,
            selectedItem: selectedCoop,
            items: (filter, infiniteScrollProps) =>
                transactionController.membersQueried,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Select Wallet Profile',
                hintStyle: const TextStyle(color: Colors.black, fontSize: 22),
                filled: true,
                fillColor: recWhiteColor,
              ),
            ),
            // ddd167ff-b10c-496f-9e33-afb22114375d
            dropdownBuilder: (context, selectedItem) {
              if (selectedItem == null) {
                return const Text(
                  'Select Profile',
                  style: TextStyle(color: blackColor),
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedItem.first_name != null
                          ? Utils.trimp(selectedItem.first_name!)
                          : 'No profile selected',
                      style: const TextStyle(
                        color: blackColor,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
            popupProps: PopupProps.menu(
              itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.id != null
                                ? Utils.trimp(item.first_name!)
                                : 'No name',
                            style: const TextStyle(
                              color: blackColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              showSelectedItems: true,
              fit: FlexFit.loose,
              constraints: const BoxConstraints(),
              menuProps: const MenuProps(
                backgroundColor: whiteF5Color,
                elevation: 4,
              ),
            ),
          );
        }),
      ),
    );
  }
}
