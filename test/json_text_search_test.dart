import 'package:json_text_search/json_text_search.dart';
import 'package:json_text_search/src/json_text_index/json_text_index.dart';
import 'package:test/test.dart';
import 'package:text_analysis/text_analysis.dart';
import 'data/sample_news.dart';

void main() {
  group('A group of tests', () {
    final indexer = JsonIndexer(tokenizer: tokenizer);
    final indexedFields = <String, double>{'name': 2.0, 'description': 1.0};

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () async {
      final index = await indexer.index(sampleNews, indexedFields);
      print(index.keys);
    });
  });
}

Future<List<Token>> tokenizer(String source) async {
  final analyzer = TextAnalyzer();
  final doc = await analyzer.tokenize(source);
  return doc.tokens;
}
