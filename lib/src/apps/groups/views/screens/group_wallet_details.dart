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

  // void _fetchChildrenWallets() async {
  //   final childrenWallets =
  //       await _groupController.getChildrenWallets(groupWallet?.id ?? 'gg');
  // }

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
  /*
  Widget _buildParentWalletDetails(Wallet wallet) {
    Card(
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$carrierCode$flightNumber',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text(cabinClass ?? ""),
                      backgroundColor: Colors.blue[50],
                    ),
                  ],
                ),
                MySizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From', style: TextStyle(color: Colors.grey)),
                        Text(constants.returnLocation(departure['iataCode'])),
                        Text(constants.formatDateTime(departure['at'])),
                        if (departure['terminal'] != null)
                          Text('Terminal ${departure['terminal']}'),
                      ],
                    ),
                    Icon(Icons.airplanemode_active, size: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('To', style: TextStyle(color: Colors.grey)),
                        Text(constants.returnLocation(arrival['iataCode'])),
                        Text(constants.formatDateTime(arrival['at'])),
                        if (arrival['terminal'] != null)
                          Text('Terminal ${arrival['terminal']}'),
                      ],
                    ),
                  ],
                ),
                MySizedBox(height: 8),
                Text(
                  'Duration: ${constants.calculateDuration(departure['at'], arrival['at'])}',
                ),
                Text('Aircraft: $aircraft'),
              ],
            ),
          ),
        );
  }
  */
}
