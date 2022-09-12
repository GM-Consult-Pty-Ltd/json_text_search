/// In your code file add the following import:
// ignore_for_file: deprecated_member_use_from_same_package

import 'package:json_text_search/json_text_search.dart';

/// This simple example creates an index on the [sampleNews] dataset below and
/// then finds the index entry for the term "intel".
void main() async {
  //

  // our index  only tokenizes the "hashTags", "name" and "description" fields.
  final indexedFields = <String, int>{
    //

    // "hashTags" is the highest priority field and will return a relevance
    // five times as high as the "description" field
    'hashTags': 5,
    'name': 2,
    'description': 1
  };
  final indexer = JsonIndexBuilder.impl(indexedFields: indexedFields);

  // index the sampleNews on the "hashTags", "name" and "description" fields
  final index = await indexer.index(sampleNews);

  //  Find [IndexEntry] for the term "intel".
  final indexEntry = index['intel'];
  if (indexEntry != null) {
    //
    // print the references count for indexEntry
    print('Found ${indexEntry.references.length} documents for the term '
        '"${indexEntry.term}"');
    // prints "Found 1 documents for the term "intel""

    // print the title and relevance for each reference in the indexEntry
    for (final reference in indexEntry.references.values) {
      print('[Title: "${reference.document['name']}"] '
          '[relevance: ${reference.relevance.toStringAsFixed(3)}]');
      // prints "[Title: "Intel Should Slash Its Dividend The Chip Maker s
      //Future May Depend on It"] [relevance: 3.653]"
    }
  }
}

/// A small sample dataset.
const sampleNews = {
  'ef3b0cb6-0297-502b-bd77-283246bc0014': {
    'description':
        'JPMorgan Sees ‘Stratospheric’ \$380 Oil on Worst-Case Russian Cut',
    'entityType': 'NewsItem',
    'hashTags': ['#JPMorganChase'],
    'linkUrl':
        'https://finance.yahoo.com/news/germany-risks-cascade-utility-failures-'
            '194853753.html',
    'locale': 'Locale.en_US',
    'name': 'Germany Risks a Cascade of Utility Failures Economy Chief Says',
    'publicationDate': '2022-07-02T19:48:53.000Z',
    'publisher': {
      'linkUrl': 'https://www.bloomberg.com/',
      'title': 'Bloomberg'
    },
    'timestamp': 1656802194091
  },
  'f1064cca-bf6d-5689-900b-ecb8769fe30b': {
    'description': 'Under CEO Pat Gelsinger, Intel has committed to massively increasing '
        'its capital spending investments by tens of billions of dollars. But '
        'with a rapidly slowing global economy, repeated product delays, rising '
        'competitive threats, and political uncertainty, it might need more '
        'help to fund its ambitions. One good place to find it would be Intel '
        '(ticker: INTC) generous dividend payout. While the chip maker has '
        'paid a consistent dividend for three decades straight, it needs to '
        'do whatever it takes to shore up its future—up to and including '
        'cutting its dividend. Under CEO Pat Gelsinger, Intel has committed '
        'to massively increasing its capital spending investments by tens of '
        'billions of dollars.',
    'entityType': 'NewsItem',
    'hashTags': ['#Intel'],
    'linkUrl': 'https://www.barrons.com/articles/intel-stock-dividend-future-'
        '51656450364?siteid=yhoof2&yptr=yahoo',
    'locale': 'Locale.en_US',
    'name':
        'Intel Should Slash Its Dividend The Chip Maker s Future May Depend on It',
    'publicationDate': '2022-06-29T12:00:00.000Z',
    'publisher': {'linkUrl': 'http://www.barrons.com/', 'title': 'Barrons com'},
    'timestamp': 1656540522708
  },
  'f83c0c39-8cc3-5b0e-91de-61e829ea65dc': {
    'description':
        'Sell Exxon Mobil and other energy stocks before these headwinds hit '
            'prices once again: ',
    'entityType': 'NewsItem',
    'hashTags': ['#ExxonMobil'],
    'linkUrl':
        'https://www.marketwatch.com/story/sell-exxon-mobil-and-other-energy-'
            'stocks-before-these-headwinds-once-again-hit-prices-11656527286?siteid'
            '=yhoof2&yptr=yahoo',
    'locale': 'Locale.en_US',
    'name':
        'Sell Exxon Mobil and other energy stocks before these headwinds hit '
            'prices once again',
    'publicationDate': '2022-06-29T18:28:00.000Z',
    'publisher': {
      'linkUrl': 'http://www.marketwatch.com/',
      'title': 'MarketWatch'
    },
    'timestamp': 1656630576652
  }
};
