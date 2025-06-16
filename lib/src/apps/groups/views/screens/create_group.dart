import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/bottom_bar.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/helper/helper_controller.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/brick/models/group.model.dart';
import 'package:mukai/src/controllers/group.controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CreateGroup extends StatefulWidget {
  // final List<Profile> acceptedUsers;
  CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _subscriptionController = TextEditingController();
  final _groupController = GroupController();
  final _storage = GetStorage();
  bool _isLoading = false;
  List<Map<String, dynamic>> acceptedProfiles = [];
  List<Profile> profiles = [];

  void _fetchData() async {
    final data = await _groupController.getAcceptedUsers();
    log('CreateGroup data: ${JsonEncoder.withIndent(' ').convert(data)}');
    try {
      setState(() {
        acceptedProfiles = data!;
        profiles = acceptedProfiles
            .map((profile) => Profile.fromMap(profile['profiles']))
            .toList();
      });
    } catch (e, s) {
      log('$e, $s');
    }
    log('CreateGroup data: ${JsonEncoder.withIndent(' ').convert(profiles.toString())}');
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _subscriptionController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final group = Group(
        name: _nameController.text.trim(),
        city: _cityController.text.trim(),
        country: _countryController.text.trim(),
        members: profiles,
        monthly_sub: double.parse(_subscriptionController.text.trim()),
        admin_id: _storage.read('userId'),
      );

      final response = await _groupController.createGroup(group);
      log('_createGroup response: $response');
      if (response['statusCode'] == 200) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(() => BottomBar(role: 'admin',));
      } else {
        Helper.errorSnackBar(
            title: 'Error', message: response['message'], duration: 5);
      }
      // Get.to(() => BottomBar(role: 'admin',));
      /*
      Get.snackbar(
        'Success',
        'Group created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      */
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create group: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteF5Color,
          ),
        ),
        centerTitle: false,
        titleSpacing: 20.0,
        toolbarHeight: 70.0,
        title: Text(
          Utils.trimp('Create Group'),
          style: bold18WhiteF5,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              groupNameField(),
              const SizedBox(height: 20),
              cityField(),
              const SizedBox(height: 20),
              countryField(),
              const SizedBox(height: 20),
              subscriptionField(),
              const SizedBox(height: 30),
              acceptedUsersListTile(),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Create Group',
                          style: bold16White,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget groupNameField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: _nameController,
        style: medium14Black,
        cursorColor: primaryColor,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a group name';
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
          hintText: "Group name",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Iconify(
              Ri.account_box_line,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget cityField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: _cityController,
        style: medium14Black,
        cursorColor: primaryColor,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a city';
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
          hintText: "City",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Iconify(
              Ri.map_pin_line,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget countryField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: _countryController,
        style: medium14Black,
        cursorColor: primaryColor,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a country';
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
          hintText: "Country",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Iconify(
              Ri.global_line,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget subscriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: recWhiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: _subscriptionController,
        style: medium14Black,
        cursorColor: primaryColor,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a subscription amount';
          }
          try {
            final amount = double.parse(value);
            if (amount <= 0) {
              return 'Amount must be greater than 0';
            }
          } catch (e) {
            return 'Please enter a valid number';
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: fixPadding * 1.5),
          hintText: "Monthly Subscription Amount",
          hintStyle: medium15Grey,
          prefixIconConstraints: BoxConstraints(maxWidth: 45.0),
          prefixIcon: Center(
            child: Iconify(
              Ri.money_dollar_circle_line,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget acceptedUsersListTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Accepted Members',
            style: bold16Black,
          ),
        ),
        if (profiles.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: Text('No members found')),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryColor.withOpacity(0.2),
                    child: Iconify(
                      Ri.user_3_line,
                      color: primaryColor,
                    ),
                  ),
                  title: Text(
                    profile.first_name ?? 'No name',
                    style: medium14Black,
                  ),
                  subtitle: Text(
                    profile.email ?? 'No email',
                    style: medium14Black,
                  ),
                  // Remove onTap if you don't want any interaction
                ),
              );
            },
          ),
      ],
    );
  }
}
