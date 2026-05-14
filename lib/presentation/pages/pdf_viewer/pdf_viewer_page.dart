import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/paper_model.dart';

class PdfViewerPage extends StatefulWidget {
  final PaperModel paper;
  final String pdfUrl; // The on-demand fetched R2 URL

  const PdfViewerPage({
    super.key,
    required this.paper,
    required this.pdfUrl,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    final String pdfUrl = widget.pdfUrl.trim();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.paper.postName} - ${widget.paper.paperName}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (_totalPages > 0)
              Text(
                "Page ${_currentPage + 1} of $_totalPages",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in_rounded),
            onPressed: () => _pdfViewerController.zoomLevel =
                (_pdfViewerController.zoomLevel + 0.25).clamp(1.0, 3.0),
          ),
        ],
      ),
      body: pdfUrl.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text('No PDF URL provided for this paper.',
                      style: TextStyle(color: AppColors.bodyText)),
                ],
              ),
            )
          : Stack(
              children: [
                SfPdfViewer.network(
                  pdfUrl,
                  controller: _pdfViewerController,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                    setState(() {
                      _totalPages = details.document.pages.count;
                    });
                  },
                  onPageChanged: (PdfPageChangedDetails details) {
                    setState(() {
                      _currentPage = details.newPageNumber - 1;
                    });
                  },
                ),
                // Custom Page Indicator at bottom if preferred over AppBar display
                if (_totalPages > 0)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentPage + 1} / $_totalPages',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
