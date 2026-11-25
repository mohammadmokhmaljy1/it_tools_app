
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brandBlue,
    required this.royalBlue,
    required this.navy700,
    required this.navy900,
    required this.sky,
    required this.orange,
    required this.ice,
    required this.bgPage,
    required this.bgSurface,
    required this.bgSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnBrand,
    required this.textOnAccent,
    required this.textLink,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderFocus,
    required this.actionPrimary,
    required this.actionPrimaryPressed,
    required this.actionAccent,
    required this.actionDisabled,
    required this.statusSuccess,
    required this.statusSuccessBg,
    required this.statusDanger,
    required this.statusDangerBg,
    required this.statusWarning,
    required this.statusWarningBg,
    required this.statusInfo,
    required this.statusInfoBg,
    required this.overlayScrim,
  });

  final Color brandBlue;
  final Color royalBlue;
  final Color navy700;
  final Color navy900;
  final Color sky;
  final Color orange;
  final Color ice;

  final Color bgPage;
  final Color bgSurface;
  final Color bgSubtle;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnBrand;
  final Color textOnAccent;
  final Color textLink;

  final Color borderDefault;
  final Color borderStrong;
  final Color borderFocus;

  final Color actionPrimary;
  final Color actionPrimaryPressed;
  final Color actionAccent;
  final Color actionDisabled;

  final Color statusSuccess;
  final Color statusSuccessBg;
  final Color statusDanger;
  final Color statusDangerBg;
  final Color statusWarning;
  final Color statusWarningBg;
  final Color statusInfo;
  final Color statusInfoBg;

  final Color overlayScrim;

  static const light = AppColors(
    brandBlue: Color(0xFF0578B7),
    royalBlue: Color(0xFF0543AE),
    navy700: Color(0xFF011755),
    navy900: Color(0xFF02112C),
    sky: Color(0xFF67A8DC),
    orange: Color(0xFFE39F25),
    ice: Color(0xFFD9F1FD),
    bgPage: Color(0xFFF4FBFF),
    bgSurface: Color(0xFFFFFFFF),
    bgSubtle: Color(0xFFEAF4FB),
    textPrimary: Color(0xFF02112C),
    textSecondary: Color(0xFF3D5D7D),
    textTertiary: Color(0xFF7D96AD),
    textOnBrand: Color(0xFFFFFFFF),
    textOnAccent: Color(0xFF02112C),
    textLink: Color(0xFF0578B7),
    borderDefault: Color(0xFFC7E2F2),
    borderStrong: Color(0xFF9CC3DD),
    borderFocus: Color(0xFF0578B7),
    actionPrimary: Color(0xFF0578B7),
    actionPrimaryPressed: Color(0xFF0543AE),
    actionAccent: Color(0xFFE39F25),
    actionDisabled: Color(0xFFC9D6E2),
    statusSuccess: Color(0xFF178A55),
    statusSuccessBg: Color(0xFFE3F5EC),
    statusDanger: Color(0xFFC93A3A),
    statusDangerBg: Color(0xFFFBE9E9),
    statusWarning: Color(0xFFB7780B),
    statusWarningBg: Color(0xFFFDF3E1),
    statusInfo: Color(0xFF0578B7),
    statusInfoBg: Color(0xFFE1F1FB),
    overlayScrim: Color(0xFF02112C),
  );

  static const dark = AppColors(
    brandBlue: Color(0xFF0D1B2F),
    royalBlue: Color(0xFF0D1B2F),
    navy700: Color(0xFF0D1B2F),
    navy900: Color(0xFF0D1B2F),
    sky: Color(0xFF0D1B2F),
    orange: Color(0xFF0D1B2F),
    ice: Color(0xFF0D1B2F),
    bgPage: Color(0xFF07111F),
    bgSurface: Color(0xFF0D1B2F),
    bgSubtle: Color(0xFF0D1B2F),
    textPrimary: Color(0xFF0D1B2F),
    textSecondary: Color(0xFF0D1B2F),
    textTertiary: Color(0xFF0D1B2F),
    textOnBrand: Color(0xFF0D1B2F),
    textOnAccent: Color(0xFF0D1B2F),
    textLink: Color(0xFF0D1B2F),
    borderDefault: Color(0xFF0D1B2F),
    borderStrong: Color(0xFF0D1B2F),
    borderFocus: Color(0xFF0D1B2F),
    actionPrimary: Color(0xFF0D1B2F),
    actionPrimaryPressed: Color(0xFF0D1B2F),
    actionAccent: Color(0xFF0D1B2F),
    actionDisabled: Color(0xFF0D1B2F),
    statusSuccess: Color(0xFF0D1B2F),
    statusSuccessBg: Color(0xFF0D1B2F),
    statusDanger: Color(0xFF0D1B2F),
    statusDangerBg: Color(0xFF0D1B2F),
    statusWarning: Color(0xFF0D1B2F),
    statusWarningBg: Color(0xFF0D1B2F),
    statusInfo: Color(0xFF0D1B2F),
    statusInfoBg: Color(0xFF0D1B2F),
    overlayScrim: Color(0xFF07111F),
  );

  @override
  AppColors copyWith({
    Color? brandBlue,
    Color? royalBlue,
    Color? navy700,
    Color? navy900,
    Color? sky,
    Color? orange,
    Color? ice,
    Color? bgPage,
    Color? bgSurface,
    Color? bgSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textOnBrand,
    Color? textOnAccent,
    Color? textLink,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderFocus,
    Color? actionPrimary,
    Color? actionPrimaryPressed,
    Color? actionAccent,
    Color? actionDisabled,
    Color? statusSuccess,
    Color? statusSuccessBg,
    Color? statusDanger,
    Color? statusDangerBg,
    Color? statusWarning,
    Color? statusWarningBg,
    Color? statusInfo,
    Color? statusInfoBg,
    Color? overlayScrim,
  }) {
    return AppColors(
      brandBlue: brandBlue ?? this.brandBlue,
      royalBlue: royalBlue ?? this.royalBlue,
      navy700: navy700 ?? this.navy700,
      navy900: navy900 ?? this.navy900,
      sky: sky ?? this.sky,
      orange: orange ?? this.orange,
      ice: ice ?? this.ice,
      bgPage: bgPage ?? this.bgPage,
      bgSurface: bgSurface ?? this.bgSurface,
      bgSubtle: bgSubtle ?? this.bgSubtle,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textOnBrand: textOnBrand ?? this.textOnBrand,
      textOnAccent: textOnAccent ?? this.textOnAccent,
      textLink: textLink ?? this.textLink,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      borderFocus: borderFocus ?? this.borderFocus,
      actionPrimary: actionPrimary ?? this.actionPrimary,
      actionPrimaryPressed:
          actionPrimaryPressed ?? this.actionPrimaryPressed,
      actionAccent: actionAccent ?? this.actionAccent,
      actionDisabled: actionDisabled ?? this.actionDisabled,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      statusSuccessBg: statusSuccessBg ?? this.statusSuccessBg,
      statusDanger: statusDanger ?? this.statusDanger,
      statusDangerBg: statusDangerBg ?? this.statusDangerBg,
      statusWarning: statusWarning ?? this.statusWarning,
      statusWarningBg: statusWarningBg ?? this.statusWarningBg,
      statusInfo: statusInfo ?? this.statusInfo,
      statusInfoBg: statusInfoBg ?? this.statusInfoBg,
      overlayScrim: overlayScrim ?? this.overlayScrim,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      brandBlue: Color.lerp(brandBlue, other.brandBlue, t)!,
      royalBlue: Color.lerp(royalBlue, other.royalBlue, t)!,
      navy700: Color.lerp(navy700, other.navy700, t)!,
      navy900: Color.lerp(navy900, other.navy900, t)!,
      sky: Color.lerp(sky, other.sky, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      ice: Color.lerp(ice, other.ice, t)!,
      bgPage: Color.lerp(bgPage, other.bgPage, t)!,
      bgSurface: Color.lerp(bgSurface, other.bgSurface, t)!,
      bgSubtle: Color.lerp(bgSubtle, other.bgSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textOnBrand: Color.lerp(textOnBrand, other.textOnBrand, t)!,
      textOnAccent: Color.lerp(textOnAccent, other.textOnAccent, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      actionPrimary: Color.lerp(actionPrimary, other.actionPrimary, t)!,
      actionPrimaryPressed:
          Color.lerp(actionPrimaryPressed, other.actionPrimaryPressed, t)!,
      actionAccent: Color.lerp(actionAccent, other.actionAccent, t)!,
      actionDisabled: Color.lerp(actionDisabled, other.actionDisabled, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      statusSuccessBg:
          Color.lerp(statusSuccessBg, other.statusSuccessBg, t)!,
      statusDanger: Color.lerp(statusDanger, other.statusDanger, t)!,
      statusDangerBg: Color.lerp(statusDangerBg, other.statusDangerBg, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusWarningBg:
          Color.lerp(statusWarningBg, other.statusWarningBg, t)!,
      statusInfo: Color.lerp(statusInfo, other.statusInfo, t)!,
      statusInfoBg: Color.lerp(statusInfoBg, other.statusInfoBg, t)!,
      overlayScrim: Color.lerp(overlayScrim, other.overlayScrim, t)!,
    );
  }
}
