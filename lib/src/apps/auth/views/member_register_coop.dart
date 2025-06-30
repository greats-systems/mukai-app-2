import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/eva.dart';
import 'package:get/get.dart';
import 'package:mukai/brick/models/coop.model.dart';
import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

class MemberRegisterCoopScreen extends StatelessWidget {
  MemberRegisterCoopScreen({super.key});
  AuthController get authController => Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // final coops_field_key = GlobalKey<DropdownSearchState>();
  // final province_field_key = GlobalKey<DropdownSearchState>();
  // final agritex_officer_key = GlobalKey<DropdownSearchState>();
  // final district_key = GlobalKey<DropdownSearchState>();
  // final town_city_key = GlobalKey<DropdownSearchState>();
  late double height;
  late double width;
  final dropDownKey = GlobalKey<DropdownSearchState>();

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
                  heightBox(kToolbarHeight - 40),
                  appLogo(),
                  heightSpace,
                  heightSpace,
                  registerContent(),
                  height20Space,
                  cooperative_category(),
                  height20Space,
                  province_field(),
                  height20Space,
                  town_cityField(),
                  heightSpace,
                  coops_field()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  cooperative_category() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Obx(() => DropdownSearch<String>(
            onChanged: (value) => {
              authController.cooperative_category.value = value!,
              authController.filterCooperatives()
            },
            // key: GlobalKey<FormState>(),
            selectedItem:
                Utils.trimp(authController.cooperative_category.value),
            items: (filter, infiniteScrollProps) =>
                authController.cooperative_category_options,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: primaryColor), // Border color when focused
                  borderRadius: BorderRadius.circular(10.0),
                ),

                labelText: 'Select Cooperative Category',
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

                  authController.filterCooperatives();
                }
              },
              // key: GlobalKey<FormState>(),
              selectedItem: authController.province.value,
              items: (filter, infiniteScrollProps) =>
                  authController.province_options,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,

                  labelText: 'Select Province',
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

  coops_field() {
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
          final selectedCoop = authController.selected_coop.value;

          return DropdownSearch<Cooperative>(
            compareFn: (item1, item2) => item1 == item2,
            onChanged: (value) {
              log('selected_coop.value.name ${authController.selected_coop.value.name}');
              log('selected_coop.value.id ${authController.selected_coop.value.id}');
              authController.selected_coop.value = value!;
            },
            // key: GlobalKey<FormState>(),
            selectedItem: selectedCoop,
            items: (filter, infiniteScrollProps) =>
                authController.coops_options,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Select Cooperative',
                labelStyle: const TextStyle(color: blackColor, fontSize: 22),
                filled: true,
                fillColor: recWhiteColor,
              ),
            ),
            dropdownBuilder: (context, selectedItem) {
              if (selectedItem == null) {
                return const Text(
                  'Select Cooperative',
                  style: TextStyle(color: blackColor),
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedItem.name != null
                          ? '${Utils.trimp(selectedItem.name!)}'
                          : 'No name',
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
                                ? '${Utils.trimp(item.name!)}'
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

  goBackButton() {
    return GestureDetector(
      onTap: () {
        Get.to(() => BottomBar());
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Skip without a Coop",
            style: semibold22Primary,
          ),
          Iconify(
            Eva.arrow_ios_forward_fill,
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  registerButton() {
    return GestureDetector(
      onTap: () {
        authController.memberCoopRequest();
        // log(authController.userId.value);
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
                authController.filterCooperatives()
              },
              // key: town_city_key,
              selectedItem: authController.town_city.value,
              items: (filter, infiniteScrollProps) =>
                  authController.selected_province_town_city_options,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,

                  labelText: 'Select Town/City',
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

  registerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: width,
            child: AutoSizeText(
                style: TextStyle(fontStyle: FontStyle.italic),
                'Please choose the cooperative of choice or closest to your location. Note, the cooperative admin will be notified of your request to join and will choose to either accept or reject your request.')),
        heightSpace,
        Obx(() => authController.isLoading.value == true
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
                  registerButton(),
                ],
              )),
      ],
    );
  }

  nameField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        onChanged: (value) => {
          authController.cooperative_name.value = value,
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
          hintText: "Cooperative Name",
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

  appLogo() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo-nobg.png", height: 120.0),
          Text(
            'express your greatness',
            style:
                TextStyle(fontStyle: FontStyle.italic, color: secondaryColor),
          )
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
