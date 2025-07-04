import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';
import 'package:mukai/brick/models/profile.model.dart';
import 'package:mukai/src/apps/transactions/controllers/transactions_controller.dart';
import 'package:mukai/src/apps/transactions/views/screens/qr_nfc_wallet_transfers.dart';
import 'package:mukai/theme/theme.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  TransactionController get transactionController =>
      Get.put(TransactionController());
  final GetStorage _getStorage = GetStorage();

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isFLashOn = false;
  String? userId;
  String? walletId;

  void _fetchData() async {
    final id = await _getStorage.read('userId');
    final wallet_id = await _getStorage.read('walletId');
    setState(() {
      userId = id;
      transactionController.transferTransaction.value.sending_wallet =
          wallet_id;
      transactionController.transferTransaction.refresh();
    });
    log('TransferToWalletWidget userId: $userId and wallet_id: $wallet_id');
  }

  void initState() {
    super.initState();
    _fetchData();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Adjust the radius as needed
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
          'Scan QR Code',
          style: medium18WhiteF5,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {
                                  isFLashOn = !isFLashOn;
                                });
                              },
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return isFLashOn == true
                                      ? Iconify(
                                          Ri.lightbulb_flash_fill,
                                          color: primaryColor,
                                        )
                                      : Iconify(
                                          Ri.flashlight_line,
                                          color: primaryColor,
                                        );
                                },
                              )),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.all(8),
                        //   child: ElevatedButton(
                        //       onPressed: () async {
                        //         await controller?.flipCamera();
                        //         setState(() {});
                        //       },
                        //       child: FutureBuilder(
                        //         future: controller?.getCameraInfo(),
                        //         builder: (context, snapshot) {
                        //           if (snapshot.data != null) {
                        //             return Text(
                        //                 'Camera facing ${describeEnum(snapshot.data!)}');
                        //           } else {
                        //             return const Text('loading');
                        //           }
                        //         },
                        //       )),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Container(
      decoration: BoxDecoration(
        color: whiteF5Color,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
        border: Border.all(
          color: whiteF5Color,
        ),
        boxShadow: boxShadow,
      ),
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        log('result!.code! ${result!.code!}');
        try {
          Profile? profile =
              await transactionController.getProfileByWalletID(result!.code!);
          if (profile != null) {
            transactionController.selectedProfile.value = profile;
            transactionController.transferTransaction.value.receiving_wallet =
                result!.code!;
            if (Platform.isAndroid) {
              controller.disposed = true;
              // setState(() {
              //   super.dispose();
              // });
            }
            Get.to(() => QrNfcWalletTransferScreen(
                  wallet_id: result!.code!,
                ));
          }
        } catch (error) {
          log('error ${error}');
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
