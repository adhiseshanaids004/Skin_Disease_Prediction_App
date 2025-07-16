import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/firebase_service.dart';
import '../models/scan_result_model.dart';

class HealthSummary extends StatelessWidget {
  const HealthSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      stream: FirebaseService().getScanHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            children: [
              _buildLoadingStat(context),
              const SizedBox(width: 16),
              _buildLoadingStat(context),
            ],
          );
        }

        if (snapshot.hasError) {
          return Row(
            children: [
              _buildErrorStat(context),
              const SizedBox(width: 16),
              _buildErrorStat(context),
            ],
          );
        }

        final scanResults = snapshot.data ?? [];
        final totalScans = scanResults.length;
        final uniqueConditions = scanResults.map((result) => result.disease).toSet().length;

        return Row(
          children: [
            _buildStat(context, 'total_scans'.tr(), totalScans.toString()),
            const SizedBox(width: 16),
            _buildStat(context, 'conditions_found'.tr(), uniqueConditions.toString()),
          ],
        );
      },
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                // ignore: deprecated_member_use
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingStat(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const CircularProgressIndicator(
              strokeWidth: 2,
            ),
            const SizedBox(height: 4),
            Text(
              'loading'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                // ignore: deprecated_member_use
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorStat(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              'error_loading'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
