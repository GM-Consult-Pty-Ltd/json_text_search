// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

/// An object describing the location of a term in a JSON document.
/// - [term] is the term/word associated with the [TermLocation].
/// - the [field] is the name of the field in which the term occurs;
/// - [priority] is the relevance priority of the [field], with 0 having
///   highest priority; and
/// - the [position] is the zero-based location of the start of the term from
///   the start of the text in the field.
class TermLocation {
  //

  /// The term/word associated with the [TermLocation].
  final String term;

  /// The priority of the [field].
  ///
  /// The [priority] must be greater than or equal to zero.
  ///
  /// The lowest priority is zero.
  final int priority;

  /// The name of the field in which the term occurs
  final String field;

  /// The position of the term from the end of the source text
  /// as a fraction of the source text length.
  ///
  /// The [position] can be used as a proxy of term relevance in the
  /// source text.
  ///
  /// A position of 1.0 means the term is at the start of the source text.
  final double position;

  /// Instantiates a const [TermLocation] instance:
  /// - [term] is the term/word associated with the [TermLocation].
  /// - [field] is the name of the field in which the term occurs;
  /// - [priority] is the relevance priority of the [field], with 0 having
  ///   highest priority; and
  /// - [position] is the zero-based location of the start of the term from
  ///   the start of the text in the field.
  const TermLocation(this.term, this.field, this.priority, this.position);

  @override
  bool operator ==(Object other) =>
      other is TermLocation &&
      term == other.term &&
      priority == other.priority &&
      field == other.field &&
      position == other.position;

  @override
  int get hashCode => Object.hash(term, priority, field, position);
}
