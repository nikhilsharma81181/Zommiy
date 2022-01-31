// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:foodla/Tools/encryption.dart';
// import 'package:foodla/models/restaurant_model.dart';
// import 'package:foodla/pages/Restaurant/restaurant_detail.dart';
// import 'package:provider/src/provider.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// // import 'package:qr_code_scanner/qr_code_scanner.dart';

// class Scanner extends StatefulWidget {
//   const Scanner({Key? key}) : super(key: key);

//   @override
//   _ScannerState createState() => _ScannerState();
// }

// class _ScannerState extends State<Scanner> {
//   Timer timer = Timer.periodic(const Duration(milliseconds: 0), (_) {});
//   AESEncryption encryption = AESEncryption();
//   String? scanResult;

//   @override
//   void initState() {
//     getQrData();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }

//   getQrData() {
//     scanCode();

//     timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
//       if (scanResult != null) {
//         var splitedData = scanResult!.split(' ');
//         var decodedData =
//             encryption.decryptData(encryption.getCode(splitedData[0]));
//         context
//             .read<RestaurantModel>()
//             .getRestaurantId(decodedData, splitedData[1]);
//         timer.cancel();
//       }
//     });
//   }

//   Future scanCode() async {
//     String scanResult;
//     try {
//       scanResult = await FlutterBarcodeScanner.scanBarcode(
//         '#495261',
//         'Cancel',
//         true,
//         ScanMode.QR,
//       );
//       // ignore: nullable_type_in_catch_clause
//     } on PlatformException {
//       scanResult = 'failed';
//     }
//     if (!mounted) return;

//     setState(() => this.scanResult = scanResult);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body:
//             scanResult != null ? const RestaurantDetails() : const SizedBox());
//   }

// // Stack(
// //         children: [
// //           RawMaterialButton(
// //             onPressed: () => scanCode(),
// //             child: const Text('asdfafds'),
// //           ),
// //           Text(scanResult.toString())

// //           // buildQrView(width),
// //         ],
// //       ),

// }

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:zommiy/Tools/encryption.dart';
import 'package:zommiy/Utils/utils.dart';
import 'package:zommiy/models/restaurant_model.dart';
import 'package:zommiy/pages/Restaurant/restaurant_detail.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  Timer timer = Timer.periodic(const Duration(milliseconds: 0), (_) {});
  Timer timer1 = Timer.periodic(const Duration(milliseconds: 0), (_) {});
  Timer timer2 = Timer.periodic(const Duration(milliseconds: 0), (_) {});
  AESEncryption encryption = AESEncryption();
  bool welcome = false;
  bool laser = false;

  @override
  void initState() {
    getQrData();
    super.initState();
  }

  getQrData() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (result != null) {
        var splitedData = result!.code.split(' ');
        var decodedData =
            encryption.decryptData(encryption.getCode(splitedData[0]));
        if (decodedData != '') {
          context
              .read<RestaurantModel>()
              .getRestaurantId(decodedData, splitedData[1]);
        }
        timer1 = Timer.periodic(const Duration(seconds: 2), (_) {
          setState(() {
            welcome = true;
            timer1.cancel();
          });
        });
        timer.cancel();
        timer2.cancel();
      }
    });
    timer2 = Timer.periodic(const Duration(milliseconds: 900), (_) {
      setState(() {
        laser ? laser = false : laser = true;
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: result == null
            ? Stack(
                children: [
                  QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Palate.primary,
                      borderRadius: 10,
                      borderLength: 40,
                      borderWidth: 10,
                      cutOutSize: width * 0.85,
                    ),
                  ),
                  Positioned(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: width * 0.85,
                        height: width * 0.85,
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 900),
                              height: laser ? width * 0.65 : width * 0.032,
                            ),
                            Container(
                              width: width,
                              height: width * 0.17,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      end: Alignment.topCenter,
                                      begin: Alignment.bottomCenter,
                                      colors: [
                                    Palate.primary.withOpacity(0),
                                    Palate.primary.withOpacity(0.3),
                                    Palate.primary.withOpacity(0.6),
                                    Palate.primary,
                                  ])),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: width,
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.32,
                            margin:
                                EdgeInsets.symmetric(vertical: width * 0.02),
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: width * 0.04),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black54,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      await controller?.toggleFlash();
                                      setState(() {});
                                    },
                                    child: FutureBuilder<bool?>(
                                        future: controller?.getFlashStatus(),
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            return Icon(
                                              snapshot.data!
                                                  ? Icons.flashlight_on_outlined
                                                  : Icons
                                                      .flashlight_off_outlined,
                                              color: Colors.white,
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        })),
                                const Icon(
                                  Icons.help_outline,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      result != null ? result!.code : 'scanncode',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : const RestaurantDetails());
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    timer.cancel();
    super.dispose();
  }
}
