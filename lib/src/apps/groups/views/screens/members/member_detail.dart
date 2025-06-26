import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/src/apps/chats/views/screen/conversation.dart';
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
import 'package:uuid/uuid.dart';

class MemberDetailScreen extends StatefulWidget {
  final Profile profile;
  final String? status;
  final String? groupId;
  final bool? isActive;

  const MemberDetailScreen({
    super.key,
    required this.profile,
    this.status,
    this.groupId,
    this.isActive,
  });

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  TextEditingController firstNameController = TextEditingController();
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
  late Profile profile;
  late double height;
  late double width;
  Map<String, dynamic>? userJson = {};
  bool _isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final json =
        await profileController.getMemberProfileByID(profile.id ?? 'No ID');
    if (json != null) {
      setState(() {
        userJson = json;
        _isLoading = false;
      });
    } else {
      setState(() {
        userJson = {'message': 'No data'};
        _isLoading = false;
      });
    }
    log('MemberDetailScreen userJson: ${userJson.toString()}');
  }

  @override
  void initState() {
    log('MemberDetailScreen member status: ${widget.profile.status}');
    profile = widget.profile;
    fetchData();
    // getProfile().then((value) {});
    super.initState();
  }

  void setDetails() {
    if (userJson != null) {
      firstNameController.text = userJson!['first_name'];
    }
  }

  void _navigateToConversation(Profile? profile) {
    Get.to(() => ConversationPage(
        firstName: _getFullName(profile),
        receiverId: profile?.id ?? Uuid().v4(),
        conversationId: Uuid().v4(),
        receiverFirstName: _getFirstName(profile),
        receiverLastName: profile?.last_name ?? ''));
  }

  String _getFullName(Profile? profile) {
    return '${Utils.trimp(profile?.first_name ?? '')} '
        '${Utils.trimp(profile?.last_name ?? '')}';
  }

  String _getFirstName(Profile? profile) {
    return Utils.trimp(profile?.first_name ?? '');
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
            appBar: appBar(),
            body: body(),
            bottomNavigationBar: bottomNavigationBar(),
          );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
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
        "${Utils.trimp(userJson?['first_name'] ?? 'No name in member detail')} ${Utils.trimp(userJson?['last_name'] ?? 'No name in member detail')} ",
        style: semibold18WhiteF5,
      ),
    );
  }

  Widget body() {
    final size = MediaQuery.sizeOf(context);
    return Container(
      color: whiteF5Color,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(fixPadding * 2.0),
        children: [
          userProfileImage(size),
          heightBox(10),
          heightBox(10),
          accountTypeField(),
          heightBox(10),
          nameField(),
          heightBox(10),
          lastNameField(),
          heightBox(10),
          emailField(),
          heightBox(20),
          mobileNumberField(),
          heightBox(20),
          const Text(
            "Location Details",
            style: semibold14Black,
          ),
          heightSpace,
          country_field(),
          heightBox(15),
          Obx(() =>
              profileController.selectedProfile.value.country?.toLowerCase() ==
                      'zimbabwe'
                  ? province_field()
                  : cityField()),
          heightBox(10),
          Obx(() =>
              profileController.selectedProfile.value.country?.toLowerCase() ==
                      'zimbabwe'
                  ? town_cityField()
                  : SizedBox()),
          heightBox(10),
          walletAddressField(),
          heightBox(10),
          monthlySubField(),
          heightBox(20),
          totalSubscriptionsPaidField(),
          heightBox(20),
          totalFinesIncurredField(),
          heightBox(10),
        ],
      ),
    );
  }

  Widget country_field() {
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
                  profileController.profile.value.country = value;
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

  Widget town_cityField() {
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

  Widget province_field() {
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
                  profileController.profile.value.province_state = value;
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

  Widget updateButton(BuildContext context) {
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

  Widget mobileNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mobile number",
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            style: semibold14Black,
            onChanged: (value) {
              profileController.profile.value.phone = value;
            },
            cursorColor: primaryColor,
            keyboardType: TextInputType.phone,
            controller: mobileNumberController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: userJson?['phone'] ?? 'No mobile number',
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  Widget bottomNavigationBar() {
    return profileController.selectedProfile.value == 'accepted'
        ? updateButton(context)
        : requestSummary(profile);
  }

  Widget emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contact Details",
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            style: semibold14Black,
            onChanged: (value) {
              profileController.profile.value.email = value;
            },
            cursorColor: primaryColor,
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: userJson?['email'] ?? 'No email',
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  Widget cityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        boxWidget(
          child: TextField(
            onChanged: (value) {
              profileController.profile.value.city = value;
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

  Widget nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'First name',
          style: semibold14Black,
        ),
        heightSpace,
        boxWidget(
          child: TextField(
            onChanged: (value) {
              profileController.profile.value.first_name = value;
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: firstNameController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: userJson?['first_name'] ?? 'No name in member detail',
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  Widget monthlySubField() {
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
              profileController.profile.value.first_name = value;
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

  Widget walletAddressField() {
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
              profileController.profile.value.first_name = value;
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

  Widget totalSubscriptionsPaidField() {
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
              profileController.profile.value.first_name = value;
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

  Widget totalFinesIncurredField() {
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
              profileController.profile.value.first_name = value;
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

  Widget lastNameField() {
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
              profileController.profile.value.last_name = value;
            },
            style: semibold14Black,
            cursorColor: primaryColor,
            keyboardType: TextInputType.name,
            controller: lastNameController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: userJson?['last_name'] ?? 'No name in member detail',
              hintStyle: semibold14Grey,
              contentPadding: EdgeInsets.all(fixPadding * 1.5),
            ),
          ),
        )
      ],
    );
  }

  Widget accountTypeField() {
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

  Widget boxWidget({required Widget child}) {
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

  Widget picInfo() {
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

  Widget userProfileImage(Size size) {
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
                          "Change profile Photo",
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

  Widget requestSummary(Profile profile) {
    final isActiveMember = widget.isActive ?? false;
    final isDeclinedStatus =
        profileController.selectedProfile.value.status == 'declined';

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
            // Show Accept button only if member is not active and not declined
            if (!isActiveMember && !isDeclinedStatus) ...[
              GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                    barrierDismissible: true,
                    middleTextStyle: TextStyle(color: blackColor, fontSize: 14),
                    buttonColor: primaryColor,
                    backgroundColor: tertiaryColor,
                    title: 'Membership Request',
                    middleText:
                        'Are you sure you want to accept ${profile.first_name ?? 'No name in member detail'.toUpperCase()} ${profile.last_name ?? 'No name in member detail'.toUpperCase()} Membership Request ID ${profile.id ?? 'No ID'.substring(0, 8)}?',
                    textConfirm: 'Yes, Accept',
                    confirmTextColor: whiteColor,
                    onConfirm: () async {
                      if (profile.id != null) {
                        final success = await updateMemberRequest(
                          profile.id!,
                          widget.groupId!,
                          'active',
                        );

                        if (success) {
                          Navigator.of(context, rootNavigator: true)
                              .pop(); // Close the dialog
                          Navigator.of(context).pop(
                              true); // Pop the MemberDetailScreen with a result
                        }
                      } else {
                        Helper.errorSnackBar(
                          title: 'Blank ID',
                          message: 'No ID was provided',
                          duration: 5,
                        );
                      }
                    },
                    cancelTextColor: redColor,
                    onCancel: () {
                      if (Get.isDialogOpen!) {
                        Get.back();
                      }
                    },
                  );
                },
                child: Container(
                    alignment: Alignment(0, 0),
                    height: height * 0.04,
                    width: width * 0.25,
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
            ],

            // Show Decline button only if member is not active and not declined
            if (!isActiveMember && !isDeclinedStatus) ...[
              GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                    middleTextStyle: TextStyle(color: blackColor, fontSize: 14),
                    buttonColor: primaryColor,
                    backgroundColor: tertiaryColor,
                    title: 'Membership Request',
                    middleText:
                        'Are you sure you want to decline ${profile.first_name!.toUpperCase()} ${profile.last_name!.toUpperCase()} Request ID ${profile.id!.substring(0, 8)}?',
                    textConfirm: 'Yes, Decline',
                    confirmTextColor: whiteColor,
                    onConfirm: () async {
                      final success = await updateMemberRequest(
                        profile.id!,
                        widget.groupId!,
                        'declined',
                      );

                      if (success) {
                        Navigator.of(context, rootNavigator: true)
                            .pop(); // Close the dialog
                        Navigator.of(context).pop(
                            true); // Pop the MemberDetailScreen with a result
                      }
                    },
                    cancelTextColor: redColor,
                    onCancel: () {
                      if (Get.isDialogOpen!) {
                        Get.back();
                      }
                    },
                  );
                },
                child: Container(
                    alignment: Alignment(0, 0),
                    height: height * 0.04,
                    width: width * 0.25,
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
            ],

            // Always show Message button
            ElevatedButton(
              onPressed: () => _navigateToConversation(widget.profile),
              child: Container(
                  alignment: Alignment(0, 0),
                  height: height * 0.04,
                  width: width * 0.5,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // spacing: 5,
                    children: [
                      Text(
                        'Message',
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

  Widget imageChangeOption(String icon, String title) {
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

  Future<bool> updateMemberRequest(
      String member_id, String group_id, String status) async {
    try {
      _isLoading = true;
      final dio = Dio();

      var coopRequestUpdateParams = {
        'status': status,
        'member_id': member_id,
        'cooperative_id': widget.groupId,
        'updated_at': DateTime.now().toIso8601String(),
      };

      var groupMemberParams = {
        'cooperative_id': widget.groupId,
        'member_id': member_id,
      };

      var profileParams = {'cooperative_id': widget.groupId, 'id': member_id};

      await dio.patch(
        '${EnvConstants.APP_API_ENDPOINT}/cooperative_member_requests/${widget.groupId}',
        data: coopRequestUpdateParams,
      );

      await dio.post(
        '${EnvConstants.APP_API_ENDPOINT}/group_members',
        data: groupMemberParams,
      );

      await dio.patch(
        '${EnvConstants.APP_API_ENDPOINT}/auth/update-account/$member_id',
        data: profileParams,
      );

      _isLoading = false;
      return true;
    } on DioException catch (error, st) {
      _isLoading = false;
      log('updateMemberRequest error: ${error.response.toString()}, ${st.toString()}');
      return false;
    }
  }

  BoxDecoration bgBoxDecoration = BoxDecoration(
    color: recColor,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: recShadow,
  );
}
