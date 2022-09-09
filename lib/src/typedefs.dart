// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

import 'package:json_text_search/json_text_search.dart';

/// A type definition mapping the fields in a JSON document to priority:
///
/// - the priority value must be greater than or equal to zero; and
/// - the highest priority is zero.
typedef FieldPriority = Map<String, int>;

/// Type definition of a collection of JSON documents with their relevance
/// values, represented as a hashmap of document id to [IndexReference].
typedef IndexReferenceCollection = Map<String, IndexReference>;

/// Type definition for a hashmap of term to [IndexEntry].
typedef JsonTextIndex = Map<String, IndexEntry>;

/// Type definition of a function that calculates relevance from a collection
/// of [TermLocation] by applying an algorithm that weights the field priority,
/// position in the field and number of instances of the term.
///
/// The [termInstances] collection elements must all have the same
/// [TermLocation.term] and the term must not be empty.
typedef RelevanceBuilder = double Function(
    Iterable<TermLocation> termInstances);
