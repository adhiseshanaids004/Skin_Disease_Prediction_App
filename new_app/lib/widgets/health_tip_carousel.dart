import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';

class HealthTipCarousel extends StatelessWidget {
  const HealthTipCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Define tips directly here for simplicity
    final List<String> tips = [
      'health_tip_1'.tr(),
      'health_tip_2'.tr(),
      'health_tip_3'.tr(),
      'health_tip_4'.tr(),
      'health_tip_5'.tr(),
    ];

    if (tips.isEmpty || tips.any((tip) => tip.startsWith('health_tip_'))) {
      // If any tip is not translated, use default English tips
      return _buildDefaultTips(theme);
    }

    return _buildCarousel(theme, tips);
  }

  Widget _buildCarousel(ThemeData theme, List<String> tips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'health_tips'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 140,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.95,
            autoPlayInterval: const Duration(seconds: 5),
          ),
          items: tips.map((tip) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Text(
                    tip,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDefaultTips(ThemeData theme) {
    final defaultTips = [
      'Stay hydrated by drinking at least 8 glasses of water daily.',
      'Avoid excessive sun exposure to protect your skin.',
      'Use moisturizer daily for dry skin.',
      'Eat fruits and vegetables rich in Vitamin C.',
      'Don\'t skip sunscreen when going outside.'
    ];

    return _buildCarousel(theme, defaultTips);
  }
}
