<!-- 
BSD 3-Clause License
Copyright (c) 2022, GM Consult Pty Ltd
All rights reserved. 
-->

# json_text_search
A Dart full-text search (FTS) library that allows creation of inverted indexes on JSON collections and FTS querying of the same index.

*THIS PACKAGE IS IN BETA DEVELOPMENT AND SUBJECT TO DAILY BREAKING CHANGES.*

## Install

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  json_text_search: ^0.0.1-beta.1
```

In your code file add the following import:

```dart
import 'package:json_text_search/json_text_search.dart';
```

## Usage

This [simple example](https://pub.dev/packages/json_text_search/example) creates an index on the `sampleNews` dataset using `JsonIndexBuilder.impl` and then finds the index entry for the term "intel".

For a production indexer, inherit from `JsonIndexBuilder`, overriding the  `indexedFields`, `tokenizer` and `relevanceBuilder` fields.

The `index` method and `tokenizer` callback return futures to allow the use of API calls or isolates in your implementation.


## Issues

If you find a bug please fill an [issue](https://github.com/GM-Consult-Pty-Ltd/text_analysis/issues).  

This project is a supporting package for a revenue project that has priority call on resources, so please be patient if we don't respond immediately to issues or pull requests.
