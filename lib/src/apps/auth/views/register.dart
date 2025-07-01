import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/routes/app_pages.dart';
import 'package:mukai/theme/theme.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/eva.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mukai/utils/constants/hardCodedCountries.dart';
import 'package:mukai/utils/utils.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  AuthController get authController => Get.put(AuthController());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // final dropDownKey = GlobalKey<DropdownSearchState>();
  // final serviceProviderDropDownKey = GlobalKey<DropdownSearchState>();
  late double height;
  late double width;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteF5Color,
        elevation: 0.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        toolbarHeight: 00.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteF5Color,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: whiteF5Color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(0.0),
                ),
                border: Border.all(
                  color: whiteF5Color,
                ),
                boxShadow: boxShadow,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(fixPadding * 2.0),
                children: [
                  appLogo(),
                  registerContent(),
                  height20Space,
                  Obx(() {
                    if (authController.addAuthData.value == true) {
                      return Column(
                        children: [
                          height5Space,

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [profileImageField(), nIDimageField()],
                          // ),
                          // height20Space,
                          account_type(),
                          height20Space,
                          genderField(),
                          height20Space,
                          province_field(),
                          height20Space,
                          town_cityField(),
                          height20Space,
                          Obx(() => datePickerField(
                                context: context,
                                label: 'Set Date of Birth',
                                selectedDate:
                                    authController.date_of_birth.value,
                                onDateSelected: (date) {
                                  authController.date_of_birth.value = date!;
                                  authController.date_of_birth.refresh();
                                },
                              )),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          height20Space,
                          userNameField(),
                          height20Space,
                          lastNameField(),
                          height20Space,
                          IdNumberField(),
                          height20Space,
                          emailField(),
                          height20Space,
                          passwordField(),
                          height20Space,
                          confirmPasswordField(),
                          height20Space,
                          mobileNumberField(),
                        ],
                      );
                    }
                  }),
                  height20Space,
                  height20Space,
                  Obx(() => authController.isLoading.value == true
                      ? Column(
                          children: [
                            const LinearProgressIndicator(),
                            Text(
                              "Signing up ...",
                              style: semibold14LightWhite,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              if (authController.addAuthData.value == true)
                                goBackButton(),
                              registerButton()
                            ])),
                  heightSpace,
                  heightSpace,
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.login);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        heightSpace,
                        Text(
                          "Already have account?",
                          style: semibold14Black,
                          textAlign: TextAlign.center,
                        ),
                        widthSpace,
                        Row(
                          spacing: 5,
                          children: [
                            Text(
                              "Login",
                              style: semibold14Secondary,
                              textAlign: TextAlign.center,
                            ),
                            Iconify(
                              Ri.arrow_right_line,
                              size: 24,
                              color: secondaryColor,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  confirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: confirmPasswordController,
        onChanged: (value) => {
          authController.password.value = value,
        },
        obscureText: true,
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
          hintText: "Confirm password",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Icon(
              Icons.password_sharp,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget genderField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Obx(() => DropdownSearch<String>(
            onChanged: (value) => {
              authController.selectedGender.value = value!,
            },
            // key: dropDownKey,
            selectedItem: Utils.trimp(authController.selectedGender.value),
            items: (filter, infiniteScrollProps) => authController.genderList,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: primaryColor), // Border color when focused
                  borderRadius: BorderRadius.circular(10.0),
                ),

                labelText: 'Select Gender',
                labelStyle: const TextStyle(
                    height: 10,
                    color: blackColor,
                    fontSize: 22), // Black label text
                // border: const OutlineInputBorder(),
                filled: true,
                fillColor: recWhiteColor, // White background for input field
              ),
              baseStyle: const TextStyle(
                  color: blackColor,
                  fontSize: 18), // Black text for selected item
            ),
            popupProps: PopupProps.menu(
              itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(Utils.trimp(item),
                    style: const TextStyle(color: blackColor, fontSize: 18)),
              ),
              fit: FlexFit.loose,
              constraints: const BoxConstraints(),
              menuProps: const MenuProps(
                backgroundColor: whiteF5Color,
                elevation: 4,
              ),
            ),
          )),
    );
  }

  IdNumberField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: nationalIdController,
        onChanged: (value) => {
          authController.nationalIdNumber.value = value,
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
          hintText: "National ID Number",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Icon(
              Icons.info_rounded,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget datePickerField({
    required BuildContext context,
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
              confirmText: 'Set Date of Birth',
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              barrierColor: primaryColor.withAlpha(100),
              builder: (context, child) {
                return Localizations.override(
                  context: context,
                  locale: const Locale('en', 'ZW'),
                  child: child!,
                );
              },
              context: context,
              initialDate: selectedDate ?? DateTime(now.year - 16),
              firstDate: DateTime(now.year - 80),
              lastDate: DateTime(now.year - 12),
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
                    : 'Set Date of Birth',
                style: semibold14Black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  boxWidget({required Widget child}) {
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
          borderRadius: BorderRadius.circular(10.0),
          color: recWhiteColor,
        ),
        child: child,
      ),
    );
  }

  town_cityField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Obx(() => DropdownSearch<String>(
              onChanged: (value) => {
                authController.town_city.value = value!,
                authController.selected_city.value = value,
                // authController.filterCooperatives()
              },
              // key: town_city_key,
              selectedItem: authController.town_city.value,
              items: (filter, infiniteScrollProps) =>
                  authController.selected_province_town_city_options,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Select Resident Town/City',
                  labelStyle: const TextStyle(
                      color: blackOrignalColor,
                      fontSize: 22), // Black label text
                  // border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: recWhiteColor, // White background for input field
                ),
                baseStyle: const TextStyle(
                    color: blackOrignalColor,
                    fontSize: 18), // Black text for selected item
              ),
              popupProps: PopupProps.menu(
                itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item,
                      style: const TextStyle(
                          color: blackOrignalColor, fontSize: 18)),
                ),
                fit: FlexFit.loose,
                constraints: BoxConstraints(maxHeight: height * 0.5),
                menuProps: MenuProps(
                  // barrierColor: primaryColor.withAlpha(50),
                  backgroundColor: whiteF5Color,
                  elevation: 4,
                ),
              ),
            )),
      ),
    );
  }

  province_field() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Obx(() => DropdownSearch<String>(
              onChanged: (value) async {
                try {
                  if (value != null) {
                    authController.selected_country.value = value;
                    // Find the province in the list and get its districts
                    await authController.getCitiesFromCountry(value);
                    var selectedProvinceData = authController
                        .province_options_with_districts
                        .firstWhere(
                      (item) => item.keys.first == value,
                      orElse: () => {value: []},
                    );
                    var selectedProvinceCityData = authController
                        .province_options_with_districts
                        .firstWhere(
                      (item) => item.keys.first == value,
                      orElse: () => {value: []},
                    );
                    if (selectedProvinceData[value] != null) {
                      authController.selected_country_options.value =
                          selectedProvinceData[value]!;
                    }
                    if (authController.selected_country_options!=null) {
  authController.district.value =
      authController.selected_country_options[0];
}
                    // // //
                    authController.selected_province_town_city_options.value =
                        selectedProvinceCityData[value]!;
                    authController.town_city.value =
                        authController.selected_province_town_city_options[0];

                    // authController.filterCooperatives();
                  }
                } on Exception catch (e) {
                  log(e.toString());
                }
              },
              // key: GlobalKey<FormState>(),
              selectedItem: authController.selected_country.value,
              items: (filter, infiniteScrollProps) => africanCountries,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Select Resident Country',
                  labelStyle: const TextStyle(
                      color: blackOrignalColor,
                      fontSize: 22), // Black label text
                  // border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: recWhiteColor, // White background for input field
                ),
                baseStyle: const TextStyle(
                    color: blackOrignalColor,
                    fontSize: 18), // Black text for selected item
              ),
              popupProps: PopupProps.menu(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Select Resident Country'),
                ),
                itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item,
                      style: const TextStyle(
                          color: blackOrignalColor, fontSize: 18)),
                ),
                fit: FlexFit.loose,
                constraints: BoxConstraints(maxHeight: height * 0.5),
                menuProps: const MenuProps(
                  backgroundColor: whiteF5Color,
                  elevation: 4,
                ),
              ),
            )),
      ),
    );
  }

  nIDimageField() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => authController.nIDFile.value.path.isNotEmpty
            ? SizedBox(
                height: 120,
                width: width * 0.35,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      authController.nIDFile.value.readAsBytesSync(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : const SizedBox()),
        InkWell(
          onTap: () {
            authController.pickFileLocalStorage('nID');
          },
          child: Container(
              decoration: BoxDecoration(
                // color: recWhiteColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  const Center(
                    child: Icon(
                      Icons.upload_file,
                      size: 22,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.3,
                    child: AutoSizeText(
                      "NationalID/Passport",
                      style: semibold14Black,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }

  profileImageField() {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => authController.profileImageFile.value.path.isNotEmpty
            ? SizedBox(
                height: 120,
                width: width * 0.35,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      authController.profileImageFile.value.readAsBytesSync(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : const SizedBox()),
        InkWell(
          onTap: () {
            authController.pickFileLocalStorage('profileImage');
          },
          child: Container(
              width: width * 0.4,
              decoration: BoxDecoration(
                // color: recWhiteColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  const Center(
                    child: Icon(
                      Icons.upload_file,
                      size: 22,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.3,
                    child: AutoSizeText(
                      "Upload Profile Image",
                      style: semibold14Black,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }

  Widget account_type() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Obx(() => DropdownSearch<String>(
            onChanged: (value) => {
              authController.account_type.value = value!,
            },
            // key: dropDownKey,
            selectedItem: Utils.trimp(authController.account_type.value),
            items: (filter, infiniteScrollProps) =>
                authController.account_type_options,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: primaryColor), // Border color when focused
                  borderRadius: BorderRadius.circular(10.0),
                ),

                labelText: 'Select Appropriate Account Type',
                labelStyle: const TextStyle(
                    height: 10,
                    color: blackColor,
                    fontSize: 22), // Black label text
                // border: const OutlineInputBorder(),
                filled: true,
                fillColor: recWhiteColor, // White background for input field
              ),
              baseStyle: const TextStyle(
                  color: blackColor,
                  fontSize: 18), // Black text for selected item
            ),
            popupProps: PopupProps.menu(
              itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(Utils.trimp(item),
                    style: const TextStyle(color: blackColor, fontSize: 18)),
              ),
              fit: FlexFit.loose,
              constraints: const BoxConstraints(),
              menuProps: const MenuProps(
                backgroundColor: whiteF5Color,
                elevation: 4,
              ),
            ),
          )),
    );
  }

  goBackButton() {
    return GestureDetector(
      onTap: () {
        authController.addAuthData.value = false;
        authController.addAuthData.refresh();
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Iconify(
            Eva.arrow_ios_back_outline,
            color: primaryColor,
          ),
          Text(
            "Return back",
            style: semibold22Primary,
          ),
        ],
      ),
    );
  }

  service_provider_class() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Obx(() => DropdownSearch<String>(
              onChanged: (value) => {
                authController.specialization.value = value!,
              },
              // key: serviceProviderDropDownKey,
              selectedItem: authController.specialization.value,
              items: (filter, infiniteScrollProps) =>
                  authController.specialization_options,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,

                  labelText: 'Select Appropriate Account Type',
                  labelStyle: const TextStyle(
                      color: greyColor, fontSize: 22), // Black label text
                  // border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: recWhiteColor, // White background for input field
                ),
                baseStyle: const TextStyle(
                    color: greyColor,
                    fontSize: 18), // Black text for selected item
              ),
              popupProps: PopupProps.menu(
                itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item,
                      style: const TextStyle(color: greyColor, fontSize: 18)),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(),
                menuProps: const MenuProps(
                  backgroundColor: whiteF5Color,
                  elevation: 4,
                ),
              ),
            )),
      ),
    );
  }

  registerButton() {
    return GestureDetector(
      onTap: () {
        if (authController.addAuthData.value == false) {
          authController.addAuthData.value = true;
          authController.addAuthData.refresh();
        } else {
          // Handle case where account_type is not empty
          authController.addAuthData.value = false;
          authController.addAuthData.refresh();
          authController.registerUser();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: fixPadding * 1.4, horizontal: fixPadding * 2.0),
            width: width * 0.4,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10.0),
              // boxShadow: buttonShadow,
            ),
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Next",
                  style: bold18WhiteF5,
                ),
                Iconify(
                  Eva.chevron_right_outline,
                  color: whiteF5Color,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  emailField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: emailController,
        onChanged: (value) => {
          authController.email.value = value,
        },
        style: medium14Black,
        cursorColor: primaryColor,
        keyboardType: TextInputType.emailAddress,
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
          hintText: "Enter email address",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Iconify(
              Eva.email_outline,
              color: primaryColor,
              size: 22.0,
            ),
          ),
        ),
      ),
    );
  }

  passwordField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: passwordController,
        onChanged: (value) => {
          authController.password.value = value,
        },
        obscureText: true,
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
          hintText: "Enter password",
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
          authController.phoneNumber.value = value.completeNumber,
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

  userNameField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: firstNameController,
        onChanged: (value) => {
          authController.firstName.value = value,
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
          hintText: "First Name",
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

  lastNameField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: lastNameController,
        onChanged: (value) => {
          authController.lastName.value = value,
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
          hintText: "Last Name",
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

  registerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        heightSpace,
        Text(
          "Create your account below, fill all fields",
          style: semibold14Black,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  appLogo() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logo-nobg.png",
            height: 100.0,
          ),
        ],
      ),
    );
  }

  BoxDecoration bgBoxDecoration = BoxDecoration(
    border: Border(
        left: BorderSide(color: greyB5Color),
        right: BorderSide(color: greyB5Color),
        bottom: BorderSide(color: greyB5Color),
        top: BorderSide(color: greyB5Color)),
    color: whiteF5Color,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: recShadow,
  );
}
