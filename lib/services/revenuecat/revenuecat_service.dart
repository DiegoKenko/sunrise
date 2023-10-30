import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  final pkRevenucat = 'goog_bGPxOYAZSdkIbOrHfwDlWdNERpL';
  RevenueCatService() {
    _initPlatformState();
  }

  Future<void> _initPlatformState() async {
    await Purchases.configure(PurchasesConfiguration(pkRevenucat));
  }

  Future<void> login(String userId) async {
    LogInResult logInResult = await Purchases.logIn(userId);
    if (kDebugMode) {
      print(logInResult.customerInfo.toString());
    }
  }

  Future<void> getOffering() async {
    Offerings offerings = await Purchases.getOfferings();
    if (kDebugMode) {
      print(offerings.toString());
    }
  }

  Future<void> purchase(Package package) async {
    CustomerInfo purchaserInfo = await Purchases.purchasePackage(package);
    if (kDebugMode) {
      print(purchaserInfo.toString());
    }
  }
}
