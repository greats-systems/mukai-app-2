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
import 'package:mukai/utils/utils.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  AuthController get authController => Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [profileImageField(), nIDimageField()],
                  ),
                  height20Space,
                  account_type(),
                  height5Space,
                  height5Space,
                  Obx(() =>
                      authController.account_type.value == 'Service Provider'
                          ? service_provider_class()
                          : const SizedBox()),
                  height20Space,
                  userNameField(),
                  height20Space,
                  lastNameField(),
                  height20Space,
                  emailField(),
                  height20Space,
                  passwordField(),
                  height20Space,
                  mobileNumberField(),
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
                      : registerButton()),
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
        // Get.to(() => RegisterFarmScreen());
        authController.registerUser();
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
