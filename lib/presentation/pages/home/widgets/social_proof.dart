import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SocialProof extends StatelessWidget {
  const SocialProof({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          width: 120,
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(3, (index) {
              return Positioned(
                left: index * 25.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    // Changed from .svg to .png as Flutter's NetworkImage doesn't support SVG directly
                    backgroundImage: NetworkImage(
                        'https://api.dicebear.com/7.x/avataaars/png?seed=${index + 12}'),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Joined by 1,000+ local aspirants',
          style: TextStyle(
              color: AppColors.bodyText,
              fontWeight: FontWeight.w600,
              fontSize: 13),
        ),
      ],
    );
  }
}
