import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:mukai/brick/models/asset.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/controllers/asset.controller.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/group.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/constants/hardCodedCountries.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/render_supabase_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';

class AssetDetailScreen extends StatefulWidget {
  final Asset asset;
  final String? status;

  const AssetDetailScreen({
    super.key,
    required this.asset,
    this.status,
  });

  @override
  State<AssetDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<AssetDetailScreen> {
    TextEditingController descriptionController = TextEditingController();
  TextEditingController fiatValueController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController walletAddressController = TextEditingController();
  TextEditingController monthlySubController = TextEditingController();
  TextEditingController totalSubsController = TextEditingController();
  TextEditingController totalFinesController = TextEditingController();
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
  AssetController get assetController => Get.put(AssetController());
  late double height;
  late double width;
  Map<String, dynamic>? userJson = {};
  bool _isLoading = false;



  @override
  void initState() {
    assetController.asset.value = widget.asset;
    // getProfile().then((value) {});
    setDetails();
    super.initState();
  }

  void setDetails() {
    if (userJson != null) {
      nameController.text = widget.asset.assetDescriptiveName ?? 'No name';
      descriptionController.text = widget.asset.assetDescription ?? 'No description';
      fiatValueController.text = widget.asset.fiatValue.toString();
    }
  }

  /*
  Future<void> getProfile() async {
    log(asset.id ?? 'No ID');
    log('Fetching data');
    // final jsonData = await fetchData();
    log('Done');
    // log('jsonData: ${JsonEncoder.withIndent(' ').convert(jsonData)}');
    profileController.selectedProfile.value = asset;
    profileController.asset.value = asset;
    profileController.asset.refresh();
    log(JsonEncoder.withIndent(' ')
        .convert(profileController.asset.value.toMap()));

    authController.selected_province.value =
        asset.province_state ?? 'no province';
    authController.selected_city.value = asset.id ?? 'no city';
    asset.country = asset.country ?? 'no country';

    nameController.text = asset.first_name ?? 'no name';
    lastNameController.text = asset.last_name ?? 'no name';
    accountTypeController.text = asset.account_type ?? 'no account type';
    emailController.text = asset.email ?? 'no email';
    mobileNumberController.text = asset.phone ?? 'no phone';
    cityController.text = asset.city ?? 'no city';
  }
  */

  @override
  Widget build(BuildContext context) {
    profileController.isLoading.value = false;
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.0), // Adjust the radius as needed
                ),
              ),
              elevation: 0,
              backgroundColor: primaryColor,
              titleSpacing: 0.0,
              centerTitle: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: whiteF5Color,
                ),
              ),
              title: Column(
                children: [
                  Text(
                    "${Utils.trimp(widget.asset.assetDescriptiveName ?? 'No name')}",
                    style: semibold18WhiteF5,
                  ),
                  Text(
                    "Asset ID: ${widget.asset.id?.substring(28, 36) ?? ''}",
                    style: semibold14WhiteF5,
                  ),
                ],
              ),
            ),
            body: Container(
              color: whiteF5Color,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(fixPadding * 2.0),
                children: [
                  heightBox(10),
                  assetTypeField(),
                  heightBox(10),
                  nameField(),
                  heightBox(10),
                  descriptionField(),
                  heightBox(10),
                  assetValueField(),
                  heightBox(20),
                ],
              ),
            ),
            bottomNavigationBar: requestSummary(widget.asset)
                // profileController.selectedProfile.value == 'accepted'
                //     ? updateButton(context)
                //     : ,
          );
  }
  nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asset name',
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              assetController.asset.value?.assetDescriptiveName = value;
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: nameController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter asset name',
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

    descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asset description',
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              assetController.asset.value?.assetDescription = value;
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            maxLines: 3,
            keyboardType: TextInputType.name,
            controller: descriptionController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter asset description',
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  monthlySubField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Monthly Sub",
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              assetController.asset.value?.purpose = value;
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: monthlySubController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  assetValueField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Asset Value",
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              assetController.asset.value?.fiatValue = double.parse(value);
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: fiatValueController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter asset market value or purchase price',
              hintStyle: semibold12Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  assetTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Asset Category",
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: DropdownSearch<String>(
                onChanged: (value) {
                  if (value != null) {
                    assetController.asset.value?.category = value;
                  }
                },
                selectedItem: "Fixed", // Default to Fixed
                items: (filter, infiniteScrollProps) => const ["Fixed", "Non-Fixed", "Other"],
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Select Asset Type',
                    hintStyle: semibold14Grey,
                    contentPadding: EdgeInsets.all(fixPadding * 1.5),
                  ),
                ),
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item, style: semibold14Black),
                  ),
                ),
              ),
        )
      ],
    );
  }
  country_field() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Obx(() => DropdownSearch<String>(
              onChanged: (value) {
                if (value != null) {
                  profileController.selectedProfile.value.country = value;
                  assetController.asset.value?.purpose = value;
                }
              },
              key: country_field_key,
              selectedItem: profileController.selectedProfile.value.country,
              items: (filter, infiniteScrollProps) => africanCountries,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,

                  labelText: 'Select Country',
                  labelStyle: const TextStyle(
                      color: recColor, fontSize: 22), // Black label text
                  // border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: recWhiteColor, // White background for input field
                ),
                baseStyle: const TextStyle(
                    color: recColor,
                    fontSize: 18), // Black text for selected item
              ),
              popupProps: PopupProps.menu(
                itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item,
                      style: const TextStyle(color: recColor, fontSize: 18)),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(),
                menuProps: const MenuProps(
                  backgroundColor: greyColor,
                  elevation: 4,
                ),
              ),
            )),
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
          color: whiteF5Color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Obx(() => DropdownSearch<String>(
              onChanged: (value) =>
                  {profileController.selectedProfile.value.city = value},
              key: town_city_key,
              selectedItem: profileController.selectedProfile.value.city,
              items: (filter, infiniteScrollProps) =>
                  authController.selected_province_town_city_options,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,

                  labelText: 'Select Town/City',
                  labelStyle: const TextStyle(
                      color: recColor, fontSize: 22), // Black label text
                  // border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: recWhiteColor, // White background for input field
                ),
                baseStyle: const TextStyle(
                    color: recColor,
                    fontSize: 18), // Black text for selected item
              ),
              popupProps: PopupProps.menu(
                itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item,
                      style: const TextStyle(color: recColor, fontSize: 18)),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(),
                menuProps: const MenuProps(
                  backgroundColor: greyColor,
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
          color: whiteF5Color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Obx(() => DropdownSearch<String>(
              onChanged: (value) {
                if (value != null) {
                  assetController.asset.value?.purpose = value;
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
              selectedItem: authController.selected_province.value,
              items: (filter, infiniteScrollProps) =>
                  authController.province_options,
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  border: InputBorder.none,

                  labelText: 'Select Province',
                  labelStyle: const TextStyle(
                      color: recColor, fontSize: 22), // Black label text
                  // border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: recWhiteColor, // White background for input field
                ),
                baseStyle: const TextStyle(
                    color: recColor,
                    fontSize: 18), // Black text for selected item
              ),
              popupProps: PopupProps.menu(
                itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item,
                      style: const TextStyle(color: recColor, fontSize: 18)),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(),
                menuProps: const MenuProps(
                  backgroundColor: greyColor,
                  elevation: 4,
                ),
              ),
            )),
      ),
    );
  }

  updateButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {
          profileController.updateUser();
          Navigator.pop(context);
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
                  "Update",
                  style: bold18White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
      ),
    );
  }



  /*
  mobileNumberField() {
    return Container(
      width: double.maxFinite,
      clipBehavior: Clip.hardEdge,
      decoration: bgBoxDecoration,
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IntlPhoneField(
          // focusNode: FocusNode(onKeyEvent: ),
          keyboardType: TextInputType.phone,
          onChanged: (value) => {
            profileController.asset.value.phone = value.completeNumber,
          },
          controller: mobileNumberController,
          disableLengthCheck: true,
          showCountryFlag: false,
          dropdownTextStyle: semibold14Black,
          initialCountryCode: "ZW",
          dropdownIconPosition: IconPosition.trailing,
          dropdownIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: blackOrignalColor,
          ),
          style: medium14Black,
          dropdownDecoration: const BoxDecoration(
            border: Border(
              right: BorderSide(color: blackOrignalColor, width: 2.0),
            ),
          ),
          pickerDialogStyle: PickerDialogStyle(backgroundColor: dialogBgColor),
          flagsButtonMargin: const EdgeInsets.symmetric(
              horizontal: fixPadding, vertical: fixPadding / 1.5),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
            hintText: "Enter your mobile number",
            hintStyle: medium14Black,
          ),
        ),
      ),
    );
  }
  */

  cityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        boxWidget(
          child: TextField(
            onChanged: (value) {
              assetController.asset.value?.purpose = value;
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: cityController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Enter City",
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }





  walletAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Wallet Address",
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              assetController.asset.value?.purpose = value;
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: walletAddressController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  totalSubscriptionsPaidField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Total subscriptions paid",
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              assetController.asset.value?.purpose = value;
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: totalSubsController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  totalFinesIncurredField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Total Fines incurred",
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              assetController.asset.value?.purpose = value;
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: totalFinesController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  lastNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Last Name",
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              assetController.asset.value?.purpose = value;
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: lastNameController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: userJson?['last_name'] ?? 'No name',
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  accountTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Account Type",
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            readOnly: true,
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: accountTypeController,
            decoration: InputDecoration(
              hintText: userJson?['account_type'] ?? 'No account type',
              hintStyle: medium14Black,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
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

  picInfo() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Obx(
        () => profileController.selectedProfile.value.profile_image_url != null
            ? SizedBox(
                height: height * 0.2,
                width: width * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: RenderSupabaseImageIdWidget(
                    filePath: profileController
                        .selectedProfile.value.profile_image_url!,
                  ),
                ),
              )
            : const Icon(
                Icons.person_2_rounded,
                color: blackOrignalColor,
              ));
  }

  userProfileImage(Size size) {
    return Center(
      child: Stack(
        children: [
          Center(
            child: picInfo(),
          ),
          Positioned(
            bottom: 0.0,
            left: 220.0,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: dialogBgColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(fixPadding * 2.0),
                      children: [
                        const Text(
                          "Change asset Photo",
                          style: semibold18White,
                        ),
                        heightSpace,
                        heightSpace,
                        height5Space,
                        imageChangeOption(Ph.camera_fill, "Camera"),
                        heightSpace,
                        heightSpace,
                        imageChangeOption(Ic.photo, "Gallery"),
                        heightSpace,
                        heightSpace,
                        imageChangeOption(Bx.bxs_trash, "Remove image"),
                      ],
                    );
                  },
                );
              },
              child: Container(
                height: size.height * 0.048,
                width: size.height * 0.048,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: recColor,
                  border: Border.all(color: whiteColor, width: 2.0),
                ),
                alignment: Alignment.center,
                child: Iconify(
                  Ph.camera,
                  color: whiteF5Color,
                  size: size.height * 0.03,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  requestSummary(Asset asset) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.fromLTRB(fixPadding * 2.0, fixPadding * 2.0,
          fixPadding * 2.0, fixPadding * 3.0),
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
      decoration: BoxDecoration(
        color: whiteF5Color,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: buttonShadow,
      ),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                    barrierDismissible: true,
                    middleTextStyle: TextStyle(color: blackColor, fontSize: 14),
                    buttonColor: primaryColor,
                    backgroundColor: tertiaryColor,
                    title: 'Update Asset',
                    middleText:
                        'Are you sure you want to update ${asset.assetDescriptiveName ?? 'No name'.toUpperCase()} ${asset.assetDescription ?? 'No name'.toUpperCase()} ${asset.id?.substring(28, 36) ?? ''}?',
                    textConfirm: 'Yes, Update',
                    confirmTextColor: whiteColor,
                    onConfirm: () async {
                      if (asset.id != null) {
                        await assetController.updateAsset(asset.id!);
                           Navigator.pop(context);
                        Get.back();
                      } else {
                        Helper.errorSnackBar(
                            title: 'Blank ID',
                            message: 'No ID was provided',
                            duration: 5);
                      }
                    },
                    cancelTextColor: redColor,
                    onCancel: () {
                      if (Get.isDialogOpen!) {
                        Get.back();
                      }
                    });
              },
              child: Container(
                  alignment: Alignment(0, 0),
                  height: height * 0.04,
                  width: width * 0.25,
                  // padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 1,
                    children: [
                      Text(
                        'Update',
                        style: bold16White,
                      ),
                    ],
                  )),
            ),
            if (profileController.selectedProfile.value.status == 'declined')
              SizedBox()
            else
              GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                      barrierDismissible: true,
                      middleTextStyle:
                          TextStyle(color: blackColor, fontSize: 14),
                      buttonColor: primaryColor,
                      backgroundColor: tertiaryColor,
                      title: 'Delete Asset',
                      middleText:
                          'Are you sure you want to delete ${asset.assetDescriptiveName!.toUpperCase()} ${asset.id?.substring(28, 36) ?? ''}?',
                      textConfirm: 'Yes, Delete',
                      confirmTextColor: whiteColor,
                      onConfirm: () async {
                        await assetController.deleteAsset(asset.id!);
                        Navigator.pop(context);
                        Navigator.pop(context);

                        // Navigator.pop(context);
                        // if (Get.isDialogOpen!) {
                        //   Get.back();
                        // }
                      },
                      cancelTextColor: redColor,
                      onCancel: () {
                        if (Get.isDialogOpen!) {
                          Get.back();
                        }
                      });
                },
                child: Container(
                    alignment: Alignment(0, 0),
                    height: height * 0.04,
                    width: width * 0.25,
                    // padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: redColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 1,
                      children: [
                        Text(
                          'Delete',
                          style: bold16White,
                        ),
                      ],
                    )),
              ),

          ],
        ),
      ),
    );
  }

  imageChangeOption(String icon, String title) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.pop(context);
        final User? user = supabase.auth.currentUser;
        profileController.selectProfile(title, user!.id);
      },
      child: Row(
        children: [
          Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dialogBgColor,
              boxShadow: [
                BoxShadow(
                  color: blackOrignalColor.withOpacity(0.25),
                  blurRadius: 5.0,
                )
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: whiteColor.withOpacity(0.1),
              ),
              alignment: Alignment.center,
              child: Iconify(
                icon,
                color: whiteColor,
                size: 23.0,
              ),
            ),
          ),
          widthSpace,
          widthSpace,
          Expanded(
            child: Text(
              title,
              style: semibold14Black,
            ),
          )
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
