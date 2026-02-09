import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationDialog extends StatefulWidget {
  const DonationDialog({super.key});

  @override
  State<DonationDialog> createState() => _DonationDialogState();
}

class _DonationDialogState extends State<DonationDialog> {
  final String _saweriaLink = 'https://saweria.co/himisbah';
  final List<int> _donationAmounts = [10000, 25000, 50000, 100000];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dukung Pengembang',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Donasi Anda membantu pengembangan aplikasi iQran agar terus ditingkatkan dengan fitur-fitur baru dan peningkatan kualitas.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSecondaryContainer,
                      ),
                ),
              ),
              const SizedBox(height: 24),

              // Donation Amount Suggestions
              Text(
                'Saran Nominal Donasi:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _donationAmounts.map((amount) {
                  return Chip(
                    label: Text('Rp${amount ~/ 1000}K'),
                    backgroundColor: cs.surfaceContainer,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Payment Methods Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metode Pembayaran Tersedia:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '💳 Transfer Bank • 📲 QRIS • 💰 E-wallet (GoPay, OVO, DANA)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Donate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _openSaweria(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('🎁 Buka Halaman Donasi Saweria'),
                ),
              ),
              const SizedBox(height: 8),

              // Info Text
              Text(
                'Pilih nominal donasi di halaman Saweria, kemudian pilih metode pembayaran yang Anda inginkan.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openSaweria() async {
    try {
      final Uri url = Uri.parse(_saweriaLink);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tidak dapat membuka link donasi. Silakan coba lagi.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
          ),
        );
      }
    }
  }
}
