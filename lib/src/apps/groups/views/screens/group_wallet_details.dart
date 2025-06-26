import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/controllers/group.controller.dart';

class GroupWalletDetails extends StatefulWidget {
  const GroupWalletDetails({super.key});

  @override
  State<GroupWalletDetails> createState() => _GroupWalletDetailsState();
}

class _GroupWalletDetailsState extends State<GroupWalletDetails> {
  final GetStorage _getStorage = GetStorage();
  final GroupController _groupController = GroupController();
  Wallet? groupWallet;
  List<Wallet>? childrenWallets;
  String? userId;

  void _fetchGroupWallet() async {
    final user_id = await _getStorage.read('userId');
    setState(() {
      userId = user_id;
    });
    log('GroupWalletDetails userId: $userId');
    final wallet = await _groupController.getGroupWallet(user_id!);
    setState(() {
      groupWallet = wallet;
    });
    log('groupWallet id: ${groupWallet}');
  }

  @override
  void initState() {
    super.initState();
    _fetchGroupWallet();
    // _fetchChildrenWallets();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Wallet details'),
    );
  }
}
