
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GovernorateOption {
  final int id;
  final String name;

  const GovernorateOption({required this.id, required this.name});
}

class SavedAddress {
  final String id;
  final String label;
  final int governorateId;
  final String cityArea;
  final String details;
  final String recipientPhone;
  final bool isDefault;

  const SavedAddress({
    required this.id,
    required this.label,
    required this.governorateId,
    required this.cityArea,
    required this.details,
    required this.recipientPhone,
    this.isDefault = false,
  });

  String get formattedSummary {
    final parts = <String>[
      if (cityArea.trim().isNotEmpty) cityArea.trim(),
      if (details.trim().isNotEmpty) details.trim(),
      if (recipientPhone.trim().isNotEmpty) recipientPhone.trim(),
    ];
    return parts.join(' · ');
  }

  SavedAddress copyWith({
    String? id,
    String? label,
    int? governorateId,
    String? cityArea,
    String? details,
    String? recipientPhone,
    bool? isDefault,
  }) {
    return SavedAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      governorateId: governorateId ?? this.governorateId,
      cityArea: cityArea ?? this.cityArea,
      details: details ?? this.details,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  /// متطابق تماماً مع هيكلية قاعدة البيانات والـ Backend API
  Map<String, dynamic> toApiPayload() {
    return {
      'label': label,
      'governorateId': governorateId,
      'cityArea': cityArea,
      'details': details,
      'recipientPhone': recipientPhone,
      'isDefault': isDefault,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      ...toApiPayload(),
    };
  }

  factory SavedAddress.fromMap(Map<String, dynamic> map) {
    return SavedAddress(
      id: (map['id']?.toString()) ?? '',
      label: (map['label'] as String?) ?? '',
      governorateId: (map['governorateId'] as int?) ?? 1,
      cityArea: (map['cityArea'] as String?) ?? '',
      details: (map['details'] as String?) ?? '',
      recipientPhone: (map['recipientPhone'] as String?) ?? '',
      isDefault: (map['isDefault'] as bool?) ?? false,
    );
  }
}

class AddressesPage extends ConsumerStatefulWidget {
  const AddressesPage({super.key});

  @override
  ConsumerState<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends ConsumerState<AddressesPage> {
  static const String _storageKey = 'it_tools_saved_addresses_v2';

  static const List<GovernorateOption> _governorates = [
    GovernorateOption(id: 1, name: 'حلب'),
    GovernorateOption(id: 2, name: 'دمشق'),
    GovernorateOption(id: 3, name: 'ريف دمشق'),
    GovernorateOption(id: 4, name: 'حمص'),
    GovernorateOption(id: 5, name: 'حماة'),
    GovernorateOption(id: 6, name: 'اللاذقية'),
    GovernorateOption(id: 7, name: 'طرطوس'),
    GovernorateOption(id: 8, name: 'إدلب'),
  ];

  List<SavedAddress> _addresses = const [
    SavedAddress(
      id: '1',
      label: 'المنزل',
      governorateId: 1,
      cityArea: 'حلب - الفرقان',
      details: 'شارع الجامعة، بناء 12',
      recipientPhone: '0933123456',
      isDefault: true,
    ),
    SavedAddress(
      id: '2',
      label: 'السكن الجامعي',
      governorateId: 1,
      cityArea: 'حلب - المدينة الجامعية',
      details: 'الوحدة 7',
      recipientPhone: '0944123456',
      isDefault: false,
    ),
    SavedAddress(
      id: '3',
      label: 'بيت العائلة',
      governorateId: 4,
      cityArea: 'حمص - الإنشاءات',
      details: 'قرب جامع خالد',
      recipientPhone: '0933555888',
      isDefault: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final loaded = decoded
          .map((item) => SavedAddress.fromMap(item as Map<String, dynamic>))
          .toList();
      if (loaded.isNotEmpty && mounted) {
        setState(() {
          _addresses = loaded;
        });
      }
    } catch (e) {
      debugPrint('ADDRESSES LOAD ERROR: $e');
    }
  }

  Future<void> _saveAddresses(List<SavedAddress> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(list.map((e) => e.toMap()).toList()),
    );
  }

  Future<void> _selectDefaultAddress(String id) async {
    final updated = _addresses
        .map((addr) => addr.copyWith(isDefault: addr.id == id))
        .toList();
    setState(() {
      _addresses = updated;
    });
    await _saveAddresses(updated);
  }

