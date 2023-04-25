enum EnumPaymentMethod { card, googlePay, applePay }

enum MoodMatchingPack {
  defaultPack,
  silverPack,
  goldPack,
}

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
