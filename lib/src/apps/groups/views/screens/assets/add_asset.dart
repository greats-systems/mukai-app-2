import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/data/repositories/asset_repository.dart';
import 'package:mukai/src/controllers/asset.controller.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/group.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAssetWidget extends StatefulWidget {
  Group? group;

  AddAssetWidget({
    super.key,
    this.group,
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
  AssetController get assetController =>
      Get.put(AssetController(Get.find<AssetRepository>()));
  late double height;
  late double width;
  Map<String, dynamic>? userJson = {};
  bool _isLoading = false;

  void setAssetProfileId() {
    final id = GetStorage().read('userId');
    setState(() {
      assetController.asset.value.profileId = id;
    });
  }

  @override
  void initState() {
    super.initState();
    setAssetProfileId();
    log('New asset profileId: ${assetController.asset.value.profileId}');
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
                ],
              ),
            ),
            // bottomNavigationBar: saveButton(context),
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
        onTap: () {
          // final id = GetStorage().read('userId');
          // log(widget.group!.id!);
          assetController.createIndividualAsset();
          // Navigator.pop(context);
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
                  "Save Individual Asset",
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
              assetController.asset.value.assetDescriptiveName = value;
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
              assetController.asset.value.assetDescription = value;
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
              try {
                assetController.asset.value.fiatValue = double.parse(value);
              } on Exception catch (e) {
                log(e.toString());
              }
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
                assetController.asset.value.category = value;
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

  BoxDecoration bgBoxDecoration = BoxDecoration(
    color: recColor,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: recShadow,
  );
}
