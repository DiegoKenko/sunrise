enum EnumPaymentOption {
  ten,
  thirty,
  fifty,
}

extension EnumPaymentOptionName on EnumPaymentOption {
  String get description {
    switch (this) {
      case EnumPaymentOption.ten:
        return '10';
      case EnumPaymentOption.thirty:
        return '30';
      case EnumPaymentOption.fifty:
        return '50';
      default:
        return '';
    }
  }

  String get id {
    switch (this) {
      case EnumPaymentOption.ten:
        return 'suns10';
      case EnumPaymentOption.thirty:
        return 'suns30';
      case EnumPaymentOption.fifty:
        return 'suns50';
      default:
        return '';
    }
  }

  double get price {
    switch (this) {
      case EnumPaymentOption.ten:
        return 2.99;
      case EnumPaymentOption.thirty:
        return 7.99;
      case EnumPaymentOption.fifty:
        return 10.99;
      default:
        return 2.99;
    }
  }

  String get priceFormatted {
    return price.toStringAsFixed(2);
  }

  double get ammount {
    switch (this) {
      case EnumPaymentOption.ten:
        return 10;
      case EnumPaymentOption.thirty:
        return 30;
      case EnumPaymentOption.fifty:
        return 50;
      default:
        return 10;
    }
  }
}
