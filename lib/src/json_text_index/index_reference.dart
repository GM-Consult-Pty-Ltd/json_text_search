// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

// /// A builder function that calculates the relevance of a JSON document to a
// /// search term.
// typedef RelevanceBuilder = double Function(Iterable<Token> tokens);

/// A type definition mapping the fields in a JSON document to relevance
/// weights.
typedef FieldRelevance = Map<String, double>;

/// Enumerates the properties of a document reference in an inverted text index.
abstract class IIndexReference {
  //

  /// The document associated with this index reference.
  Map<String, dynamic> get json;

  // /// A builder function that calculates the relevance of a JSON document to a
  // /// search term.
  // RelevanceBuilder get relevanceBuilder;

  /// The primary key value of [json].
  String get id;

  /// A value between 0 and 1 that enumerates the index reference's relevance
  /// to the indexed term.
  double get relevance;
}

/// Implementation of [IIndexReference].
///
/// Enumerates the properties of a document reference in an inverted text index.
class IndexReference implements IIndexReference {
  //

  /// A const constructor that instantiates a [IndexReference].
  const IndexReference(this.id, this.json, this.relevance);

  @override
  final String id;

  @override
  final Map<String, dynamic> json;

  @override
  final double relevance;
}
