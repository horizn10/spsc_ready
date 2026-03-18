import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SearchHeader extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const SearchHeader({super.key, this.onChanged});

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
          Container(
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
        ],
      ),
    );
  }
}

class FilterSection extends StatefulWidget {
  final ValueChanged<String?>? onDeptChanged;
  final ValueChanged<String?>? onYearChanged;
  final ValueChanged<String?>? onStageChanged;
  final VoidCallback? onClear;

  const FilterSection({
    super.key,
    this.onDeptChanged,
    this.onYearChanged,
    this.onStageChanged,
    this.onClear,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  String _selectedDept = 'All Departments';
  String _selectedYear = 'All Years';
  String? _selectedStage;

  void _clearFilters() {
    setState(() {
      _selectedDept = 'All Departments';
      _selectedYear = 'All Years';
      _selectedStage = null;
    });
    widget.onClear?.call();
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
                  Text('DEPARTMENT, YEAR, AND STAGE',
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
                children: [
                  const Divider(color: AppColors.border, height: 32),
                  _buildFilterDropdown('DEPARTMENT', _selectedDept, [
                    'All Departments',
                    'Personnel',
                    'Public Works',
                    'Finance',
                    'Education',
                    'Police Dept'
                  ], (val) {
                    setState(() => _selectedDept = val!);
                    widget.onDeptChanged?.call(val == 'All Departments' ? null : val);
                  }),
                  const SizedBox(height: 16),
                  _buildFilterDropdown('YEAR', _selectedYear, [
                    'All Years',
                    '2024',
                    '2023',
                    '2022',
                    '2021',
                    '2020'
                  ], (val) {
                    setState(() => _selectedYear = val!);
                    widget.onYearChanged?.call(val == 'All Years' ? null : val);
                  }),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('EXAM STAGE:',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8))),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _stageChip('Prelims', _selectedStage == 'Prelims', (label) {
                        setState(() => _selectedStage = _selectedStage == label ? null : label);
                        widget.onStageChanged?.call(_selectedStage);
                      }),
                      const SizedBox(width: 8),
                      _stageChip('Mains', _selectedStage == 'Mains', (label) {
                        setState(() => _selectedStage = _selectedStage == label ? null : label);
                        widget.onStageChanged?.call(_selectedStage);
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

  Widget _stageChip(String label, bool isSelected, ValueChanged<String> onSelected) {
    return FilterChip(
      label: Text(label, 
        style: TextStyle(
          fontSize: 12, 
          color: isSelected ? Colors.white : AppColors.bodyText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        )
      ),
      selected: isSelected,
      onSelected: (bool selected) => onSelected(label),
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF94A3B8)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14, color: Color(0xFF475569))),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class ResultsHeader extends StatelessWidget {
  final int count;
  const ResultsHeader({super.key, this.count = 0});

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
          Text('Showing $count Papers',
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
  const PaginationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Simplified for now as search is the main focus
  }
}
