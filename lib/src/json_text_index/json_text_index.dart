// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

import 'package:json_text_search/json_text_search.dart';
import 'package:text_analysis/text_analysis.dart';

/// Type definition for a hashmap of term to [IndexEntry].
typedef JsonTextIndex = Map<String, IndexEntry>;

/// Provides indexing methods for a collection of JSON documents.
abstract class JsonIndexer {
  //

  /// Hydrates a [JsonIndexer] with the [tokenizer] and [relevanceBuilder]
  /// functions.
  factory JsonIndexer({
    required Tokenizer tokenizer,
    // required RelevanceBuilder relevanceBuilder
  }) =>
      _JsonIndexerImpl(tokenizer);

  /// A function that returns a collection of [Token] from text.
  Tokenizer get tokenizer;

  // /// A function that calculates the relevance of a document to a
  // RelevanceBuilder get relevanceBuilder;

  /// Returns a hashmap of term to [IndexEntry] from the [collection].
  /// - [collection] is a hashmap of primary key to JSON document used to create
  ///   the index; and
  /// - [indexedFields] is  the names of the fields in the collection to be
  ///   tokenized mapped to the relative weight of each field.
  Future<JsonTextIndex> index(Map<String, Map<String, dynamic>> collection,
      FieldRelevance indexedFields);
}

/// Implementation of [JsonIndexer]
class _JsonIndexerImpl implements JsonIndexer {
  //

  @override
  final Tokenizer tokenizer;

  const _JsonIndexerImpl(this.tokenizer);

  @override
  Future<JsonTextIndex> index(Map<String, Map<String, dynamic>> collection,
      FieldRelevance indexedFields) async {
    // final fieldWeights =
    //     List<MapEntry<String, double>>.from(indexedFields.entries);

    // fieldWeights.sort((a, b) => b.value.compareTo(a.value));
    final retVal = <String, IndexEntry>{};
    for (final entry in collection.entries) {
      final docTokens = <Token>[];
      final id = entry.key;
      final json = entry.value;
      for (final field in indexedFields.entries) {
        final fieldName = field.key;
        final fieldWeight = field.value;
        final source = json[fieldName];
        assert(source is String, 'The field [$fieldName] cannot be null.');
        if (source is String && source.isNotEmpty) {
          final tokens = await tokenizer(source);
          docTokens.addAll(tokens
              .map((e) => Token(e.term, e.index, e.position * fieldWeight)));
        }
      }
      final terms = Set<String>.from(docTokens.map((e) => e.term));
      for (final term in terms) {
        final ref = IndexReference(id, json, docTokens.relevance(term));
        var entry = retVal[term] ?? IndexEntry(term, {});
        entry = entry.addReference(ref);
        retVal[term] = entry;
      }
      print(terms);
    }
    return retVal;
  }
}



// /// Extension methods on JSON ([Map]<String, dynamic>) to facilitate indexing
// /// of JSON collections.
// extension JsonTextIndexExtension on Map<String, dynamic>{

// }
