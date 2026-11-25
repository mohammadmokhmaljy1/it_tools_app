class AppConfigEntity {
  final String storeName;
  final String storeAddress;
  final String storeHours;
  final String storePhone;
  final String storeMapUrl;
  final num sypPerUsd;
  final int sypRoundingStep;
  final String minAppVersion;
  final String latestAppVersion;
  final List<String> paymentMethods;
  final List<String> currencies;
  final int maxOpenOrders;
  final int pickupHoldDays;

  const AppConfigEntity({
    required this.storeName,
    required this.storeAddress,
    required this.storeHours,
    required this.storePhone,
    required this.storeMapUrl,
    required this.sypPerUsd,
    required this.sypRoundingStep,
    required this.minAppVersion,
    required this.latestAppVersion,
    required this.paymentMethods,
    required this.currencies,
    required this.maxOpenOrders,
    required this.pickupHoldDays,
  });
}
