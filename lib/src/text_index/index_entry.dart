// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

import 'package:json_text_search/json_text_search.dart';

/// Type definition of a collection of JSON documents with their relevance
/// values, represented as a hashmap of document id to [IndexReference].
typedef IndexReferenceCollection = Map<String, IndexReference>;

/// Enumerates the properties of an entry in an inverted text index.
abstract class IIndexEntry {
  //

  /// The indexed term.
  String get term;

  /// A collection of JSON documents with their relevance values, represented as
  /// a hashmap of document id to [IndexReference].
  IndexReferenceCollection get references;

  /// Returns a list of JSON documents from [references] ranked in
  /// descending order of relevance.
  ///
  /// Limits the result to [limit], or all [references]  if [limit] is null.
  List<Map<String, dynamic>> rankedReferences([int? limit]);
}

/// Enumerates the properties of an entry in an inverted text index.
class IndexEntry implements IIndexEntry {
  //

  /// Instantiates a const [IndexEntry] for the [term] with the [references]
  /// collection.
  const IndexEntry(this.term, this.references);

  @override
  final String term;

  @override
  final Map<String, IndexReference> references;

  @override
  List<Map<String, dynamic>> rankedReferences([int? limit]) =>
      references._rankedReferences(limit);
}

/// Utility extensions on the [IndexEntry]'s references map.
extension _IndexReferencesExtension on Map<String, IndexReference> {
  //

  /// Returns a list of JSON documents ranked in descending order of relevance.
  ///
  /// Limits the result to [limit], or all entries if [limit] is null.
  List<Map<String, dynamic>> _rankedReferences([int? limit]) {
    final entries = List<IndexReference>.from(values);
    entries.sort((a, b) => b.relevance.compareTo(a.relevance));
    return entries.map((e) => e.json).toList();
  }
}
