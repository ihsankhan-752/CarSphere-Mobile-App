import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PostProgressBar extends StatelessWidget {
  final int currentStep;

  const PostProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    String stepTitle = '';
    if (currentStep == 0) {
      stepTitle = 'VISUAL ASSETS';
    } else if (currentStep == 1) {
      stepTitle = 'BASIC DETAILS';
    } else if (currentStep == 2) {
      stepTitle = 'SPECIFICATIONS';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Step ${currentStep + 1} of 3',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(stepTitle,
                  style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                      letterSpacing: 1.2)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: index <= currentStep
                        ? AppColors.primary
                        : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
