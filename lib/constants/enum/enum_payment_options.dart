enum EnumPaymentOption {
  ten,
  twenty,
  fifty,
}

extension EnumPaymentOptionName on EnumPaymentOption {
  String get description {
    switch (this) {
      case EnumPaymentOption.ten:
        return '10';
      case EnumPaymentOption.twenty:
        return '20';
      case EnumPaymentOption.fifty:
        return '50';
      default:
        return '';
    }
  }
}
