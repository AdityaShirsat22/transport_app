import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../domain/transport_model.dart';

// ─── Recipient Types ──────────────────────────────────────────────────────────
enum _Recipient { customer, driver, office }

extension _RecipientExt on _Recipient {
  String get label {
    switch (this) {
      case _Recipient.customer:
        return 'Customer';
      case _Recipient.driver:
        return 'Driver';
      case _Recipient.office:
        return 'Office';
    }
  }

  IconData get icon {
    switch (this) {
      case _Recipient.customer:
        return Icons.person_outline;
      case _Recipient.driver:
        return Icons.local_shipping_outlined;
      case _Recipient.office:
        return Icons.business_outlined;
    }
  }
}

// ─── Format Types ─────────────────────────────────────────────────────────────
enum _Format { whatsapp, email }

// ─── Dialog ───────────────────────────────────────────────────────────────────
class NotificationPreviewDialog extends StatefulWidget {
  final Transport? transport;

  const NotificationPreviewDialog({super.key, this.transport});

  @override
  State<NotificationPreviewDialog> createState() =>
      _NotificationPreviewDialogState();
}

class _NotificationPreviewDialogState
    extends State<NotificationPreviewDialog> {
  _Recipient _recipient = _Recipient.customer;
  _Format _format = _Format.whatsapp;

  Transport? get t => widget.transport;

  // ── Message builders ──────────────────────────────────────────────────────

  String _whatsappMessage(_Recipient r) {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final cntr =
        (t?.containerNumber.isNotEmpty ?? false) ? t!.containerNumber : 'Pending';
    final seal =
        (t?.sealNumber.isNotEmpty ?? false) ? t!.sealNumber : 'Pending';

    switch (r) {
      case _Recipient.customer:
        return '''🚛 *TRANSLOGIX FLEET – BOOKING CONFIRMATION*
——————————————————

Dear *Customer*,
Your container transportation booking has been successfully confirmed and scheduled!

📋 *BOOKING SUMMARY:*
• *Booking No:* ${t?.bookingNumber ?? 'BK-2026-XXXX'}
• *Date:* $dateStr
• *Shipping Line:* ${t?.shippingLineName ?? 'N/A'}
• *Operation Type:* ${t?.shipmentType.label ?? 'Export'} (${t?.containerSize.label ?? '40ft'})
• *Container No:* $cntr
• *Seal No:* $seal

🗺️ *ROUTE DETAILS:*
• *From:* ${t?.fromLocationName ?? 'Origin'}
• *To:* ${t?.toLocationName ?? 'Destination'}
• *Port / CFS:* ${t?.portCfsName ?? 'N/A'}

🚚 *FLEET ASSIGNED:*
• *Vehicle:* ${t?.vehicleNumber ?? 'N/A'}
• *Driver:* ${t?.driverName ?? 'N/A'}
• *Driver Contact:* ${t?.driverMobile ?? 'N/A'}

_For queries, please reply to this message or contact our office._

*Thank you for choosing Translogix Fleet!* 🙏''';

      case _Recipient.driver:
        return '''🚛 *TRANSLOGIX FLEET – TRIP ASSIGNMENT*
——————————————————

Dear *${t?.driverName ?? 'Driver'}*,
You have been assigned a new transport trip. Please review the details below.

📋 *TRIP DETAILS:*
• *Booking No:* ${t?.bookingNumber ?? 'BK-2026-XXXX'}
• *Container No:* $cntr
• *Seal No:* $seal
• *Container Size:* ${t?.containerSize.label ?? '40ft'} – ${t?.shipmentType.label ?? 'Export'}

🗺️ *ROUTE:*
• *Pick-up (From):* ${t?.fromLocationName ?? 'Origin'}
• *Drop-off (To):* ${t?.toLocationName ?? 'Destination'}
• *Port / CFS:* ${t?.portCfsName ?? 'N/A'}

👤 *CUSTOMER:*
• ${t?.partyName ?? 'Customer Name'}

⚠️ _Ensure the vehicle is ready and report any issues immediately._

*Safe driving! – Translogix Fleet Operations* 🙏''';

      case _Recipient.office:
        return '''📋 *TRANSLOGIX FLEET – NEW BOOKING ALERT*
——————————————————

*Booking Created – Internal Reference*

• *Booking No:* ${t?.bookingNumber ?? 'BK-2026-XXXX'}
• *Customer:* ${t?.partyName ?? 'N/A'}
• *Booking Party:* ${t?.bookingPartyName ?? 'N/A'}
• *Shipping Line:* ${t?.shippingLineName ?? 'N/A'}
• *Operation:* ${t?.shipmentType.label ?? 'Export'} (${t?.containerSize.label ?? '40ft'})
• *Container No:* $cntr
• *Seal No:* $seal

🗺️ *ROUTE:*
• *From:* ${t?.fromLocationName ?? 'N/A'}
• *To:* ${t?.toLocationName ?? 'N/A'}
• *Port / CFS:* ${t?.portCfsName ?? 'N/A'}

🚚 *FLEET:*
• *Vehicle:* ${t?.vehicleNumber ?? 'N/A'}
• *Driver:* ${t?.driverName ?? 'N/A'} (${t?.driverMobile ?? 'N/A'})

_Please update the internal records accordingly._''';
    }
  }

  String _emailSubject(_Recipient r) {
    switch (r) {
      case _Recipient.customer:
        return 'Booking Confirmation – ${t?.bookingNumber ?? 'BK-2026-XXXX'}';
      case _Recipient.driver:
        return 'Trip Assignment – ${t?.bookingNumber ?? 'BK-2026-XXXX'}';
      case _Recipient.office:
        return 'New Booking Alert – ${t?.bookingNumber ?? 'BK-2026-XXXX'}';
    }
  }

  String _emailBody(_Recipient r) {
    // Plain-text email version (no markdown asterisks)
    return _whatsappMessage(r)
        .replaceAll('*', '')
        .replaceAll('——————————————————', '─' * 30)
        .replaceAll('🚛', '')
        .replaceAll('📋', '')
        .replaceAll('🗺️', '')
        .replaceAll('🚚', '')
        .replaceAll('👤', '')
        .replaceAll('⚠️', '')
        .replaceAll('🙏', '');
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _openWhatsApp(String message) async {
    final encoded = Uri.encodeComponent(message);

    // 1. Direct WhatsApp app deep-link without recipient:
    // Opens WhatsApp contact/chat selector so the sender chooses the recipient.
    final whatsappSchemeUri = Uri.parse('whatsapp://send?text=$encoded');
    // 2. Universal web link fallback without recipient:
    final waUniversalUri = Uri.parse('https://api.whatsapp.com/send?text=$encoded');

    try {
      if (await canLaunchUrl(whatsappSchemeUri)) {
        final launched = await launchUrl(whatsappSchemeUri, mode: LaunchMode.externalApplication);
        if (launched) return;
      }
    } catch (_) {}

    try {
      if (await canLaunchUrl(waUniversalUri)) {
        final launched = await launchUrl(waUniversalUri, mode: LaunchMode.externalApplication);
        if (launched) return;
      }
    } catch (_) {}

    // 3. Fallback to platform default browser/handler
    try {
      final launched = await launchUrl(waUniversalUri, mode: LaunchMode.platformDefault);
      if (launched) return;
    } catch (_) {}

    // 4. If WhatsApp / browser is not available, copy text and inform user
    if (mounted) {
      _copyText(message);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open WhatsApp. Message copied to clipboard!'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
    }
  }

  Future<void> _openEmail(String subject, String body) async {
    // Recipient is omitted so the sender can select or enter the receiver in their email app
    final uri = Uri(
      scheme: 'mailto',
      queryParameters: {'subject': subject, 'body': body},
    );

    try {
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(uri);
        if (launched) return;
      }
    } catch (_) {}

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (launched) return;
    } catch (_) {}

    if (mounted) {
      _copyText('Subject: $subject\n\n$body');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open Email app. Content copied to clipboard!'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
    }
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF25D366),
      ),
    );
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isWa = _format == _Format.whatsapp;
    final message = _whatsappMessage(_recipient);
    final subject = _emailSubject(_recipient);
    final body = _emailBody(_recipient);
    final screenH = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chat_rounded,
                      color: Color(0xFF25D366), size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'WhatsApp',
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 20),

            // ── SEND TO label ───────────────────────────────────────────
            Text(
              'SEND TO',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),

            // ── Recipient Tabs ──────────────────────────────────────────
            _RecipientSelector(
              selected: _recipient,
              onChanged: (r) => setState(() => _recipient = r),
            ),
            const SizedBox(height: 16),

            // ── Format Tabs ─────────────────────────────────────────────
            _FormatSelector(
              selected: _format,
              onChanged: (f) => setState(() => _format = f),
            ),
            const SizedBox(height: 14),

            // ── Message Preview ─────────────────────────────────────────
            Container(
              constraints: BoxConstraints(maxHeight: screenH * 0.35),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isWa
                    ? const Color(0xFFECF5E8)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isWa
                      ? const Color(0xFF25D366).withValues(alpha: 0.4)
                      : AppColors.border,
                ),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    isWa ? message : body,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.55,
                      fontFamily: 'monospace',
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Action Buttons ──────────────────────────────────────────
            if (isWa)
              _WhatsAppActions(
                onOpen: () => _openWhatsApp(message),
                onCopy: () => _copyText(message),
              )
            else
              _EmailActions(
                onOpen: () => _openEmail(subject, body),
                onCopy: () => _copyText('Subject: $subject\n\n$body'),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Recipient Selector ───────────────────────────────────────────────────────
class _RecipientSelector extends StatelessWidget {
  final _Recipient selected;
  final ValueChanged<_Recipient> onChanged;

  const _RecipientSelector(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: _Recipient.values.map((r) {
          final isSelected = r == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      r.icon,
                      size: 15,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        r.label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Format Selector ─────────────────────────────────────────────────────────
class _FormatSelector extends StatelessWidget {
  final _Format selected;
  final ValueChanged<_Format> onChanged;

  const _FormatSelector(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _FormatTab(
            icon: Icons.chat_rounded,
            label: 'WhatsApp Format',
            color: const Color(0xFF25D366),
            isSelected: selected == _Format.whatsapp,
            onTap: () => onChanged(_Format.whatsapp),
          ),
          _FormatTab(
            icon: Icons.email_outlined,
            label: 'Email Format',
            color: AppColors.accent,
            isSelected: selected == _Format.email,
            onTap: () => onChanged(_Format.email),
          ),
        ],
      ),
    );
  }
}

class _FormatTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatTab({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color:
                        isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── WhatsApp Action Row ──────────────────────────────────────────────────────
class _WhatsAppActions extends StatelessWidget {
  final VoidCallback onOpen;
  final VoidCallback onCopy;

  const _WhatsAppActions({required this.onOpen, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onOpen,
              icon: const Icon(Icons.chat_rounded, size: 18),
              label: const Text(
                'Open in WhatsApp',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onCopy,
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text(
              'Copy',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Email Action Row ─────────────────────────────────────────────────────────
class _EmailActions extends StatelessWidget {
  final VoidCallback onOpen;
  final VoidCallback onCopy;

  const _EmailActions({required this.onOpen, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onOpen,
              icon: const Icon(Icons.email_rounded, size: 18),
              label: const Text(
                'Open Email',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onCopy,
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text(
              'Copy',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}
