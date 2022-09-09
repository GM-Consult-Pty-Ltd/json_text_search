// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

import 'package:json_text_search/json_text_search.dart';

/// Enumerates the properties of a document reference in an inverted text index.
/// - [id] is the primary key value of the [document];
/// - [term] is the term/word that this refererence is associated with;
/// - [document] is the document associated with this index reference;
/// - [termInstances] is an ordered collection of occurences of [term] in the
///   [document] document; and
/// - [relevance] is a value between 0 and 1 that enumerates the index reference's relevance
///   to the indexed term.
abstract class IIndexReference {
  //

  /// The term/word that this refererence is associated with.
  String get term;

  /// The document associated with this index reference.
  Map<String, dynamic> get document;

  /// The primary key value of [document].
  String get id;

  /// An ordered collection of occurences of [term] in the [document].
  List<TermLocation> get termInstances;

  /// A value greater than or equal to 0.0 that enumerates the index
  /// reference's relevance to the indexed term.
  ///
  /// Relevance is calculated from the [termInstances] by applying an algorithm
  /// that weights the field priority, position in the field and number of
  /// instances of the term.
  double get relevance;

  @override
  bool operator ==(Object other) =>
      other is IIndexReference &&
      id == other.id &&
      term == other.term &&
      document.toString() == other.toString();

  @override
  int get hashCode => Object.hash(term, id, document);
}

/// Implementation of [IIndexReference].
///
/// Enumerates the properties of a document reference in an inverted text index.
/// - [id] is the primary key value of the [document];
/// - [term] is the term/word that this refererence is associated with;
/// - [document] is the document associated with this index reference;
/// - [termInstances] is an ordered collection of occurences of [term] in the
///   [document] document; and
/// - [relevance] is a value between 0 and 1 that enumerates the index reference's relevance
///   to the indexed term.
class IndexReference implements IIndexReference {
  //

  /// Instantiates a const [IndexReference] instance:
  /// - [id] is the primary key value of the [document];
  /// - [term] is the term/word that this refererence is associated with;
  /// - [document] is the document associated with this index reference;
  /// - [termInstances] is an ordered collection of occurences of [term] in the
  ///   [document] document; and
  /// - [relevance] is a value between 0 and 1 that enumerates the index reference's relevance
  ///   to the indexed term.
  const IndexReference(
      this.id, this.term, this.document, this.termInstances, this.relevance);

  @override
  final String term;

  @override
  final String id;

  @override
  final Map<String, dynamic> document;

  @override
  final List<TermLocation> termInstances;

  @override
  final double relevance;
}