  void _showAddAddressSheet(AppColors colors) {
    final formKey = GlobalKey<FormState>();
    final userPhone = ref.read(userProfileProvider).phone;

    const labelPresets = ['المنزل', 'السكن الجامعي', 'العمل', 'بيت العائلة'];
    String selectedPreset = 'المنزل';
    int selectedGovernorateId = 1;
    bool isDefault = true;

    final labelController = TextEditingController(text: selectedPreset);
    final cityAreaController = TextEditingController(text: 'حلب - ');
    final detailsController = TextEditingController();
    final phoneController = TextEditingController(text: userPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 14,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colors.borderStrong,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            icon: Icon(
                              Icons.close,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            'إضافة عنوان جديد',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // اختيارات سريعة لتسمية العنوان
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: labelPresets.map((preset) {
                            final isSelected = selectedPreset == preset;
                            return ChoiceChip(
                              label: Text(preset),
                              selected: isSelected,
                              selectedColor: colors.statusInfoBg,
                              backgroundColor: colors.bgSubtle,
                              side: BorderSide(
                                color: isSelected
                                    ? colors.brandBlue
                                    : colors.borderDefault,
                              ),
                              labelStyle: TextStyle(
                                fontSize: 12.5,
                                color: isSelected
                                    ? colors.brandBlue
                                    : colors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (_) {
                                setModalState(() {
                                  selectedPreset = preset;
                                  labelController.text = preset;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // حقل تسمية العنوان
                      TextFormField(
                        controller: labelController,
                        textAlign: TextAlign.right,
                        decoration: _sheetInputDecoration(
                          colors: colors,
                          label: 'تسمية العنوان (مثال: المنزل)',
                          icon: Icons.label_outline,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'الرجاء إدخال تسمية العنوان'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // المحافظة
                      DropdownButtonFormField<int>(
                        initialValue: selectedGovernorateId,
                        isExpanded: true,
                        decoration: _sheetInputDecoration(
                          colors: colors,
                          label: 'المحافظة',
                          icon: Icons.map_outlined,
                        ),
                        items: _governorates.map((gov) {
                          return DropdownMenuItem<int>(
                            value: gov.id,
                            alignment: AlignmentDirectional.centerEnd,
                            child: Text(
                              gov.name,
                              textAlign: TextAlign.right,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val == null) return;
                          final gov =
                              _governorates.firstWhere((g) => g.id == val);
                          setModalState(() {
                            selectedGovernorateId = val;
                            cityAreaController.text = '${gov.name} - ';
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // المدينة والمنطقة
                      TextFormField(
                        controller: cityAreaController,
                        textAlign: TextAlign.right,
                        decoration: _sheetInputDecoration(
                          colors: colors,
                          label: 'المدينة والحي (مثال: حلب - الفرقان)',
                          icon: Icons.location_city_outlined,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'الرجاء إدخال المدينة والمنطقة'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // تفاصيل العنوان
                      TextFormField(
                        controller: detailsController,
                        textAlign: TextAlign.right,
                        decoration: _sheetInputDecoration(
                          colors: colors,
                          label: 'تفاصيل العنوان (مثال: شارع الجامعة، بناء 12)',
                          icon: Icons.home_work_outlined,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'الرجاء إدخال تفاصيل الشارع والبناء'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // رقم المستلم
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.right,
                        decoration: _sheetInputDecoration(
                          colors: colors,
                          label: 'رقم هاتف المستلم (مثال: 0933123456)',
                          icon: Icons.phone_outlined,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'الرجاء إدخال رقم المستلم'
                            : null,
                      ),
                      const SizedBox(height: 8),

                      // تعيين كافتراضي
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        activeThumbColor: colors.brandBlue,
                        title: Text(
                          'تعيين كعنوان افتراضي',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        value: isDefault,
                        onChanged: (val) {
                          setModalState(() {
                            isDefault = val;
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          final newAddress = SavedAddress(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            label: labelController.text.trim(),
                            governorateId: selectedGovernorateId,
                            cityArea: cityAreaController.text.trim(),
                            details: detailsController.text.trim(),
                            recipientPhone: phoneController.text.trim(),
                            isDefault: isDefault,
                          );

                          debugPrint(
                            'NEW ADDRESS PAYLOAD: ${jsonEncode(newAddress.toApiPayload())}',
                          );

                          final updated = isDefault
                              ? [
                                  ..._addresses.map(
                                    (e) => e.copyWith(isDefault: false),
                                  ),
                                  newAddress,
                                ]
                              : [..._addresses, newAddress];

                          setState(() {
                            _addresses = updated;
                          });
                          await _saveAddresses(updated);

                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.actionPrimary,
                          foregroundColor: colors.textOnBrand,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'حفظ العنوان',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _sheetInputDecoration({
    required AppColors colors,
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      suffixIcon: Icon(
        icon,
        color: colors.textSecondary,
        size: 20,
      ),
      filled: true,
      fillColor: colors.bgSubtle,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.borderFocus,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.statusDanger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.statusDanger,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.bgPage,
      appBar: AppBar(
        backgroundColor: colors.bgPage,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'عناويني',
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.borderDefault),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: colors.textPrimary,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...List.generate(_addresses.length, (index) {
                final addr = _addresses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildAddressCard(addr, colors),
                );
              }),
              const SizedBox(height: 4),
              OutlinedButton.icon(
                onPressed: () => _showAddAddressSheet(colors),
                icon: Icon(
                  Icons.add,
                  color: colors.brandBlue,
                  size: 20,
                ),
                label: Text(
                  'إضافة عنوان جديد',
                  style: TextStyle(
                    color: colors.brandBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: colors.bgSubtle,
                  side: BorderSide(
                    color: colors.borderStrong,
                    width: 1.2,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colors.statusInfoBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'رسوم التوصيل تُحسب حسب المحافظة. الاستلام من المتجر في الجميلية مجاني دائماً.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: colors.brandBlue,
                          fontSize: 12.5,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.local_shipping_outlined,
                      color: colors.brandBlue,
                      size: 22,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(SavedAddress address, AppColors colors) {
    final isDefault = address.isDefault;

    return InkWell(
      onTap: () => _selectDefaultAddress(address.id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isDefault ? colors.bgSubtle : colors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDefault ? colors.brandBlue : colors.borderDefault,
            width: isDefault ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (isDefault) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                 color: colors.statusInfoBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'افتراضي',
                  style: TextStyle(
                    color: colors.brandBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    address.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.formattedSummary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDefault ? colors.bgSurface : colors.bgSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: isDefault ? colors.brandBlue : colors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDefault ? colors.brandBlue : colors.borderStrong,
                  width: 1.8,
                ),
              ),
              child: isDefault
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.brandBlue,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
