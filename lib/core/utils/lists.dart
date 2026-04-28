import 'package:flutter/material.dart';

import '../../data/models/onboarding_data.dart';
import '../constants/app_colors.dart';

List<OnboardingData> onBoardingPages = [
  OnboardingData(
    title: 'Find Your Dream Car',
    description:
        'Explore thousands of premium cars from trusted sellers and dealers worldwide.',
    image: "assets/images/o1.png",
    color: AppColors.primary,
  ),
  OnboardingData(
    title: 'Sell Your Car Easily',
    description:
        'List your car in minutes and get the best value from potential buyers.',
    image: "assets/images/o2.png",
    color: const Color(0xFF6C63FF),
  ),
  OnboardingData(
    title: 'Easy Communication',
    description:
        'Send formal inquiries or connect directly via Call and WhatsApp for quick deals.',
    image: "assets/images/o3.png",
    color: const Color(0xFF00BFA5),
  ),
];
