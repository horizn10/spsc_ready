import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/paper_model.dart';

class BookmarkService {
  static final BookmarkService _instance = BookmarkService._internal();
  factory BookmarkService() => _instance;
  BookmarkService._internal();

  final _storage = const FlutterSecureStorage();
  final ValueNotifier<List<PaperModel>> bookmarksNotifier = ValueNotifier<List<PaperModel>>([]);

  Future<void> init() async {
    final String? bookmarksJson = await _storage.read(key: 'bookmarked_papers');
    if (bookmarksJson != null) {
      try {
        final List<dynamic> decoded = json.decode(bookmarksJson);
        bookmarksNotifier.value = decoded.map((item) => PaperModel.fromJson(item)).toList();
      } catch (e) {
        debugPrint('Error loading bookmarks: $e');
        bookmarksNotifier.value = [];
      }
    }
  }

  bool isBookmarked(String paperId) {
    return bookmarksNotifier.value.any((p) => p.id == paperId);
  }

  Future<void> toggleBookmark(PaperModel paper) async {
    final List<PaperModel> current = List.from(bookmarksNotifier.value);
    final int index = current.indexWhere((p) => p.id == paper.id);

    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(paper);
    }

    bookmarksNotifier.value = current;
    await _storage.write(
      key: 'bookmarked_papers',
      value: json.encode(current.map((p) => p.toJson()).toList()),
    );
  }
}
