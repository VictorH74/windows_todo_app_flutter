import 'package:api/api.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'collection_theme.g.dart';

/// {@template collection_theme_item}
///
/// A theme color index related to a collection title
///
/// Contains a [collectionTitle] and [themeColorIndex]
///
/// if the property [themeColorIndex] is not provided, it will be set to '0'
///
/// [CollectionTheme]s are immutable and can be copied using [copyWith],
/// in addition to being serialized and deserialized using [toJson]
/// and [CollectionTheme.fromJson]
/// respectively.
@immutable
@JsonSerializable()
class CollectionTheme extends Equatable {
  /// {@macro collection_theme_item}
  const CollectionTheme({
    required this.collectionTitle,
    this.themeColorIndex = 0,
  });

  /// Create a new [CollectionTheme] object from json
  factory CollectionTheme.fromJson(JsonMap json) {
    return _$CollectionThemeFromJson(json);
  }

  /// A title from a [TodoCollection] instance
  final String collectionTitle;

  /// A int value that will be used to get a color
  /// from a list of colors by index
  final int themeColorIndex;

  /// Return a map from a [CollectionTheme]'s instance
  JsonMap toJson() {
    return _$CollectionThemeToJson(this);
  }

  /// Returns a copy of this instance with the given values updated.
  ///
  /// {@macro collection_theme_item}
  CollectionTheme copyWith({
    String? collectionTitle,
    int? themeColorIndex,
  }) {
    return CollectionTheme(
      collectionTitle: collectionTitle ?? this.collectionTitle,
      themeColorIndex: themeColorIndex ?? this.themeColorIndex,
    );
  }

  @override
  List<Object?> get props => [
        collectionTitle,
        themeColorIndex,
      ];
}
