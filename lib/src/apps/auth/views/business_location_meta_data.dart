import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/eva.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/render_supabase_image.dart';

class BusinessLocationMetaDataScreen extends StatelessWidget {
  BusinessLocationMetaDataScreen({super.key});
  AuthController get authController => Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final province_field_key = GlobalKey<DropdownSearchState>();
  final agritex_officer_key = GlobalKey<DropdownSearchState>();
  final district_key = GlobalKey<DropdownSearchState>();
  final town_city_key = GlobalKey<DropdownSearchState>();
  late double height;
  late double width;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: recColor,
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
                color: recColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(0.0),
                ),
                border: Border.all(
                  color: recColor,
                ),
                boxShadow: boxShadow,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(fixPadding * 2.0),
                children: [
                  heightBox(kToolbarHeight - 40),
                  appLogo(),
                  heightSpace,
                  heightSpace,
                  registerContent(),
                  height20Space,
                  province_field(),
                  height20Space,
                  district(),
                  height20Space,
                  town_cityField(),
                  heightSpace,
                ],
              ),
            ),
          )
        ],
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
              onChanged: (value) {
                if (value != null) {
                  authController.province.value = value;
                  // Find the province in the list and get its districts
                  var selectedProvinceData =
                      authController.province_options_with_districts.firstWhere(
                    (item) => item.keys.first == value,
                    orElse: () => {value: []},
                  );
                  var selectedProvinceCityData =
                      authController.province_options_with_districts.firstWhere(
                    (item) => item.keys.first == value,
                    orElse: () => {value: []},
                  );
                  authController.selected_province_districts_options.value =
                      selectedProvinceData[value]!;
                  authController.district.value =
                      authController.selected_province_districts_options[0];
                  // // //
                  authController.selected_province_town_city_options.value =
                      selectedProvinceCityData[value]!;
                  authController.town_city.value =
                      authController.selected_province_town_city_options[0];
                }
              },
              key: province_field_key,
              selectedItem: authController.province.value,
              items: (filter, infiniteScrollProps) =>
                  authController.province_options,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,

                  labelText: 'Select Province',
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
                  backgroundColor: recColor,
                  elevation: 4,
                ),
              ),
            )),
      ),
    );
  }

  district() {
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
              onChanged: (value) async => {
                authController.district.value = value!,
                await authController
                    .getAgritexOfficers(authController.district.value)
              },
              key: district_key,
              selectedItem: authController.district.value,
              items: (filter, infiniteScrollProps) =>
                  authController.selected_province_districts_options,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,

                  labelText: 'Select District',
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
                  backgroundColor: recColor,
                  elevation: 4,
                ),
              ),
            )),
      ),
    );
  }

  agritex_officer() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Obx(() {
          final selectedOfficer = authController.selected_agritex_officer.value;

          return DropdownSearch<Profile>(
            compareFn: (item1, item2) => item1.id == item2.id,
            onChanged: (value) {
              authController.selected_agritex_officer.value = value!;
            },
            key: agritex_officer_key,
            selectedItem: selectedOfficer,
            items: (filter, infiniteScrollProps) =>
                authController.agritex_officers,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Select Agritex Officer',
                labelStyle: const TextStyle(color: greyColor, fontSize: 22),
                filled: true,
                fillColor: recWhiteColor,
              ),
            ),
            dropdownBuilder: (context, selectedItem) {
              if (selectedItem == null) {
                return const Text(
                  'Select Agritex Officer',
                  style: TextStyle(color: greyColor),
                );
              }
              return Row(
                children: [
                  selectedItem.profile_image_url != null
                      ? SizedBox(
                          height: 35,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: RenderSupabaseImageIdWidget(
                              filePath: selectedItem.profile_image_url!,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.person_2_outlined,
                          size: 29.0,
                          color: whiteF5Color,
                        ),
                  width5Space,
                  Expanded(
                    child: Text(
                      selectedItem.first_name != null
                          ? '${Utils.trimp(selectedItem.first_name!)} ${Utils.trimp(selectedItem.last_name!)}'
                          : 'No name',
                      style: const TextStyle(
                        color: whiteF5Color,
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
                    item.profile_image_url != null
                        ? SizedBox(
                            height: 35,
                            width: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: RenderSupabaseImageIdWidget(
                                filePath: item.profile_image_url!,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person_2_outlined,
                            size: 29.0,
                            color: whiteF5Color,
                          ),
                    width5Space,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.first_name != null
                                ? '${Utils.trimp(item.first_name!)} ${Utils.trimp(item.last_name!)}'
                                : 'No name',
                            style: const TextStyle(
                              color: whiteF5Color,
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
                backgroundColor: recColor,
                elevation: 4,
              ),
            ),
          );
        }),
      ),
    );
  }

  goBackButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: width * 0.3,
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
              "Previous",
              style: bold18WhiteF5,
            ),
          ],
        ),
      ),
    );
  }

  registerButton() {
    return GestureDetector(
      onTap: () {
        authController.registerProvider();
      },
      child: Container(
        width: width * 0.3,
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
    );
  }

  totalArableField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          onChanged: (value) => {
            authController.farm_arable_land.value = value,
          },
          style: medium15White,
          cursorColor: primaryColor,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
            hintText: "Total Arable Land (Ha)",
            hintStyle: medium15Grey,
            prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
            prefixIcon: Center(
              child: Iconify(
                Bx.map_pin,
                color: primaryColor,
                size: 22.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  wardField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          onChanged: (value) => {
            authController.ward.value = value,
          },
          style: medium15White,
          cursorColor: primaryColor,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
            hintText: "Ward Number (optional)",
            hintStyle: medium15Grey,
            prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
            prefixIcon: Center(
              child: Icon(
                Icons.app_registration,
                color: primaryColor,
              ),
            ),
          ),
        ),
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
              },
              key: town_city_key,
              selectedItem: authController.town_city.value,
              items: (filter, infiniteScrollProps) =>
                  authController.selected_province_town_city_options,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,

                  labelText: 'Select Town/City',
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
                  backgroundColor: recColor,
                  elevation: 4,
                ),
              ),
            )),
      ),
    );
  }

  farmOwnershipField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          onChanged: (value) => {
            authController.password.value = value,
          },
          style: medium15White,
          cursorColor: primaryColor,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
            hintText: "Area under Irrigation",
            hintStyle: medium15Grey,
            prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
            prefixIcon: Center(
              child: Icon(
                Icons.area_chart_outlined,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  authorityField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 20,
        children: [
          SizedBox(
            width: width * 0.7,
            child: Container(
              decoration: BoxDecoration(
                // color: recWhiteColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const TextField(
                    readOnly: true,
                    maxLines: 2,
                    style: medium15White,
                    cursorColor: primaryColor,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: fixPadding * 1.5),
                      helperText:
                          'Document must be legal certified by deeds office/police/legal firm',
                      helperMaxLines: 3,
                      // helperStyle: medium15Grey,
                      hintText: "Land use legal document",
                      hintStyle: medium15Grey,
                      prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
                      prefixIcon: Center(
                        child: Icon(
                          Icons.document_scanner,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  imageField(),
                ],
              ),
            ),
          ),
          SizedBox(
            width: width * 0.1,
            child: Container(
                decoration: BoxDecoration(
                  // color: recWhiteColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  child: const Center(
                    child: Icon(
                      Icons.upload_file,
                      size: 62,
                      color: primaryColor,
                    ),
                  ),
                  onTap: () {
                    authController.pickFileLocalStorage('propertyOwnership');
                  },
                )),
          )
        ],
      ),
    );
  }

  imageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        Obx(() => authController.propertyOwnershipFile.value.path.isNotEmpty
            ? SizedBox(
                height: 120,
                width: width * 0.4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      authController.propertyOwnershipFile.value
                          .readAsBytesSync(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : const SizedBox()),
      ],
    );
  }

  mobileNumberField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
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
          style: medium15White,
          dropdownDecoration: const BoxDecoration(
            border: Border(
              right: BorderSide(color: greyColor, width: 2.0),
            ),
          ),
          pickerDialogStyle: PickerDialogStyle(backgroundColor: dialogBgColor),
          flagsButtonMargin: const EdgeInsets.symmetric(
              horizontal: fixPadding, vertical: fixPadding / 1.5),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
            hintText: "Enter your mobile number",
            hintStyle: medium15Grey,
          ),
        ),
      ),
    );
  }

  farmNameField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          onChanged: (value) => {
            authController.farm_name.value = value,
          },
          style: medium15White,
          cursorColor: primaryColor,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
            hintText: "Farm Name",
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
      ),
    );
  }

  farmSizeField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: recWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          onChanged: (value) => {
            authController.farm_size.value = value,
          },
          style: medium15White,
          cursorColor: primaryColor,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
            hintText: "Farm Size (Hectarage)",
            hintStyle: medium15Grey,
            prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
            prefixIcon: Center(
              child: Icon(
                Icons.zoom_in_map,
                color: primaryColor,
              ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            goBackButton(),
            Obx(() => authController.isLoading.value == true
                ? Column(
                    children: [
                      SizedBox(
                          width: width * 0.6,
                          child: const LinearProgressIndicator()),
                      Text(
                        "please wait ...",
                        style: semibold14LightWhite,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : registerButton()),
          ],
        ),
      ],
    );
  }

  appLogo() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/logo.png", height: 100.0, color: lightWhiteColor),
        ],
      ),
    );
  }

  BoxDecoration bgBoxDecoration = BoxDecoration(
    color: recColor,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: recShadow,
  );
}
