import 'package:flutter/foundation.dart';
import 'package:sunrise/constants/enum/enum_payment_options.dart';
import 'package:sunrise/interface/states/payment_state.dart';
import 'package:sunrise/services/iap/iap_connection.dart';
import 'package:sunrise/usecase/lover/lover_purchase_usecase.dart';

class PaymentScreenController extends ValueNotifier<PaymentState> {
  PaymentScreenController() : super(InitialPaymentState());
  IAPConnection iapConnection = IAPConnection();
  final LoverPurchaseUsecase loverPurchaseUsecase = LoverPurchaseUsecase();

  List<EnumPaymentOption> paymentOptions = EnumPaymentOption.values;
  ValueNotifier<int> paymentOptionsNotifier = ValueNotifier<int>(0);

  void changePaymentOption(EnumPaymentOption option) {
    paymentOptionsNotifier.value =
        paymentOptions.indexWhere((element) => element == option);
  }

  bool isPaymentSelected(int index) {
    return paymentOptionsNotifier.value == index;
  }

  Future<void> purchase(String loverId) async {
    final EnumPaymentOption option =
        paymentOptions[paymentOptionsNotifier.value];
    await iapConnection.purchase(option);
  }
}
