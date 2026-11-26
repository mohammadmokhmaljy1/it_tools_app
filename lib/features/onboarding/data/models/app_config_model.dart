import '../../domain/entities/app_config_entity.dart';

class AppConfigModel extends AppConfigEntity {
  const AppConfigModel({
    required super.storeName,
    required super.storeAddress,
    required super.storeHours,
    required super.storePhone,
    required super.storeMapUrl,
    required super.sypPerUsd,
    required super.sypRoundingStep,
    required super.minAppVersion,
    required super.latestAppVersion,
    required super.paymentMethods,
    required super.currencies,
    required super.maxOpenOrders,
    required super.pickupHoldDays,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    final store = (json['store'] as Map<String, dynamic>?) ?? const {};
    final exchangeRate =
        (json['exchangeRate'] as Map<String, dynamic>?) ?? const {};

    return AppConfigModel(
      storeName: store['name'] as String? ?? 'المحيط',
      storeAddress: store['address'] as String? ?? '',
      storeHours: store['hours'] as String? ?? '',
      storePhone: store['phone'] as String? ?? '',
      storeMapUrl: store['mapUrl'] as String? ?? '',
      sypPerUsd: exchangeRate['sypPerUsd'] as num? ?? 0,
      sypRoundingStep: (json['sypRoundingStep'] as num?)?.toInt() ?? 100,
      minAppVersion: json['minAppVersion'] as String? ?? '1.0.0',
      latestAppVersion: json['latestAppVersion'] as String? ?? '1.0.0',
      paymentMethods:
          (json['paymentMethods'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const ['cod'],
      currencies:
          (json['currencies'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const ['USD', 'SYP'],
      maxOpenOrders: (json['maxOpenOrders'] as num?)?.toInt() ?? 3,
      pickupHoldDays: (json['pickupHoldDays'] as num?)?.toInt() ?? 3,
    );
  }
}
