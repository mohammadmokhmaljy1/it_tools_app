import 'dart:async';

import 'package:flutter/material.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class SectionHeaderWithTimer extends StatefulWidget {
  final String title;
  final DateTime? endsAt;

  const SectionHeaderWithTimer({
    super.key,
    this.title = 'عروض اليوم',
    this.endsAt,
  });

  @override
  State<SectionHeaderWithTimer> createState() => _SectionHeaderWithTimerState();
}

class _SectionHeaderWithTimerState extends State<SectionHeaderWithTimer> {
  Timer? _ticker;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    if (widget.endsAt != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(_updateRemaining);
      });
    }
  }

  void _updateRemaining() {
    if (widget.endsAt == null) {
      _remaining = Duration.zero;
      return;
    }
    final diff = widget.endsAt!.toLocal().difference(DateTime.now());
    _remaining = diff.isNegative ? Duration.zero : diff;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hours = _twoDigits(_remaining.inHours);
    final minutes = _twoDigits(_remaining.inMinutes.remainder(60));
    final seconds = _twoDigits(_remaining.inSeconds.remainder(60));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bolt_outlined,
                size: 22,
                color: AppColors.orange,
              ),
              const SizedBox(width: 6),
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: Color(0xFF02112C),
                ),
              ),
            ],
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TimeUnitBox(timeText: seconds),
                const SizedBox(width: 4),
                _TimeUnitBox(timeText: minutes),
                const SizedBox(width: 4),
                _TimeUnitBox(timeText: hours),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeUnitBox extends StatelessWidget {
  final String timeText;

  const _TimeUnitBox({required this.timeText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.navy900,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        timeText,
        style: AppTextStyles.labelMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          height: 1.0,
        ),
      ),
    );
  }
}
