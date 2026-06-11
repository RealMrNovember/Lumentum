import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'library_document.dart';

class LibraryProvider extends ChangeNotifier {
  static const _prefKey = 'lumentum_library_v1';

  List<LibraryDocument> _documents = [];
  bool _ready = false;

  List<LibraryDocument> get documents => List.unmodifiable(_documents);
  bool get ready => _ready;

  Future<void> bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw != null) {
      final list = (jsonDecode(raw) as List)
          .cast<Map<String, dynamic>>()
          .map(LibraryDocument.fromJson)
          .toList();
      _documents = list;
    }
    if (_documents.isEmpty) {
      await _seedDemoDocuments();
    }
    _ready = true;
    notifyListeners();
  }

  Future<void> _seedDemoDocuments() async {
    final en = await rootBundle.loadString('assets/sample_long_reading_en.txt');
    final tr = await rootBundle.loadString('assets/sample_long_reading_tr.txt');
    _documents = [
      LibraryDocument(
        id: const Uuid().v4(),
        title: 'Demo: Cognitive Reading (EN)',
        source: 'demo',
        text: en,
        addedAt: DateTime.now(),
        isDemo: true,
      ),
      LibraryDocument(
        id: const Uuid().v4(),
        title: 'Demo: Bilişsel Okuma (TR)',
        source: 'demo',
        text: tr,
        addedAt: DateTime.now(),
        isDemo: true,
      ),
    ];
    await _persist();
  }

  Future<void> addFromText({
    required String title,
    required String text,
    String source = 'paste',
  }) async {
    _documents.insert(
      0,
      LibraryDocument(
        id: const Uuid().v4(),
        title: title,
        source: source,
        text: text,
        addedAt: DateTime.now(),
      ),
    );
    await _persist();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _documents.removeWhere((d) => d.id == id);
    await _persist();
    notifyListeners();
  }

  LibraryDocument? findById(String id) {
    for (final doc in _documents) {
      if (doc.id == id) return doc;
    }
    return null;
  }

  LibraryDocument? get lastOpened {
    if (_documents.isEmpty) return null;
    return _documents.first;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_documents.map((d) => d.toJson()).toList());
    await prefs.setString(_prefKey, encoded);
  }
}
