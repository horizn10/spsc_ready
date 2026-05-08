import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/department_model.dart';
import '../../../../core/services/api_service.dart';
import '../../../widgets/department_card.dart';

class DepartmentSection extends StatefulWidget {
  const DepartmentSection({super.key});

  @override
  State<DepartmentSection> createState() => _DepartmentSectionState();
}

class _DepartmentSectionState extends State<DepartmentSection> {
  final ApiService _apiService = ApiService();
  late Future<List<DepartmentModel>> _departmentsFuture;

  @override
  void initState() {
    super.initState();
    _departmentsFuture = _apiService.getDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DepartmentModel>>(
      future: _departmentsFuture,
      builder: (context, snapshot) {
        final departments = snapshot.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Browse by Department',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.headingText,
                    ),
                  ),
                  if (departments != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${departments.length} Departments',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (snapshot.connectionState == ConnectionState.waiting)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (snapshot.hasError)
              Center(child: Text('Error: ${snapshot.error}'))
            else if (departments == null || departments.isEmpty)
              const Center(child: Text('No departments found.'))
            else
              SizedBox(
                height: 280, // Height for two rows of folders
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 Rows
                    mainAxisSpacing: 16, // Horizontal spacing between folders
                    crossAxisSpacing: 16, // Vertical spacing between rows
                    childAspectRatio: 0.75, // Wider cards to ensure 2x2 grid fits well with a peek of the 3rd
                  ),
                  // Ensure we have enough slots for the 2xN grid
                  itemCount: ((departments.length + 1) ~/ 2) * 2,
                  itemBuilder: (context, index) {
                    const int rows = 2;
                    final int columns = (departments.length + rows - 1) ~/ rows;
                    
                    // Logic to display items side-by-side (Row-major)
                    // This maps index 0,1,2,3... to fill Top Row first, then Bottom Row
                    final int gridRow = index % rows;
                    final int gridCol = index ~/ rows;
                    final int departmentIndex = (gridRow * columns) + gridCol;

                    if (departmentIndex >= departments.length) {
                      return const SizedBox.shrink();
                    }
                    
                    return DepartmentCard(department: departments[departmentIndex]);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
