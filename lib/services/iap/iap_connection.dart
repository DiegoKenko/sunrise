import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sunrise/constants/enum/enum_payment_options.dart';

class IAPConnection {
  static InAppPurchase get instance {
    return InAppPurchase.instance;
  }

  Stream<List<PurchaseDetails>> get purchasesStream => instance.purchaseStream;

  Future<void> purchase(EnumPaymentOption option) async {
    await loadPurchases();
    await instance.buyConsumable(
      purchaseParam: PurchaseParam(
        productDetails: ProductDetails(
          id: option.id,
          title: option.name,
          description: option.description,
          price: option.price.toString(),
          rawPrice: option.price,
          currencyCode: '',
        ),
      ),
    );
  }

  Future<void> loadPurchases() async {
    final available = await instance.isAvailable();
    if (!available) {
      return;
    }
    Set<String> ids = EnumPaymentOption.values.map((e) => e.id).toSet();
    await instance.queryProductDetails(ids);
    /* for (var element in response.notFoundIDs) {}
    List<PurchasableProduct> products =
        response.productDetails.map((e) => PurchasableProduct(e)).toList(); */
  }
}
