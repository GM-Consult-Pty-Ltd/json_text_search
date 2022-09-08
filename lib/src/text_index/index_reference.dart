// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

/// A builder function that calculates the relevance of a JSON document to a
/// search term.
typedef RelevanceBuilder = double Function(Map<String, dynamic> json);

/// A type definition mapping the fields in a JSON document to relevance
/// weights.
typedef FieldRelevance = Map<String, double>;

/// Enumerates the properties of a document reference in an inverted text index.
abstract class IndexReference {
  //

  /// A const contructor for use in sub-classes.
  const IndexReference();

  /// A factory constructor that instantiates a [IndexReference] from
  /// the [json] document, using the [primaryKeyName] and [relevanceBuilder].
  factory IndexReference.fromJson(
          {required Map<String, dynamic> json,
          required String primaryKeyName,
          required RelevanceBuilder relevanceBuilder}) =>
      _IndexReferenceImpl.fromJson(json, primaryKeyName, relevanceBuilder);

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

class _IndexReferenceImpl implements IndexReference {
  //

  /// A factory constructor that instantiates a [IndexReference] from
  /// the [json] document, using the [primaryKeyName] and [relevanceBuilder].
  factory _IndexReferenceImpl.fromJson(Map<String, dynamic> json,
      String primaryKeyName, RelevanceBuilder relevanceBuilder) {
    assert(primaryKeyName.isNotEmpty,
        'A non-empty primary key field name must be provided');
    final id = json[primaryKeyName];
    assert(
        id is String && id.isNotEmpty,
        'The JSON document must contain a non-empty String field '
        'named $primaryKeyName');
    final relevance = relevanceBuilder(json);
    return _IndexReferenceImpl(id as String, json, relevance);
  }

  /// A const constructor that instantiates a [IndexReference].
  const _IndexReferenceImpl(this.id, this.json, this.relevance);

  @override
  final String id;

  @override
  final Map<String, dynamic> json;

  @override
  final double relevance;
}
