// Copyright ©2022, GM Consult (Pty) Ltd.
// BSD 3-Clause License
// All rights reserved

import 'package:json_text_search/json_text_search.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:porter_2_stemmer/porter_2_stemmer.dart';

/// Provides indexing methods for a collection of JSON documents.
/// - [tokenizer] returns a collection of [Token]s from a text source;
/// - [relevanceBuilder] calculates relevance from a collection of
///   [TermLocation];
/// - [indexedFields] is the names of the indexed fields in the collection,
///   mapped to the relative priority of each field (0 is lowest priority);
///
/// Implementing classes should override [tokenizer], [relevanceBuilder] and
/// [indexedFields] to suit indexing of the target collection.
///
/// The [JsonIndexBuilder.impl] factory constructor returns a basic
/// implementation of [JsonIndexBuilder] with the following parameters:
/// - [indexedFields] is the names of the indexed fields in the
///   collection, mapped to the relative priority of each field
///   (0 is lowest priority) (required);
/// - [tokenizer] is a callback that returns a collection of
///   [Token]s from text (optional, defaults to [kDefaultTokenizer]); and
/// - [relevanceBuilder] is a callback that calculates relevance
///   from a collection of [TermLocation] (optional, defaults to
///   [kDefaultRelevanceBuilder]).
abstract class JsonIndexBuilder {
  //

  /// A const constructor for sub classes.
  const JsonIndexBuilder();

  /// Hydrates a basic implementation of [JsonIndexBuilder] with:
  /// - (required) [indexedFields] is the names of the indexed fields in the
  ///   collection, mapped to the relative priority of each field
  ///   (0 is lowest priority);
  /// - (optional) [tokenizer] is a callback that returns a collection of
  ///   [Token]s from text; and
  /// - (optional) [relevanceBuilder] is a callback that calculates relevance
  ///   from a collection of [TermLocation].
  ///
  /// The default [tokenizer] Uses a [TextAnalyzer] instance with [English] as
  /// [TextAnalyzerConfiguration] and the [Porter2Stemmer] as [TokenFilter].
  factory JsonIndexBuilder.impl(
          {required FieldPriority indexedFields,
          Tokenizer tokenizer = kDefaultTokenizer,
          RelevanceBuilder relevanceBuilder = kDefaultRelevanceBuilder}) =>
      _JsonIndexerImpl(indexedFields, tokenizer, relevanceBuilder);

  /// A function that returns a collection of [Token] from text.
  ///
  /// Sub-classes should override [tokenizer] to suit specific search
  /// requirements.
  Tokenizer get tokenizer;

  /// A function that calculates relevance from a collection of [TermLocation]
  /// by applying an algorithm that weights the field priority, position in
  /// the field and number of instances of the term.
  ///
  /// Sub-classes should override [relevanceBuilder] to suit specific search
  /// requirements.
  RelevanceBuilder get relevanceBuilder;

  /// The names of the fields in the collection to be tokenized mapped to the
  /// relative weight of each field.
  ///
  /// Sub-classes should override [indexedFields] to suit the collection that
  /// is indexed.
  FieldPriority get indexedFields;

  /// Returns a hashmap of term to [IndexEntry] from the [collection],
  /// a hashmap of primary key to JSON document used to create the index.
  ///
  /// The base class implementation builds the [index] as follows:
  /// - create an empty [JsonTextIndex] to hold the return value;
  /// - iterate through all JSON documents in [collection]; for each entry
  /// - iterate through the [indexedFields]; for each field
  /// - get [Token]s from source text in the field using [tokenizer];
  /// - map all [Token]s to [TermLocation]s;
  /// - when all [Token]s and [TermLocation]s;
  /// - calculate the relevance of the JSON document for every term in its
  ///   tokens;
  /// - create a [IndexReference] for the JSON document; and
  /// - create or update the [IndexEntry] for the term and add it to the
  ///   return value.
  ///
  /// Override the [index] method for custom indexing.
  Future<JsonTextIndex> index(
      Map<String, Map<String, dynamic>> collection) async {
    // - create an empty [JsonTextIndex] to hold the return value;
    final retVal = <String, IndexEntry>{};
    // - iterate through all JSON documents in [collection.entries];
    for (final entry in collection.entries) {
      final terms = <String>{};
      final id = entry.key;
      final json = entry.value;
      final termLocations = <TermLocation>[];
      // - extract [Token]s and [TermLocation]s from each JSON document by iterating through the indexedFields;
      for (final field in indexedFields.entries) {
        final fieldName = field.key;
        final fieldPriority = field.value;
        final source = json[fieldName]?.toString();
        // assert(source is String, 'The field [$fieldName] cannot be null.');
        if (source is String && source.isNotEmpty) {
          // - get tokens from source text in field using [tokenizer];
          final tokens = await tokenizer(source);
          terms.addAll(tokens.map((e) => e.term));
          // - map all tokens to [TermLocation]s;
          termLocations.addAll(tokens.map((e) =>
              TermLocation(e.term, fieldName, fieldPriority, e.position)));
        }
      }
      // - calculate the relevance of the JSON document for every term in its tokens.
      for (final term in terms) {
        final termInstances = termLocations.byTerm(term);
        final relevance = relevanceBuilder(termInstances);
        // - create or update the [IndexReference] for the JSON document;
        final ref = IndexReference(id, term, json, termInstances, relevance);
        // - create or update the [IndexEntry] for the term and add it to the return value.
        retVal[term] = (retVal[term] ?? IndexEntry(term, {})).addReference(ref);
      }
    }
    return retVal;
  }

