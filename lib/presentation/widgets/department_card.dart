import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/department_model.dart';
import '../pages/post_selection/post_selection_page.dart';

class DepartmentCard extends StatelessWidget {
  final DepartmentModel department;
  final bool isVertical;

  const DepartmentCard({
    super.key,
    required this.department,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostSelectionPage(department: department),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blueTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getIconData(department.iconCode), color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(department.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.headingText)),
                    Text('${department.paperCount} Papers',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Color(0xFFCBD5E1)),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostSelectionPage(department: department),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getIconData(department.iconCode), color: AppColors.primary, size: 32),
            const SizedBox(height: 12),
            Text(
              department.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${department.paperCount} Papers',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String code) {
    switch (code) {
      case 'account_balance': return Icons.account_balance_outlined;
      case 'construction': return Icons.construction_outlined;
      case 'monetization_on': return Icons.monetization_on_outlined;
      case 'school': return Icons.school_outlined;
      case 'police': return Icons.local_police_outlined;
      default: return Icons.folder_open_outlined;
    }
  }
}
