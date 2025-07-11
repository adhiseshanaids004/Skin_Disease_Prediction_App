import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/scan_result_model.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final List<ScanResult> historyList = [
    ScanResult(
      disease: 'Eczema',
      stage: 'Mild',
      description: 'A chronic condition causing skin inflammation.',
      remedy: 'Use moisturizing creams and ointments.',
      precautions: 'Avoid long showers and use gentle soap.',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ScanResult(
      disease: 'Psoriasis',
      stage: 'Moderate',
      description: 'A condition where skin builds up into scales.',
      remedy: 'Use topical steroids and phototherapy.',
      precautions: 'Avoid stress and alcohol.',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'scan_history'.tr(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: historyList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_toggle_off,
                    size: 64,
                    // ignore: deprecated_member_use
                    color: colors.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'no_history'.tr(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      // ignore: deprecated_member_use
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final result = historyList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            prediction: result.disease,
                            confidence: '${result.stage} case',
                            description: result.description,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                result.disease,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: colors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  result.stage,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${'date'.tr()}: ${_formatDate(result.date)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              // ignore: deprecated_member_use
                              color: colors.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