  /// The default [RelevanceBuilder] for [JsonIndexBuilder].
  static double kDefaultRelevanceBuilder(Iterable<TermLocation> termLocations) {
    return termLocations.termRelevance;
  }

  /// The default [Tokenizer] for [JsonIndexBuilder]. Uses a [TextAnalyzer] instance
  /// with the defaults:
  /// - [English] configuration; and
  /// - default [TokenFilter] that applies the [Porter2Stemmer].
  static Future<Iterable<Token>> kDefaultTokenizer(String source) async {
    final analyzer = TextAnalyzer();
    final doc = await analyzer.tokenize(source);
    return doc.tokens;
  }
}

/// Implementation of [JsonIndexBuilder]
class _JsonIndexerImpl extends JsonIndexBuilder {
  //

  @override
  final FieldPriority indexedFields;

  @override
  final Tokenizer tokenizer;

  @override
  final RelevanceBuilder relevanceBuilder;

  /// Hydrates a [_JsonIndexerImpl] instance:
  /// - [indexedFields] is the names of the fields in the collection to be
  ///   tokenized, mapped to the relative weight of each field;
  /// - [tokenizer] returns a collection of [Token]s from text; and
  /// - [relevanceBuilder] calculates relevance from a collection of
  ///   [TermLocation].
  const _JsonIndexerImpl(
      this.indexedFields, this.tokenizer, this.relevanceBuilder);
}

/// Extension methods on a collection of [Token].
extension JsonTextIndexTokenCollectionExtension on Iterable<Token> {
  //

  /// Returns a list of [TermLocation] from the [Token] collection, ordered by
  /// [TermLocation.position].
  ///
  /// Filters the collection for [term], then maps the filtered collection to
  /// a list of [TermLocation].
  List<TermLocation> locations(
          String term, String fieldName, int fieldPriority) =>
      byTerm(term)
          .map((e) => TermLocation(term, fieldName, fieldPriority, e.position))
          .toList();
}

/// Extension methods on a collection of [TermLocation].
extension JsonTextIndexTermLocationCollectionExtension
    on Iterable<TermLocation> {
  //

  /// Returns the [TermLocation] instances for [term].
  ///
  /// The collection is ordered in ascending order of relvance by calculating
  /// [TermLocation.priority] * [TermLocation.position].
  List<TermLocation> byTerm(String term) {
    final locations = where((element) => element.term == term).toList();
    locations.sort(
        (a, b) => (a.priority * a.position).compareTo(b.priority * b.position));
    return locations;
  }

  /// Returns a calculated relevance value for [TermLocation] instances for a
  /// single term.
  ///
  /// Relevance is calculated using the following simple aggregationalgorithm:
  /// - assert that the collection is for a single term and the term is not
  ///   empty;
  /// - initial <relevance> is set equal to 0.0;
  /// - iterate through the collection; and
  /// - add [TermLocation.priority] * (1- [TermLocation.position]) to relevance;
  /// - Return the aggregated relevance.
  double get termRelevance {
    final terms = Set<String>.from(map((e) => e.term));
    // - assert that the collection is for a single term and the term is not empty;
    assert(terms.length == 1, 'The collection must contain (only) one term.');
    assert(terms.first.isNotEmpty, 'The [term] must not be empty.');
    // - set initial relevance to 0.0;
    var relevance = 0.0;
    // - iterate through the collection;
    for (final location in this) {
      // - add location.priority * (1- location.position) to relevance;
      relevance = relevance + (location.priority * 1 - location.position);
    }
    // - return the aggregated <relevance>;
    return relevance;
  }
}
