// ignore_for_file: deprecated_member_use_from_same_package

import 'package:json_text_search/json_text_search.dart';
import 'package:json_text_search/src/json_text_index/json_index_builder.dart';
import 'package:test/test.dart';
import 'package:text_analysis/text_analysis.dart';
import 'data/sample_news_subset.dart';

void main() {
  group('JsonIndexBuilder', () {
    final indexedFields = <String, int>{
      'hashTags': 5,
      'name': 2,
      'description': 1
    };
    final indexer = JsonIndexBuilder.impl(indexedFields: indexedFields);
    setUp(() {
      // Additional setup goes here.
    });

    test('JsonIndexBuilder.index', () async {
      final index = await indexer.index(sampleNews);
      print(index.keys);
    });
  });
}

Future<List<Token>> tokenizer(String source) async {
  final analyzer = TextAnalyzer();
  final doc = await analyzer.tokenize(source);
  return doc.tokens;
}
