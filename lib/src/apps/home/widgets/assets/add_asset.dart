import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/asset.model.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/data/repositories/asset_repository.dart';
import 'package:mukai/main.dart';
import 'package:mukai/src/controllers/asset.controller.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/group.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/constants/hardCodedCountries.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/loading_shimmer.dart';
import 'package:mukai/widget/render_supabase_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/bx.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';

class AddMemberAssetWidget extends StatefulWidget {
  AddMemberAssetWidget({
    super.key,
  });

  @override
  State<AddMemberAssetWidget> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<AddMemberAssetWidget> {
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
  AssetController get assetController =>
      Get.put(AssetController(Get.find<AssetRepository>()));
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
        ? Center(child: LoadingShimmerWidget())
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
                "Add ${Utils.trimp(profileController.profile.value.first_name ?? '')} ${Utils.trimp(profileController.profile.value.last_name ?? '')}'s Asset",
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
                ],
              ),
            ),
            bottomNavigationBar:
                Obx(() => assetController.isLoading.value == true
                    ? const LinearProgressIndicator(
                        minHeight: 1,
                        color: whiteColor,
                      )
                    : saveButton(context)),
          );
  }

  saveButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: GestureDetector(
        onTap: () async {
          GetStorage _getStorage = GetStorage();
          final userId = await _getStorage.read('userId');

          // assetController.createAsset(null, userId, 'profile');
          assetController.createAsset();
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
              assetController.asset.refresh();
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
              assetController.asset.refresh();
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
              assetController.asset.value?.fiatValue = double.tryParse(value);
              assetController.asset.refresh();
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.number,
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
            items: (filter, infiniteScrollProps) =>
                const ["Fixed", "Non-Fixed", "Other"],
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
                        // Get.back();
                        Navigator.pop(context);
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
