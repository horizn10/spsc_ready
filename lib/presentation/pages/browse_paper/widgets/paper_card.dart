import 'package:flutter/material.dart';
import '../../../../core/models/paper_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../../pdf_viewer/pdf_viewer_page.dart';

class PaperCard extends StatefulWidget {
  final PaperModel paper;

  const PaperCard({super.key, required this.paper});

  @override
  State<PaperCard> createState() => _PaperCardState();
}

class _PaperCardState extends State<PaperCard> {
  bool _isLoadingPdf = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year and Stage Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.blueTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.paper.year,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                widget.paper.examStage.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Top Bold: Post Name
          Text(
            widget.paper.postName,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: AppColors.headingText,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),

          // Sub Heading: Paper Name
          Text(
            "Paper Name: ${widget.paper.paperName.isNotEmpty ? widget.paper.paperName : 'General Paper'}",
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Details Section
          _buildDetailRow('Exam Name:', widget.paper.examName),
          _buildDetailRow('Department:', widget.paper.department.isNotEmpty ? widget.paper.department : 'General'),

          const SizedBox(height: 20),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),

          // Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (_isLoadingPdf) return; // Prevent double-tap
                  setState(() => _isLoadingPdf = true);

                  try {
                    final apiService = ApiService();
                    final pdfUrl = await apiService.getPdfUrl(widget.paper.id);

                    if (!mounted) return;
                    setState(() => _isLoadingPdf = false);

                    if (pdfUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not load PDF. Please try again.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewerPage(
                          paper: widget.paper,
                          pdfUrl: pdfUrl, // Pass the freshly fetched URL
                        ),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    setState(() => _isLoadingPdf = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                    );
                  }
                },
                child: _isLoadingPdf
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('View Paper',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 14),
                        ],
                      ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border_rounded,
                    color: Color(0xFF64748B), size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: AppColors.bodyText),
          children: [
            TextSpan(text: '$label '),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.headingText),
            ),
          ],
        ),
      ),
    );
  }
}
