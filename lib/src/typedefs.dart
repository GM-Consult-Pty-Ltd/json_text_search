// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

// ignore_for_file: deprecated_member_use_from_same_package

import 'package:json_text_search/json_text_search.dart';

/// A type definition mapping the fields in a JSON document to priority:
///
/// - the priority value must be greater than or equal to zero; and
/// - the highest priority is zero.
@Deprecated(
    'typedef [FieldPriority] is no longer supported and will be removed with '
    'the next version.')
typedef FieldPriority = Map<String, int>;

/// Type definition of a collection of JSON documents with their relevance
/// values, represented as a hashmap of document id to [IndexReference].
@Deprecated(
    'typedef [IndexReferenceCollection] is no longer supported and will be removed with '
    'the next version.')
typedef IndexReferenceCollection = Map<String, IndexReference>;

/// Type definition for a hashmap of term to [IndexEntry].
@Deprecated(
    'typedef [JsonTextIndex] is no longer supported and will be removed with '
    'the next version.')
typedef JsonTextIndex = Map<String, IndexEntry>;

/// Type definition of a function that calculates relevance from a collection
/// of [TermLocation] by applying an algorithm that weights the field priority,
/// position in the field and number of instances of the term.
///
/// The [termInstances] collection elements must all have the same
/// [TermLocation.term] and the term must not be empty.
@Deprecated(
    'typedef [RelevanceBuilder] is no longer supported and will be removed with '
    'the next version.')
typedef RelevanceBuilder = double Function(
    Iterable<TermLocation> termInstances);
