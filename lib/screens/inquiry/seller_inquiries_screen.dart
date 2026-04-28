import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SellerInquiriesScreen extends StatelessWidget {
  const SellerInquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for inquiries
    final inquiries = [
      {
        'buyerName': 'John Doe',
        'subject': 'Interested in Lamborghini Aventador',
        'date': 'Oct 24, 2023',
        'message': 'Hi, is the car still available? I would like to schedule a test drive this weekend.',
      },
      {
        'buyerName': 'Alice Smith',
        'subject': 'Price Negotiation for Porsche 911',
        'date': 'Oct 23, 2023',
        'message': 'Beautiful car! Are you open to negotiations? My budget is slightly lower.',
      },
      {
        'buyerName': 'Michael Johnson',
        'subject': 'Question about mileage',
        'date': 'Oct 21, 2023',
        'message': 'Could you confirm the exact mileage on the odometer?',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('All Inquiries',
            style: TextStyle(
                color: AppColors.backgroundDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Since it's a main tab
      ),
      body: inquiries.isEmpty
          ? const Center(
              child: Text(
                'No inquiries yet.',
                style: TextStyle(color: AppColors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: inquiries.length,
              itemBuilder: (context, index) {
                final inquiry = inquiries[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              inquiry['buyerName']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              inquiry['date']!,
                              style: const TextStyle(
                                  color: AppColors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          inquiry['subject']!,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          inquiry['message']!,
                          style: const TextStyle(
                              color: AppColors.backgroundDark, fontSize: 14),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle reply action
                            },
                            child: const Text('Reply'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
