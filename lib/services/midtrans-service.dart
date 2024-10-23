import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart'; // Periksa nama package dan path yang benar

class MidtransService {
  static Future<MidtransSDK?> initializeSDK(
      BuildContext context, String clientKey) async {
    try {
      final midtrans = await MidtransSDK.init(
        config: MidtransConfig(
          clientKey: clientKey,
          merchantBaseUrl: "",
          colorTheme: ColorTheme(
            colorPrimary: Theme.of(context).colorScheme.secondary,
            colorPrimaryDark: Theme.of(context).colorScheme.secondary,
            colorSecondary: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );

      if (midtrans == null) {
        print('MidtransSDK initialization failed');
        return null;
      }

      print('MidtransSDK initialized successfully');

      midtrans.setUIKitCustomSetting(
        skipCustomerDetailsPages: true,
      );

      midtrans.setTransactionFinishedCallback((result) {
        print('Transaction Finished Callback: $result');
        MidtransService.showToast('Transaction Completed', false);
      });

      return midtrans;
    } catch (e) {
      print('Error initializing MidtransSDK: $e');
      MidtransService.showToast('SDK Initialization Failed', true);
      return null;
    }
  }

  static void showToast(String msg, bool isError) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
