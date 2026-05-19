import 'package:flutter/material.dart';
import '../../../core/models/paper_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/bookmark_service.dart';
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

  void _showBookmarksBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(Icons.bookmark_rounded, color: AppColors.primary),
                    SizedBox(width: 12),
                    Text(
                      'Bookmarked Papers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.headingText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ValueListenableBuilder<List<PaperModel>>(
                  valueListenable: BookmarkService().bookmarksNotifier,
                  builder: (context, bookmarks, _) {
                    if (bookmarks.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark_border_rounded,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No bookmarks yet.',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: bookmarks.length,
                      itemBuilder: (context, index) {
                        return PaperCard(paper: bookmarks[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              onBookmarkPressed: () => _showBookmarksBottomSheet(context),
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
