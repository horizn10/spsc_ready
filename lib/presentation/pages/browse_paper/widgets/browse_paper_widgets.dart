import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SearchHeader extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onBookmarkPressed;

  const SearchHeader({super.key, this.onChanged, this.onBookmarkPressed});

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  hintText: 'Search post, paper, or year...',
                  hintStyle:
                      const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _controller.clear();
                            widget.onChanged?.call('');
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: widget.onBookmarkPressed,
            child: Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Icon(Icons.bookmark_outline, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterSection extends StatefulWidget {
  final ValueChanged<List<String>>? onDeptsChanged;
  final ValueChanged<List<String>>? onYearsChanged;
  final ValueChanged<List<String>>? onStagesChanged;
  final ValueChanged<List<String>>? onPostsChanged;
  final VoidCallback? onClear;

  const FilterSection({
    super.key,
    this.onDeptsChanged,
    this.onYearsChanged,
    this.onStagesChanged,
    this.onPostsChanged,
    this.onClear,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  List<String> _selectedDepts = [];
  List<String> _selectedYears = [];
  List<String> _selectedStages = [];
  List<String> _selectedPosts = [];

  void _clearFilters() {
    setState(() {
      _selectedDepts = [];
      _selectedYears = [];
      _selectedStages = [];
      _selectedPosts = [];
    });
    widget.onClear?.call();
  }

  void _toggleSelection(List<String> list, String value, ValueChanged<List<String>>? onChanged) {
    setState(() {
      if (list.contains(value)) {
        list.remove(value);
      } else {
        list.add(value);
      }
    });
    onChanged?.call(List.from(list));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          shape: const Border(),
          iconColor: AppColors.bodyText,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.blueTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune_rounded,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter Options',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.headingText)),
                  Text('DEPT, POST, YEAR, AND STAGE',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.bodyText,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppColors.border, height: 32),
                  _buildMultiSelectSection('DEPARTMENT', [
                    'Police Department',
                    'Multiple Departments',
                    'Power Department',
                    'Education Department',
                    'Forest and Environment Department'
                  ], _selectedDepts, (val) => _toggleSelection(_selectedDepts, val, widget.onDeptsChanged)),
                  const SizedBox(height: 20),
                  _buildMultiSelectSection('POST', [
                    'Under Secretary',
                    'Assistant Engineer',
                    'Accounts Officer',
                    'Statistical Inspector',
                    'Sub Inspector'
                  ], _selectedPosts, (val) => _toggleSelection(_selectedPosts, val, widget.onPostsChanged)),
                  const SizedBox(height: 20),
                  _buildMultiSelectSection('YEAR', [
                    '2024',
                    '2023',
                    '2022',
                    '2021',
                    '2020',
                    '2019',
                    '2018',
                    '2017',
                    '2016'
                  ], _selectedYears, (val) => _toggleSelection(_selectedYears, val, widget.onYearsChanged)),
                  const SizedBox(height: 20),
                  const Text('EXAM STAGE:',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A3B8))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStageCheckbox('Prelims', _selectedStages.contains('Prelims'), (val) {
                        _toggleSelection(_selectedStages, 'Prelims', widget.onStagesChanged);
                      }),
                      const SizedBox(width: 24),
                      _buildStageCheckbox('Mains', _selectedStages.contains('Mains'), (val) {
                        _toggleSelection(_selectedStages, 'Mains', widget.onStagesChanged);
                      }),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear All',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelectSection(String label, List<String> options, List<String> selectedValues, ValueChanged<String> onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8))),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValues.contains(option);
            return FilterChip(
              label: Text(option,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : AppColors.bodyText,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  )),
              selected: isSelected,
              onSelected: (_) => onToggle(option),
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              backgroundColor: const Color(0xFFF8FAFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStageCheckbox(String label, bool isSelected, ValueChanged<bool?> onChanged) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: isSelected,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.bodyText)),
        ],
      ),
    );
  }
}

class ResultsHeader extends StatelessWidget {
  final int currentCount;
  final int totalCount;
  
  const ResultsHeader({
    super.key, 
    this.currentCount = 0,
    this.totalCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Papers',
              style: TextStyle(
                  color: AppColors.headingText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Text('Showing $currentCount of $totalCount Papers',
              style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1)),
        ],
      ),
    );
  }
}

class PaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left Arrow Button
          _buildArrowButton(
            icon: Icons.chevron_left_rounded,
            onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          ),
          const SizedBox(width: 12),

          // ToggleButtons for Page Numbers
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ToggleButtons(
              isSelected: List.generate(totalPages, (index) => index + 1 == currentPage),
              onPressed: (index) => onPageChanged(index + 1),
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.white,
              fillColor: AppColors.primary,
              color: AppColors.headingText,
              constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
              renderBorder: false, // We use the container's border
              children: List.generate(totalPages, (index) {
                return Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }),
            ),
          ),

          const SizedBox(width: 12),
          // Right Arrow Button
          _buildArrowButton(
            icon: Icons.chevron_right_rounded,
            onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton({required IconData icon, VoidCallback? onPressed}) {
    final bool isDisabled = onPressed == null;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: isDisabled ? Colors.grey.shade300 : AppColors.primary,
        constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
