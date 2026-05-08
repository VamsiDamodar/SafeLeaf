import 'package:flutter/material.dart';
import 'package:safeleaf/utils/app_colors.dart';

class PinKeypad extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback? onBiometricPressed;
  final bool showBiometricButton;
  final bool isCompact;

  const PinKeypad({
    super.key,
    required this.onNumberPressed,
    required this.onDeletePressed,
    this.onBiometricPressed,
    this.showBiometricButton = false,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = isCompact ? 16.0 : 18.0;
    final keypadWidth = isCompact ? 220.0 : 290.0;
    final deleteKeySize = isCompact ? 30.0 : 32.0;
    final biometricIconSize = isCompact ? 28.0 : 30.0;

    return Center(
      child: SizedBox(
        width: keypadWidth,
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: isCompact ? 6 : 8,
          crossAxisSpacing: isCompact ? 6 : 8,
          childAspectRatio: 1.0,
          children: [
            _buildNumberKey('1', '', fontSize),
            _buildNumberKey('2', 'ABC', fontSize),
            _buildNumberKey('3', 'DEF', fontSize),
            _buildNumberKey('4', 'GHI', fontSize),
            _buildNumberKey('5', 'JKL', fontSize),
            _buildNumberKey('6', 'MNO', fontSize),
            _buildNumberKey('7', 'PQRS', fontSize),
            _buildNumberKey('8', 'TUV', fontSize),
            _buildNumberKey('9', 'WXYZ', fontSize),
            showBiometricButton
                ? _buildBiometricKey(biometricIconSize)
                : const SizedBox(),
            _buildNumberKey('0', '', fontSize),
            _buildDeleteKey(deleteKeySize),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberKey(String number, String letters, double fontSize) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surfaceBorder,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onNumberPressed(number),
          borderRadius: BorderRadius.circular(12),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  number,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    height: 1,
                  ),
                ),
                if (letters.isNotEmpty) ...[
                  const SizedBox(height: 1),
                  Text(
                    letters,
                    style: TextStyle(
                      fontSize: fontSize * 0.35,
                      color: AppColors.accent,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricKey(double iconSize) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onBiometricPressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        child: Center(
          child: Icon(
            Icons.fingerprint_rounded,
            size: iconSize,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey(double fontSize) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onDeletePressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.accent.withValues(alpha: 0.1),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: fontSize,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}