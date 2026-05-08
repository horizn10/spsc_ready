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
  List<String> _selectedDepts = [];
  List<String> _selectedYears = [];
  List<String> _selectedStages = [];
  List<String> _selectedPosts = [];

  int _currentPage = 1;
  static const int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _loadPapers();
  }

  void _loadPapers() {
    setState(() {
      _currentPage = 1; // Reset to first page on search/filter
      // Show all papers if no filters or search query are applied
      if (_searchQuery.isEmpty &&
          _selectedDepts.isEmpty &&
          _selectedYears.isEmpty &&
          _selectedStages.isEmpty &&
          _selectedPosts.isEmpty) {
        _papersFuture = _apiService.getAllPapers();
      } else {
        _papersFuture = _apiService.searchPapers(
          _searchQuery,
          depts: _selectedDepts,
          years: _selectedYears,
          stages: _selectedStages,
          postNames: _selectedPosts,
        );
      }
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
              onDeptsChanged: (depts) {
                setState(() => _selectedDepts = depts);
                _loadPapers();
              },
              onYearsChanged: (years) {
                setState(() => _selectedYears = years);
                _loadPapers();
              },
              onStagesChanged: (stages) {
                setState(() => _selectedStages = stages);
                _loadPapers();
              },
              onPostsChanged: (posts) {
                setState(() => _selectedPosts = posts);
                _loadPapers();
              },
              onClear: () {
                setState(() {
                  _selectedDepts = [];
                  _selectedYears = [];
                  _selectedStages = [];
                  _selectedPosts = [];
                });
                _loadPapers();
              },
            ),
            const SizedBox(height: 32),
            FutureBuilder<List<PaperModel>>(
              future: _papersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(60.0),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red)),
                    ),
                  );
                }

                final allPapers = snapshot.data ?? [];
                if (allPapers.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(60.0),
                      child: Text('No papers match your criteria.',
                          style: TextStyle(color: AppColors.bodyText, fontSize: 16)),
                    ),
                  );
                }

                final totalCount = allPapers.length;
                final totalPages = (totalCount / _itemsPerPage).ceil();
                
                // Ensure current page is within bounds after a filter change
                if (_currentPage > totalPages && totalPages > 0) {
                  _currentPage = totalPages;
                }

                final startIndex = (_currentPage - 1) * _itemsPerPage;
                final endIndex = (startIndex + _itemsPerPage < totalCount)
                    ? startIndex + _itemsPerPage
                    : totalCount;
                
                final currentCount = endIndex - startIndex;
                final displayedPapers = allPapers.sublist(startIndex, endIndex);

                return Column(
                  children: [
                    ResultsHeader(
                      currentCount: currentCount,
                      totalCount: totalCount,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: displayedPapers
                            .map((paper) => PaperCard(paper: paper))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    PaginationFooter(
                      currentPage: _currentPage,
                      totalPages: totalPages,
                      onPageChanged: (page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),
            const DepartmentSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
