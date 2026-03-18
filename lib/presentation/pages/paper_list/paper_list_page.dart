import 'package:flutter/material.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/paper_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../browse_paper/widgets/paper_card.dart';

class PaperListPage extends StatefulWidget {
  final PostModel post;

  const PaperListPage({super.key, required this.post});

  @override
  State<PaperListPage> createState() => _PaperListPageState();
}

class _PaperListPageState extends State<PaperListPage> {
  final ApiService _apiService = ApiService();
  late Future<List<PaperModel>> _papersFuture;

  @override
  void initState() {
    super.initState();
    _papersFuture = _apiService.getPapersByPost(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.post.name,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<PaperModel>>(
        future: _papersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No papers found for this post.'));
          }

          final papers = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: papers.length,
            itemBuilder: (context, index) {
              final paper = papers[index];
              return PaperCard(paper: paper);
            },
          );
        },
      ),
    );
  }
}
