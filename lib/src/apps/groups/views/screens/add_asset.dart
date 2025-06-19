import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:mukai/brick/models/asset.model.dart';
import 'package:mukai/brick/models/group.model.dart';
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

class AddAssetWidget extends StatefulWidget {
Group? group;

   AddAssetWidget({
    super.key,
    required this.group,
  });

  @override
  State<AddAssetWidget> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<AddAssetWidget> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
  AssetController get assetController => Get.put(AssetController());
  late double height;
  late double width;
  Map<String, dynamic>? userJson = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }


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
              title: Text(
                "Add ${Utils.trimp(widget.group?.name ?? '')} Asset",
                style: semibold18WhiteF5,
              ),
            ),
            body: Container(
              color: whiteF5Color,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(fixPadding * 2.0),
                children: [
                  // heightBox(20),
                  // userProfileImage(size),
                  // heightBox(10),
                  heightBox(10),
                  assetTypeField(),
                  heightBox(10),
                  nameField(),
                  heightBox(10),
                  descriptionField(),
                  heightBox(10),
                  assetValueField(),
                  heightBox(20),
                  // const Text(
                  //   "Location Details",
                  //   style: semibold14Black,
                  // ),
                  // heightSpace,
                  // country_field(),
                  // heightBox(15),
                  // Obx(() => profileController.selectedProfile.value.country
                  //             ?.toLowerCase() ==
                  //         'zimbabwe'
                  //     ? province_field()
                  //     : cityField()),
                  // heightBox(10),
                  // Obx(() => profileController.selectedProfile.value.country
                  //             ?.toLowerCase() ==
                  //         'zimbabwe'
                  //     ? town_cityField()
                  //     : SizedBox()),
                  // heightBox(10),
        
                ],
              ),
            ),
            bottomNavigationBar: Obx(() => assetController.isLoading.value == true
                ? const LinearProgressIndicator(
                  minHeight: 1,
                    color: whiteColor,
                  )
                : saveButton(context)),
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
                      color: recColor, fontSize: 14), // Black label text
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

   saveButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () {

          assetController.createAsset(widget.group!.id!, null, 'group');
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
                  "Save Asset",
                  style: bold18White,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
      ),
    );
  }




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
            controller: firstNameController,
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
        () => assetController.selectedAsset.value?.imageUrl != null
            ? SizedBox(
                height: height * 0.2,
                width: width * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: RenderSupabaseImageIdWidget(
                    filePath: assetController.selectedAsset.value?.imageUrl ?? '',
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

  requestSummary(Profile asset) {
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
                    title: 'Membership Request',
                    middleText:
                        'Are you sure you want to accept ${asset.first_name ?? 'No name'.toUpperCase()} ${asset.last_name ?? 'No name'.toUpperCase()} Membership Request ID ${asset.id ?? 'No ID'.substring(0, 8)}?',
                    textConfirm: 'Yes, Accept',
                    confirmTextColor: whiteColor,
                    onConfirm: () async {
                      if (asset.id != null) {
                        await profileController.updateMemberRequest(
                            asset.id!, 'accepted');
                        // Get.to(() => AdminLandingScreen(role));
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
                        'Accept',
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
                      middleTextStyle:
                          TextStyle(color: blackColor, fontSize: 14),
                      buttonColor: primaryColor,
                      backgroundColor: tertiaryColor,
                      title: 'Membership Request',
                      middleText:
                          'Are you sure you want to decline ${asset.first_name!.toUpperCase()} ${asset.last_name!.toUpperCase()} Request ID ${asset.id!.substring(0, 8)}?',
                      textConfirm: 'Yes, Decline',
                      confirmTextColor: whiteColor,
                      onConfirm: () async {
                        await profileController.updateMemberRequest(
                            asset.id!, 'declined');
                        // Navigator.pop(context);
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
                          'Decline',
                          style: bold16White,
                        ),
                      ],
                    )),
              ),
            Container(
                alignment: Alignment(0, 0),
                height: height * 0.04,
                width: width * 0.25,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Text(
                      'Message',
                      style: bold16White,
                    ),
                  ],
                )),
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
