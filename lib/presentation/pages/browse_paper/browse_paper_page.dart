import 'package:flutter/material.dart';
import '../../../core/models/paper_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../home/widgets/department_section.dart';
import 'widgets/browse_paper_widgets.dart';
import 'widgets/paper_card.dart';

class BrowsePaperPage extends StatefulWidget {
  const BrowsePaperPage({super.key});

  @override
  State<BrowsePaperPage> createState() => _BrowsePaperPageState();
}

class _BrowsePaperPageState extends State<BrowsePaperPage> {
  final ApiService _apiService = ApiService();
  late Future<List<PaperModel>> _papersFuture;
  
  String _searchQuery = '';
  String? _selectedDept;
  String? _selectedYear;
  String? _selectedStage;

  @override
  void initState() {
    super.initState();
    _loadPapers();
  }

  void _loadPapers() {
    setState(() {
      _papersFuture = _apiService.searchPapers(
        _searchQuery,
        dept: _selectedDept,
        year: _selectedYear,
        stage: _selectedStage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          _loadPapers();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            SearchHeader(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _loadPapers();
              },
            ),
            const SizedBox(height: 16),
            FilterSection(
              onDeptChanged: (dept) {
                setState(() => _selectedDept = dept);
                _loadPapers();
              },
              onYearChanged: (year) {
                setState(() => _selectedYear = year);
                _loadPapers();
              },
              onStageChanged: (stage) {
                setState(() => _selectedStage = stage);
                _loadPapers();
              },
              onClear: () {
                setState(() {
                  _selectedDept = null;
                  _selectedYear = null;
                  _selectedStage = null;
                });
                _loadPapers();
              },
            ),
            const SizedBox(height: 32),
            FutureBuilder<List<PaperModel>>(
              future: _papersFuture,
              builder: (context, snapshot) {
                return ResultsHeader(count: snapshot.data?.length ?? 0);
              },
            ),
            const SizedBox(height: 16),
            _buildPaperList(),
            const SizedBox(height: 32),
            const PaginationFooter(),
            const SizedBox(height: 48),
            const DepartmentSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPaperList() {
    return FutureBuilder<List<PaperModel>>(
      future: _papersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Text('No papers match your criteria.'),
            ),
          );
        }

        final papers = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: papers.map((paper) => PaperCard(
              paper: paper,
            )).toList(),
          ),
        );
      },
    );
  }
}
