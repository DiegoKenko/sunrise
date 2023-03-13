const int chatMessageLimit = 15;

enum EnumPaymentMethod { card, googlePay, applePay }

enum PaymentStatus { initial, loading, success, failure }

enum LobbyStatus {
  initial,
  loading,
  standBy,
  sucessReady,
  sucessNoReady,
  failureNoLobby,
  failureNoRoom,
}

enum MoodMatchingPack {
  defaultPack,
  silverPack,
  goldPack,
}

const stripePublicKey =
    'pk_test_51MjQvYJ4mdsV96FN5HNtLuIJSINqlcym3C5voqslR2bACLQ6lFV4czMPuGPxyZAbqgvwhJcrY8guPObs8znIQDbe00C3WY2L9U';
