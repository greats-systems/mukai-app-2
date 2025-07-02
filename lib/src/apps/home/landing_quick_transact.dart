import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/apps/home/widgets/app_header.dart';
import 'package:mukai/src/controllers/auth.controller.dart';
import 'package:mukai/src/controllers/group.controller.dart';
import 'package:mukai/src/controllers/profile_controller.dart';
import 'package:mukai/src/controllers/wallet.controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:mukai/brick/models/wallet.model.dart';
import 'package:mukai/src/apps/home/qr_code.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/transfers.dart';
// import 'package:mukai/src/apps/chats/views/widgets/realtime_conversations_list.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LandingQuickTransactScreen extends StatefulWidget {
  const LandingQuickTransactScreen({super.key});

  @override
  State<LandingQuickTransactScreen> createState() =>
      _LandingQuickTransactScreenState();
}

class _LandingQuickTransactScreenState
    extends State<LandingQuickTransactScreen> {
  late double height;
  late double width;
  AuthController get authController => Get.put(AuthController());
  final autoSizeGroup = AutoSizeGroup();
  TransactionController get transactionController =>
      Get.put(TransactionController());
  final WalletController _walletController = WalletController();
  final ProfileController _profileController = ProfileController();
  final GetStorage _getStorage = GetStorage();

  // late List<Widget> membermanagerPages;
  String? userId;
  String? userRole;
  List<Wallet>? wallets;
  String? walletId;

  bool _isDisposed = false;
  bool _isLoading = false;
  final GroupController groupController = GroupController();
  List<Profile>? profiles = [];

  Future<void> fetchWalletID() async {
    var _Id = await _getStorage.read('userId');
    var _Role = await _getStorage.read('role');
    setState(() {
      _isLoading = true;
      userId = _Id;
      userRole = _Role;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWalletID();
    authController.getAccount();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Adjust the radius as needed
          ),
        ),
        backgroundColor: secondaryColor.withAlpha(50),
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0.0,
        toolbarHeight: 90.0,
        elevation: 0,
        title: Column(
          children: [
            const AppHeaderWidget(),
          ],
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
                // boxShadow: boxShadow,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(fixPadding * 2.0),
                children: [
                  //   groupDetails(),
                  // heightBox(20),
                  memberInitiateTrans()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  memberInitiateTrans() {
    return Column(
      children: [
        Column(
          children: [
            heightBox(20),
            Text('Scan QR-Code to Pay', style: bold16Black),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  children: [
                    QrImageView(
                      data: wallets?.first.id ?? 'No wallet ID 3',
                      version: QrVersions.auto,
                      size: 250.0,
                    ),
                    Text('${userId?.substring(24, 36)}')
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: width * 0.45,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  transactionController.selectedTransferOption.value = 'wallet';
                  transactionController.selectedTransferOption.refresh();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QRViewExample(),
                  ));
                  // Get.to(() => TransfersScreen(
                  //       category: 'wallet',
                  //     ));
                },
                child: Container(
                    alignment: Alignment(0, 0),
                    height: height * 0.05,
                    width: width * 0.9,
                    // padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/icons/mage_qr-code-fill.png",
                            height: 40,
                            color: whiteF5Color,
                          ),
                        ),
                        Text(
                          'Scan QR Code',
                          style: bold16White,
                        ),
                      ],
                    )),
              ),
              heightBox(20),
              Container(
                  alignment: Alignment(0, 0),
                  height: height * 0.05,
                  width: width * 0.9,
                  // padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                        "Use NFC Tap n' Pay",
                        style: bold16White,
                      ),
                    ],
                  )),
              heightBox(20),
              GestureDetector(
                onTap: () {
                  transactionController.selectedTransferOption.value =
                      'manual_wallet';
                  transactionController.selectedTransferOption.refresh();
                  transactionController.selectedProfile.value = Profile();
                  Get.to(() => TransfersScreen(
                        category: 'Direct Wallet',
                      ));
                },
                child: Container(
                    alignment: Alignment(0, 0),
                    height: height * 0.05,
                    width: width * 0.9,
                    // padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Text(
                          'Add Wallet Address',
                          style: bold16White,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
