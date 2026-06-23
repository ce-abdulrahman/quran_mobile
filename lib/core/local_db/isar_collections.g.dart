// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_collections.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSurahCollectionCollection on Isar {
  IsarCollection<SurahCollection> get surahCollections => this.collection();
}

final SurahCollectionSchema = CollectionSchema(
  name: r'SurahCollection',
  id: int.parse('7167559995064913286'),
  properties: {
    r'nameAr': PropertySchema(
      id: 0,
      name: r'nameAr',
      type: IsarType.string,
    ),
    r'nameEn': PropertySchema(
      id: 1,
      name: r'nameEn',
      type: IsarType.string,
    ),
    r'nameKu': PropertySchema(
      id: 2,
      name: r'nameKu',
      type: IsarType.string,
    ),
    r'number': PropertySchema(
      id: 3,
      name: r'number',
      type: IsarType.long,
    ),
    r'pageEnd': PropertySchema(
      id: 4,
      name: r'pageEnd',
      type: IsarType.long,
    ),
    r'pageStart': PropertySchema(
      id: 5,
      name: r'pageStart',
      type: IsarType.long,
    ),
    r'revelationType': PropertySchema(
      id: 6,
      name: r'revelationType',
      type: IsarType.string,
    ),
    r'totalAyahs': PropertySchema(
      id: 7,
      name: r'totalAyahs',
      type: IsarType.long,
    )
  },
  estimateSize: _surahCollectionEstimateSize,
  serialize: _surahCollectionSerialize,
  deserialize: _surahCollectionDeserialize,
  deserializeProp: _surahCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'number': IndexSchema(
      id: int.parse('5012388430481709372'),
      name: r'number',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'number',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _surahCollectionGetId,
  getLinks: _surahCollectionGetLinks,
  attach: _surahCollectionAttach,
  version: '3.1.0+1',
);

int _surahCollectionEstimateSize(
  SurahCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.nameAr.length * 3;
  bytesCount += 3 + object.nameEn.length * 3;
  bytesCount += 3 + object.nameKu.length * 3;
  bytesCount += 3 + object.revelationType.length * 3;
  return bytesCount;
}

void _surahCollectionSerialize(
  SurahCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.nameAr);
  writer.writeString(offsets[1], object.nameEn);
  writer.writeString(offsets[2], object.nameKu);
  writer.writeLong(offsets[3], object.number);
  writer.writeLong(offsets[4], object.pageEnd);
  writer.writeLong(offsets[5], object.pageStart);
  writer.writeString(offsets[6], object.revelationType);
  writer.writeLong(offsets[7], object.totalAyahs);
}

SurahCollection _surahCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SurahCollection(
    nameAr: reader.readString(offsets[0]),
    nameEn: reader.readString(offsets[1]),
    nameKu: reader.readString(offsets[2]),
    number: reader.readLong(offsets[3]),
    pageEnd: reader.readLongOrNull(offsets[4]),
    pageStart: reader.readLongOrNull(offsets[5]),
    revelationType: reader.readString(offsets[6]),
    totalAyahs: reader.readLong(offsets[7]),
  );
  object.id = id;
  return object;
}

P _surahCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _surahCollectionGetId(SurahCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _surahCollectionGetLinks(SurahCollection object) {
  return [];
}

void _surahCollectionAttach(
    IsarCollection<dynamic> col, Id id, SurahCollection object) {
  object.id = id;
}

extension SurahCollectionByIndex on IsarCollection<SurahCollection> {
  Future<SurahCollection?> getByNumber(int number) {
    return getByIndex(r'number', [number]);
  }

  SurahCollection? getByNumberSync(int number) {
    return getByIndexSync(r'number', [number]);
  }

  Future<bool> deleteByNumber(int number) {
    return deleteByIndex(r'number', [number]);
  }

  bool deleteByNumberSync(int number) {
    return deleteByIndexSync(r'number', [number]);
  }

  Future<List<SurahCollection?>> getAllByNumber(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return getAllByIndex(r'number', values);
  }

  List<SurahCollection?> getAllByNumberSync(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'number', values);
  }

  Future<int> deleteAllByNumber(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'number', values);
  }

  int deleteAllByNumberSync(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'number', values);
  }

  Future<Id> putByNumber(SurahCollection object) {
    return putByIndex(r'number', object);
  }

  Id putByNumberSync(SurahCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'number', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNumber(List<SurahCollection> objects) {
    return putAllByIndex(r'number', objects);
  }

  List<Id> putAllByNumberSync(List<SurahCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'number', objects, saveLinks: saveLinks);
  }
}

extension SurahCollectionQueryWhereSort
    on QueryBuilder<SurahCollection, SurahCollection, QWhere> {
  QueryBuilder<SurahCollection, SurahCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterWhere> anyNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'number'),
      );
    });
  }
}

extension SurahCollectionQueryWhere
    on QueryBuilder<SurahCollection, SurahCollection, QWhereClause> {
  QueryBuilder<SurahCollection, SurahCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterWhereClause>
      numberEqualTo(int number) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'number',
        value: [number],
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterWhereClause>
      numberNotEqualTo(int number) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [],
              upper: [number],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [number],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [number],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [],
              upper: [number],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterWhereClause>
      numberGreaterThan(
    int number, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'number',
        lower: [number],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterWhereClause>
      numberLessThan(
    int number, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'number',
        lower: [],
        upper: [number],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterWhereClause>
      numberBetween(
    int lowerNumber,
    int upperNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'number',
        lower: [lowerNumber],
        includeLower: includeLower,
        upper: [upperNumber],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SurahCollectionQueryFilter
    on QueryBuilder<SurahCollection, SurahCollection, QFilterCondition> {
  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameArEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameArGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameArLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameArBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameAr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameArStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameArEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameArContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameArMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameEnEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameEnGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameEnLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameEnBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameEnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameEnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameEnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameEnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameEn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameEnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameEn',
        value: '',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameEnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameEn',
        value: '',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      nameKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      numberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      numberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      numberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      numberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'number',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageEndIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pageEnd',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageEndIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pageEnd',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageEndEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageEndGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageEndLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageEndBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageEnd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageStartIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pageStart',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageStartIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pageStart',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageStartEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageStart',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageStartGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageStart',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageStartLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageStart',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      pageStartBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      revelationTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revelationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      revelationTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'revelationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      revelationTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'revelationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      revelationTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'revelationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      revelationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'revelationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      revelationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'revelationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      revelationTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'revelationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      revelationTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'revelationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      revelationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revelationType',
        value: '',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      revelationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'revelationType',
        value: '',
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      totalAyahsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAyahs',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      totalAyahsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAyahs',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      totalAyahsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAyahs',
        value: value,
      ));
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterFilterCondition>
      totalAyahsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAyahs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SurahCollectionQueryObject
    on QueryBuilder<SurahCollection, SurahCollection, QFilterCondition> {}

extension SurahCollectionQueryLinks
    on QueryBuilder<SurahCollection, SurahCollection, QFilterCondition> {}

extension SurahCollectionQuerySortBy
    on QueryBuilder<SurahCollection, SurahCollection, QSortBy> {
  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> sortByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> sortByNameEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByNameEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> sortByNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> sortByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> sortByPageEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageEnd', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByPageEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageEnd', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByPageStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageStart', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByPageStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageStart', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByRevelationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationType', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByRevelationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationType', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByTotalAyahs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAyahs', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      sortByTotalAyahsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAyahs', Sort.desc);
    });
  }
}

extension SurahCollectionQuerySortThenBy
    on QueryBuilder<SurahCollection, SurahCollection, QSortThenBy> {
  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> thenByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> thenByNameEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByNameEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> thenByNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> thenByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy> thenByPageEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageEnd', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByPageEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageEnd', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByPageStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageStart', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByPageStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageStart', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByRevelationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationType', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByRevelationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationType', Sort.desc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByTotalAyahs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAyahs', Sort.asc);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QAfterSortBy>
      thenByTotalAyahsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAyahs', Sort.desc);
    });
  }
}

extension SurahCollectionQueryWhereDistinct
    on QueryBuilder<SurahCollection, SurahCollection, QDistinct> {
  QueryBuilder<SurahCollection, SurahCollection, QDistinct> distinctByNameAr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QDistinct> distinctByNameEn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameEn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QDistinct> distinctByNameKu(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QDistinct> distinctByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'number');
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QDistinct>
      distinctByPageEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageEnd');
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QDistinct>
      distinctByPageStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageStart');
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QDistinct>
      distinctByRevelationType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'revelationType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SurahCollection, SurahCollection, QDistinct>
      distinctByTotalAyahs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAyahs');
    });
  }
}

extension SurahCollectionQueryProperty
    on QueryBuilder<SurahCollection, SurahCollection, QQueryProperty> {
  QueryBuilder<SurahCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SurahCollection, String, QQueryOperations> nameArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameAr');
    });
  }

  QueryBuilder<SurahCollection, String, QQueryOperations> nameEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameEn');
    });
  }

  QueryBuilder<SurahCollection, String, QQueryOperations> nameKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameKu');
    });
  }

  QueryBuilder<SurahCollection, int, QQueryOperations> numberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'number');
    });
  }

  QueryBuilder<SurahCollection, int?, QQueryOperations> pageEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageEnd');
    });
  }

  QueryBuilder<SurahCollection, int?, QQueryOperations> pageStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageStart');
    });
  }

  QueryBuilder<SurahCollection, String, QQueryOperations>
      revelationTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'revelationType');
    });
  }

  QueryBuilder<SurahCollection, int, QQueryOperations> totalAyahsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAyahs');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAyahCollectionCollection on Isar {
  IsarCollection<AyahCollection> get ayahCollections => this.collection();
}

final AyahCollectionSchema = CollectionSchema(
  name: r'AyahCollection',
  id: int.parse('4369031179947514418'),
  properties: {
    r'ayahId': PropertySchema(
      id: 0,
      name: r'ayahId',
      type: IsarType.long,
    ),
    r'ayahNumber': PropertySchema(
      id: 1,
      name: r'ayahNumber',
      type: IsarType.long,
    ),
    r'hizbNumber': PropertySchema(
      id: 2,
      name: r'hizbNumber',
      type: IsarType.long,
    ),
    r'juzNumber': PropertySchema(
      id: 3,
      name: r'juzNumber',
      type: IsarType.long,
    ),
    r'pageNumber': PropertySchema(
      id: 4,
      name: r'pageNumber',
      type: IsarType.long,
    ),
    r'rubNumber': PropertySchema(
      id: 5,
      name: r'rubNumber',
      type: IsarType.long,
    ),
    r'surahNumber': PropertySchema(
      id: 6,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'tajweedSegmentsJson': PropertySchema(
      id: 7,
      name: r'tajweedSegmentsJson',
      type: IsarType.string,
    ),
    r'textEn': PropertySchema(
      id: 8,
      name: r'textEn',
      type: IsarType.string,
    ),
    r'textKu': PropertySchema(
      id: 9,
      name: r'textKu',
      type: IsarType.string,
    ),
    r'textUthmani': PropertySchema(
      id: 10,
      name: r'textUthmani',
      type: IsarType.string,
    )
  },
  estimateSize: _ayahCollectionEstimateSize,
  serialize: _ayahCollectionSerialize,
  deserialize: _ayahCollectionDeserialize,
  deserializeProp: _ayahCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'ayahId': IndexSchema(
      id: -int.parse('5377454751934077591'),
      name: r'ayahId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ayahId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _ayahCollectionGetId,
  getLinks: _ayahCollectionGetLinks,
  attach: _ayahCollectionAttach,
  version: '3.1.0+1',
);

int _ayahCollectionEstimateSize(
  AyahCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.tajweedSegmentsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.textEn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.textKu;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.textUthmani.length * 3;
  return bytesCount;
}

void _ayahCollectionSerialize(
  AyahCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ayahId);
  writer.writeLong(offsets[1], object.ayahNumber);
  writer.writeLong(offsets[2], object.hizbNumber);
  writer.writeLong(offsets[3], object.juzNumber);
  writer.writeLong(offsets[4], object.pageNumber);
  writer.writeLong(offsets[5], object.rubNumber);
  writer.writeLong(offsets[6], object.surahNumber);
  writer.writeString(offsets[7], object.tajweedSegmentsJson);
  writer.writeString(offsets[8], object.textEn);
  writer.writeString(offsets[9], object.textKu);
  writer.writeString(offsets[10], object.textUthmani);
}

AyahCollection _ayahCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AyahCollection(
    ayahId: reader.readLong(offsets[0]),
    ayahNumber: reader.readLong(offsets[1]),
    hizbNumber: reader.readLongOrNull(offsets[2]),
    juzNumber: reader.readLongOrNull(offsets[3]),
    pageNumber: reader.readLongOrNull(offsets[4]),
    rubNumber: reader.readLongOrNull(offsets[5]),
    surahNumber: reader.readLong(offsets[6]),
    tajweedSegmentsJson: reader.readStringOrNull(offsets[7]),
    textEn: reader.readStringOrNull(offsets[8]),
    textKu: reader.readStringOrNull(offsets[9]),
    textUthmani: reader.readString(offsets[10]),
  );
  object.id = id;
  return object;
}

P _ayahCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ayahCollectionGetId(AyahCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ayahCollectionGetLinks(AyahCollection object) {
  return [];
}

void _ayahCollectionAttach(
    IsarCollection<dynamic> col, Id id, AyahCollection object) {
  object.id = id;
}

extension AyahCollectionByIndex on IsarCollection<AyahCollection> {
  Future<AyahCollection?> getByAyahId(int ayahId) {
    return getByIndex(r'ayahId', [ayahId]);
  }

  AyahCollection? getByAyahIdSync(int ayahId) {
    return getByIndexSync(r'ayahId', [ayahId]);
  }

  Future<bool> deleteByAyahId(int ayahId) {
    return deleteByIndex(r'ayahId', [ayahId]);
  }

  bool deleteByAyahIdSync(int ayahId) {
    return deleteByIndexSync(r'ayahId', [ayahId]);
  }

  Future<List<AyahCollection?>> getAllByAyahId(List<int> ayahIdValues) {
    final values = ayahIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'ayahId', values);
  }

  List<AyahCollection?> getAllByAyahIdSync(List<int> ayahIdValues) {
    final values = ayahIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'ayahId', values);
  }

  Future<int> deleteAllByAyahId(List<int> ayahIdValues) {
    final values = ayahIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'ayahId', values);
  }

  int deleteAllByAyahIdSync(List<int> ayahIdValues) {
    final values = ayahIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'ayahId', values);
  }

  Future<Id> putByAyahId(AyahCollection object) {
    return putByIndex(r'ayahId', object);
  }

  Id putByAyahIdSync(AyahCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'ayahId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAyahId(List<AyahCollection> objects) {
    return putAllByIndex(r'ayahId', objects);
  }

  List<Id> putAllByAyahIdSync(List<AyahCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'ayahId', objects, saveLinks: saveLinks);
  }
}

extension AyahCollectionQueryWhereSort
    on QueryBuilder<AyahCollection, AyahCollection, QWhere> {
  QueryBuilder<AyahCollection, AyahCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterWhere> anyAyahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'ayahId'),
      );
    });
  }
}

extension AyahCollectionQueryWhere
    on QueryBuilder<AyahCollection, AyahCollection, QWhereClause> {
  QueryBuilder<AyahCollection, AyahCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterWhereClause> ayahIdEqualTo(
      int ayahId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ayahId',
        value: [ayahId],
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterWhereClause>
      ayahIdNotEqualTo(int ayahId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ayahId',
              lower: [],
              upper: [ayahId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ayahId',
              lower: [ayahId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ayahId',
              lower: [ayahId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ayahId',
              lower: [],
              upper: [ayahId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterWhereClause>
      ayahIdGreaterThan(
    int ayahId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ayahId',
        lower: [ayahId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterWhereClause>
      ayahIdLessThan(
    int ayahId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ayahId',
        lower: [],
        upper: [ayahId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterWhereClause> ayahIdBetween(
    int lowerAyahId,
    int upperAyahId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ayahId',
        lower: [lowerAyahId],
        includeLower: includeLower,
        upper: [upperAyahId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AyahCollectionQueryFilter
    on QueryBuilder<AyahCollection, AyahCollection, QFilterCondition> {
  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      ayahIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahId',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      ayahIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ayahId',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      ayahIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ayahId',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      ayahIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ayahId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      ayahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      ayahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      ayahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      ayahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ayahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      hizbNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hizbNumber',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      hizbNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hizbNumber',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      hizbNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hizbNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      hizbNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hizbNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      hizbNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hizbNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      hizbNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hizbNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      juzNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'juzNumber',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      juzNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'juzNumber',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      juzNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'juzNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      juzNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'juzNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      juzNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'juzNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      juzNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'juzNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      pageNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pageNumber',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      pageNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pageNumber',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      pageNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      pageNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      pageNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      pageNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      rubNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rubNumber',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      rubNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rubNumber',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      rubNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rubNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      rubNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rubNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      rubNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rubNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      rubNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rubNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      surahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      surahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      surahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      surahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tajweedSegmentsJson',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tajweedSegmentsJson',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tajweedSegmentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tajweedSegmentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tajweedSegmentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tajweedSegmentsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tajweedSegmentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tajweedSegmentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tajweedSegmentsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tajweedSegmentsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tajweedSegmentsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      tajweedSegmentsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tajweedSegmentsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'textEn',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'textEn',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textEn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textEn',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textEnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textEn',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'textKu',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'textKu',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textKu',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textKu',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textUthmaniEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textUthmani',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textUthmaniGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textUthmani',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textUthmaniLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textUthmani',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textUthmaniBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textUthmani',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textUthmaniStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textUthmani',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textUthmaniEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textUthmani',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textUthmaniContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textUthmani',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textUthmaniMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textUthmani',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textUthmaniIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textUthmani',
        value: '',
      ));
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterFilterCondition>
      textUthmaniIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textUthmani',
        value: '',
      ));
    });
  }
}

extension AyahCollectionQueryObject
    on QueryBuilder<AyahCollection, AyahCollection, QFilterCondition> {}

extension AyahCollectionQueryLinks
    on QueryBuilder<AyahCollection, AyahCollection, QFilterCondition> {}

extension AyahCollectionQuerySortBy
    on QueryBuilder<AyahCollection, AyahCollection, QSortBy> {
  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> sortByAyahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahId', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByAyahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahId', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByHizbNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hizbNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByHizbNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hizbNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> sortByJuzNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'juzNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByJuzNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'juzNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByPageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> sortByRubNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rubNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByRubNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rubNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByTajweedSegmentsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tajweedSegmentsJson', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByTajweedSegmentsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tajweedSegmentsJson', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> sortByTextEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEn', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByTextEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEn', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> sortByTextKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textKu', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByTextKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textKu', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByTextUthmani() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textUthmani', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      sortByTextUthmaniDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textUthmani', Sort.desc);
    });
  }
}

extension AyahCollectionQuerySortThenBy
    on QueryBuilder<AyahCollection, AyahCollection, QSortThenBy> {
  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> thenByAyahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahId', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByAyahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahId', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByHizbNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hizbNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByHizbNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hizbNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> thenByJuzNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'juzNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByJuzNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'juzNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByPageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> thenByRubNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rubNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByRubNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rubNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByTajweedSegmentsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tajweedSegmentsJson', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByTajweedSegmentsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tajweedSegmentsJson', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> thenByTextEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEn', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByTextEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textEn', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy> thenByTextKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textKu', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByTextKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textKu', Sort.desc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByTextUthmani() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textUthmani', Sort.asc);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QAfterSortBy>
      thenByTextUthmaniDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textUthmani', Sort.desc);
    });
  }
}

extension AyahCollectionQueryWhereDistinct
    on QueryBuilder<AyahCollection, AyahCollection, QDistinct> {
  QueryBuilder<AyahCollection, AyahCollection, QDistinct> distinctByAyahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayahId');
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QDistinct>
      distinctByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayahNumber');
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QDistinct>
      distinctByHizbNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hizbNumber');
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QDistinct>
      distinctByJuzNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'juzNumber');
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QDistinct>
      distinctByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageNumber');
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QDistinct>
      distinctByRubNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rubNumber');
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QDistinct>
      distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QDistinct>
      distinctByTajweedSegmentsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tajweedSegmentsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QDistinct> distinctByTextEn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textEn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QDistinct> distinctByTextKu(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AyahCollection, AyahCollection, QDistinct> distinctByTextUthmani(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textUthmani', caseSensitive: caseSensitive);
    });
  }
}

extension AyahCollectionQueryProperty
    on QueryBuilder<AyahCollection, AyahCollection, QQueryProperty> {
  QueryBuilder<AyahCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AyahCollection, int, QQueryOperations> ayahIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayahId');
    });
  }

  QueryBuilder<AyahCollection, int, QQueryOperations> ayahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayahNumber');
    });
  }

  QueryBuilder<AyahCollection, int?, QQueryOperations> hizbNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hizbNumber');
    });
  }

  QueryBuilder<AyahCollection, int?, QQueryOperations> juzNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'juzNumber');
    });
  }

  QueryBuilder<AyahCollection, int?, QQueryOperations> pageNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageNumber');
    });
  }

  QueryBuilder<AyahCollection, int?, QQueryOperations> rubNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rubNumber');
    });
  }

  QueryBuilder<AyahCollection, int, QQueryOperations> surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }

  QueryBuilder<AyahCollection, String?, QQueryOperations>
      tajweedSegmentsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tajweedSegmentsJson');
    });
  }

  QueryBuilder<AyahCollection, String?, QQueryOperations> textEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textEn');
    });
  }

  QueryBuilder<AyahCollection, String?, QQueryOperations> textKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textKu');
    });
  }

  QueryBuilder<AyahCollection, String, QQueryOperations> textUthmaniProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textUthmani');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTajweedRuleCollectionCollection on Isar {
  IsarCollection<TajweedRuleCollection> get tajweedRuleCollections =>
      this.collection();
}

final TajweedRuleCollectionSchema = CollectionSchema(
  name: r'TajweedRuleCollection',
  id: int.parse('8322403600735904063'),
  properties: {
    r'colorCode': PropertySchema(
      id: 0,
      name: r'colorCode',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'nameAr': PropertySchema(
      id: 2,
      name: r'nameAr',
      type: IsarType.string,
    ),
    r'nameEn': PropertySchema(
      id: 3,
      name: r'nameEn',
      type: IsarType.string,
    ),
    r'nameKu': PropertySchema(
      id: 4,
      name: r'nameKu',
      type: IsarType.string,
    ),
    r'ruleSlug': PropertySchema(
      id: 5,
      name: r'ruleSlug',
      type: IsarType.string,
    )
  },
  estimateSize: _tajweedRuleCollectionEstimateSize,
  serialize: _tajweedRuleCollectionSerialize,
  deserialize: _tajweedRuleCollectionDeserialize,
  deserializeProp: _tajweedRuleCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'ruleSlug': IndexSchema(
      id: int.parse('2455194139345975593'),
      name: r'ruleSlug',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ruleSlug',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tajweedRuleCollectionGetId,
  getLinks: _tajweedRuleCollectionGetLinks,
  attach: _tajweedRuleCollectionAttach,
  version: '3.1.0+1',
);

int _tajweedRuleCollectionEstimateSize(
  TajweedRuleCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.colorCode.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.nameAr.length * 3;
  bytesCount += 3 + object.nameEn.length * 3;
  bytesCount += 3 + object.nameKu.length * 3;
  bytesCount += 3 + object.ruleSlug.length * 3;
  return bytesCount;
}

void _tajweedRuleCollectionSerialize(
  TajweedRuleCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.colorCode);
  writer.writeString(offsets[1], object.description);
  writer.writeString(offsets[2], object.nameAr);
  writer.writeString(offsets[3], object.nameEn);
  writer.writeString(offsets[4], object.nameKu);
  writer.writeString(offsets[5], object.ruleSlug);
}

TajweedRuleCollection _tajweedRuleCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TajweedRuleCollection(
    colorCode: reader.readString(offsets[0]),
    description: reader.readStringOrNull(offsets[1]),
    nameAr: reader.readString(offsets[2]),
    nameEn: reader.readString(offsets[3]),
    nameKu: reader.readString(offsets[4]),
    ruleSlug: reader.readString(offsets[5]),
  );
  object.id = id;
  return object;
}

P _tajweedRuleCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tajweedRuleCollectionGetId(TajweedRuleCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tajweedRuleCollectionGetLinks(
    TajweedRuleCollection object) {
  return [];
}

void _tajweedRuleCollectionAttach(
    IsarCollection<dynamic> col, Id id, TajweedRuleCollection object) {
  object.id = id;
}

extension TajweedRuleCollectionByIndex
    on IsarCollection<TajweedRuleCollection> {
  Future<TajweedRuleCollection?> getByRuleSlug(String ruleSlug) {
    return getByIndex(r'ruleSlug', [ruleSlug]);
  }

  TajweedRuleCollection? getByRuleSlugSync(String ruleSlug) {
    return getByIndexSync(r'ruleSlug', [ruleSlug]);
  }

  Future<bool> deleteByRuleSlug(String ruleSlug) {
    return deleteByIndex(r'ruleSlug', [ruleSlug]);
  }

  bool deleteByRuleSlugSync(String ruleSlug) {
    return deleteByIndexSync(r'ruleSlug', [ruleSlug]);
  }

  Future<List<TajweedRuleCollection?>> getAllByRuleSlug(
      List<String> ruleSlugValues) {
    final values = ruleSlugValues.map((e) => [e]).toList();
    return getAllByIndex(r'ruleSlug', values);
  }

  List<TajweedRuleCollection?> getAllByRuleSlugSync(
      List<String> ruleSlugValues) {
    final values = ruleSlugValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'ruleSlug', values);
  }

  Future<int> deleteAllByRuleSlug(List<String> ruleSlugValues) {
    final values = ruleSlugValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'ruleSlug', values);
  }

  int deleteAllByRuleSlugSync(List<String> ruleSlugValues) {
    final values = ruleSlugValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'ruleSlug', values);
  }

  Future<Id> putByRuleSlug(TajweedRuleCollection object) {
    return putByIndex(r'ruleSlug', object);
  }

  Id putByRuleSlugSync(TajweedRuleCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'ruleSlug', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRuleSlug(List<TajweedRuleCollection> objects) {
    return putAllByIndex(r'ruleSlug', objects);
  }

  List<Id> putAllByRuleSlugSync(List<TajweedRuleCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'ruleSlug', objects, saveLinks: saveLinks);
  }
}

extension TajweedRuleCollectionQueryWhereSort
    on QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QWhere> {
  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TajweedRuleCollectionQueryWhere on QueryBuilder<TajweedRuleCollection,
    TajweedRuleCollection, QWhereClause> {
  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterWhereClause>
      ruleSlugEqualTo(String ruleSlug) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ruleSlug',
        value: [ruleSlug],
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterWhereClause>
      ruleSlugNotEqualTo(String ruleSlug) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ruleSlug',
              lower: [],
              upper: [ruleSlug],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ruleSlug',
              lower: [ruleSlug],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ruleSlug',
              lower: [ruleSlug],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ruleSlug',
              lower: [],
              upper: [ruleSlug],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TajweedRuleCollectionQueryFilter on QueryBuilder<
    TajweedRuleCollection, TajweedRuleCollection, QFilterCondition> {
  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> colorCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> colorCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> colorCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> colorCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> colorCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'colorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> colorCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'colorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      colorCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'colorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      colorCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'colorCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> colorCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorCode',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> colorCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'colorCode',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameArEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameArGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameArLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameArBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameAr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameArStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameArEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      nameArContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      nameArMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameEnEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameEnGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameEnLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameEnBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameEnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameEnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      nameEnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      nameEnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameEn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameEnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameEn',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameEnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameEn',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      nameKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      nameKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> nameKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> ruleSlugEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ruleSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> ruleSlugGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ruleSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> ruleSlugLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ruleSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> ruleSlugBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ruleSlug',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> ruleSlugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ruleSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> ruleSlugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ruleSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      ruleSlugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ruleSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
          QAfterFilterCondition>
      ruleSlugMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ruleSlug',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> ruleSlugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ruleSlug',
        value: '',
      ));
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection,
      QAfterFilterCondition> ruleSlugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ruleSlug',
        value: '',
      ));
    });
  }
}

extension TajweedRuleCollectionQueryObject on QueryBuilder<
    TajweedRuleCollection, TajweedRuleCollection, QFilterCondition> {}

extension TajweedRuleCollectionQueryLinks on QueryBuilder<TajweedRuleCollection,
    TajweedRuleCollection, QFilterCondition> {}

extension TajweedRuleCollectionQuerySortBy
    on QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QSortBy> {
  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByColorCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorCode', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByColorCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorCode', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByNameEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByNameEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByRuleSlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ruleSlug', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      sortByRuleSlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ruleSlug', Sort.desc);
    });
  }
}

extension TajweedRuleCollectionQuerySortThenBy
    on QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QSortThenBy> {
  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByColorCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorCode', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByColorCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorCode', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByNameEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByNameEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameEn', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.desc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByRuleSlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ruleSlug', Sort.asc);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QAfterSortBy>
      thenByRuleSlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ruleSlug', Sort.desc);
    });
  }
}

extension TajweedRuleCollectionQueryWhereDistinct
    on QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QDistinct> {
  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QDistinct>
      distinctByColorCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QDistinct>
      distinctByNameAr({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QDistinct>
      distinctByNameEn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameEn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QDistinct>
      distinctByNameKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TajweedRuleCollection, TajweedRuleCollection, QDistinct>
      distinctByRuleSlug({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ruleSlug', caseSensitive: caseSensitive);
    });
  }
}

extension TajweedRuleCollectionQueryProperty on QueryBuilder<
    TajweedRuleCollection, TajweedRuleCollection, QQueryProperty> {
  QueryBuilder<TajweedRuleCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TajweedRuleCollection, String, QQueryOperations>
      colorCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorCode');
    });
  }

  QueryBuilder<TajweedRuleCollection, String?, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<TajweedRuleCollection, String, QQueryOperations>
      nameArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameAr');
    });
  }

  QueryBuilder<TajweedRuleCollection, String, QQueryOperations>
      nameEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameEn');
    });
  }

  QueryBuilder<TajweedRuleCollection, String, QQueryOperations>
      nameKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameKu');
    });
  }

  QueryBuilder<TajweedRuleCollection, String, QQueryOperations>
      ruleSlugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ruleSlug');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPrayerTimesCollectionCollection on Isar {
  IsarCollection<PrayerTimesCollection> get prayerTimesCollections =>
      this.collection();
}

final PrayerTimesCollectionSchema = CollectionSchema(
  name: r'PrayerTimesCollection',
  id: int.parse('2405109234651288703'),
  properties: {
    r'cacheKey': PropertySchema(
      id: 0,
      name: r'cacheKey',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.string,
    ),
    r'latitude': PropertySchema(
      id: 2,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'locationHash': PropertySchema(
      id: 3,
      name: r'locationHash',
      type: IsarType.string,
    ),
    r'longitude': PropertySchema(
      id: 4,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'prayerTimesJson': PropertySchema(
      id: 5,
      name: r'prayerTimesJson',
      type: IsarType.string,
    )
  },
  estimateSize: _prayerTimesCollectionEstimateSize,
  serialize: _prayerTimesCollectionSerialize,
  deserialize: _prayerTimesCollectionDeserialize,
  deserializeProp: _prayerTimesCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'cacheKey': IndexSchema(
      id: int.parse('5885332021012296610'),
      name: r'cacheKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'cacheKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _prayerTimesCollectionGetId,
  getLinks: _prayerTimesCollectionGetLinks,
  attach: _prayerTimesCollectionAttach,
  version: '3.1.0+1',
);

int _prayerTimesCollectionEstimateSize(
  PrayerTimesCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cacheKey.length * 3;
  bytesCount += 3 + object.date.length * 3;
  bytesCount += 3 + object.locationHash.length * 3;
  bytesCount += 3 + object.prayerTimesJson.length * 3;
  return bytesCount;
}

void _prayerTimesCollectionSerialize(
  PrayerTimesCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cacheKey);
  writer.writeString(offsets[1], object.date);
  writer.writeDouble(offsets[2], object.latitude);
  writer.writeString(offsets[3], object.locationHash);
  writer.writeDouble(offsets[4], object.longitude);
  writer.writeString(offsets[5], object.prayerTimesJson);
}

PrayerTimesCollection _prayerTimesCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PrayerTimesCollection(
    cacheKey: reader.readString(offsets[0]),
    date: reader.readString(offsets[1]),
    latitude: reader.readDouble(offsets[2]),
    locationHash: reader.readString(offsets[3]),
    longitude: reader.readDouble(offsets[4]),
    prayerTimesJson: reader.readString(offsets[5]),
  );
  object.id = id;
  return object;
}

P _prayerTimesCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _prayerTimesCollectionGetId(PrayerTimesCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _prayerTimesCollectionGetLinks(
    PrayerTimesCollection object) {
  return [];
}

void _prayerTimesCollectionAttach(
    IsarCollection<dynamic> col, Id id, PrayerTimesCollection object) {
  object.id = id;
}

extension PrayerTimesCollectionByIndex
    on IsarCollection<PrayerTimesCollection> {
  Future<PrayerTimesCollection?> getByCacheKey(String cacheKey) {
    return getByIndex(r'cacheKey', [cacheKey]);
  }

  PrayerTimesCollection? getByCacheKeySync(String cacheKey) {
    return getByIndexSync(r'cacheKey', [cacheKey]);
  }

  Future<bool> deleteByCacheKey(String cacheKey) {
    return deleteByIndex(r'cacheKey', [cacheKey]);
  }

  bool deleteByCacheKeySync(String cacheKey) {
    return deleteByIndexSync(r'cacheKey', [cacheKey]);
  }

  Future<List<PrayerTimesCollection?>> getAllByCacheKey(
      List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'cacheKey', values);
  }

  List<PrayerTimesCollection?> getAllByCacheKeySync(
      List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'cacheKey', values);
  }

  Future<int> deleteAllByCacheKey(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'cacheKey', values);
  }

  int deleteAllByCacheKeySync(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'cacheKey', values);
  }

  Future<Id> putByCacheKey(PrayerTimesCollection object) {
    return putByIndex(r'cacheKey', object);
  }

  Id putByCacheKeySync(PrayerTimesCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'cacheKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCacheKey(List<PrayerTimesCollection> objects) {
    return putAllByIndex(r'cacheKey', objects);
  }

  List<Id> putAllByCacheKeySync(List<PrayerTimesCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'cacheKey', objects, saveLinks: saveLinks);
  }
}

extension PrayerTimesCollectionQueryWhereSort
    on QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QWhere> {
  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PrayerTimesCollectionQueryWhere on QueryBuilder<PrayerTimesCollection,
    PrayerTimesCollection, QWhereClause> {
  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterWhereClause>
      cacheKeyEqualTo(String cacheKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheKey',
        value: [cacheKey],
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterWhereClause>
      cacheKeyNotEqualTo(String cacheKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [],
              upper: [cacheKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [cacheKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [cacheKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [],
              upper: [cacheKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PrayerTimesCollectionQueryFilter on QueryBuilder<
    PrayerTimesCollection, PrayerTimesCollection, QFilterCondition> {
  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> cacheKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> cacheKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> cacheKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> cacheKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cacheKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> cacheKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> cacheKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
          QAfterFilterCondition>
      cacheKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
          QAfterFilterCondition>
      cacheKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cacheKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> cacheKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> cacheKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
          QAfterFilterCondition>
      dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
          QAfterFilterCondition>
      dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> locationHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> locationHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locationHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> locationHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locationHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> locationHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locationHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> locationHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'locationHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> locationHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'locationHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
          QAfterFilterCondition>
      locationHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'locationHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
          QAfterFilterCondition>
      locationHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'locationHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> locationHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationHash',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> locationHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'locationHash',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> prayerTimesJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prayerTimesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> prayerTimesJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prayerTimesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> prayerTimesJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prayerTimesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> prayerTimesJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prayerTimesJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> prayerTimesJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prayerTimesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> prayerTimesJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prayerTimesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
          QAfterFilterCondition>
      prayerTimesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prayerTimesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
          QAfterFilterCondition>
      prayerTimesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prayerTimesJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> prayerTimesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prayerTimesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection,
      QAfterFilterCondition> prayerTimesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prayerTimesJson',
        value: '',
      ));
    });
  }
}

extension PrayerTimesCollectionQueryObject on QueryBuilder<
    PrayerTimesCollection, PrayerTimesCollection, QFilterCondition> {}

extension PrayerTimesCollectionQueryLinks on QueryBuilder<PrayerTimesCollection,
    PrayerTimesCollection, QFilterCondition> {}

extension PrayerTimesCollectionQuerySortBy
    on QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QSortBy> {
  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByCacheKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByLocationHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationHash', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByLocationHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationHash', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByPrayerTimesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerTimesJson', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      sortByPrayerTimesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerTimesJson', Sort.desc);
    });
  }
}

extension PrayerTimesCollectionQuerySortThenBy
    on QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QSortThenBy> {
  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByCacheKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByLocationHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationHash', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByLocationHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationHash', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByPrayerTimesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerTimesJson', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QAfterSortBy>
      thenByPrayerTimesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerTimesJson', Sort.desc);
    });
  }
}

extension PrayerTimesCollectionQueryWhereDistinct
    on QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QDistinct> {
  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QDistinct>
      distinctByCacheKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QDistinct>
      distinctByDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QDistinct>
      distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QDistinct>
      distinctByLocationHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locationHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QDistinct>
      distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<PrayerTimesCollection, PrayerTimesCollection, QDistinct>
      distinctByPrayerTimesJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prayerTimesJson',
          caseSensitive: caseSensitive);
    });
  }
}

extension PrayerTimesCollectionQueryProperty on QueryBuilder<
    PrayerTimesCollection, PrayerTimesCollection, QQueryProperty> {
  QueryBuilder<PrayerTimesCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PrayerTimesCollection, String, QQueryOperations>
      cacheKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheKey');
    });
  }

  QueryBuilder<PrayerTimesCollection, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<PrayerTimesCollection, double, QQueryOperations>
      latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<PrayerTimesCollection, String, QQueryOperations>
      locationHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationHash');
    });
  }

  QueryBuilder<PrayerTimesCollection, double, QQueryOperations>
      longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<PrayerTimesCollection, String, QQueryOperations>
      prayerTimesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prayerTimesJson');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMemorizationPlanCollectionCollection on Isar {
  IsarCollection<MemorizationPlanCollection> get memorizationPlanCollections =>
      this.collection();
}

final MemorizationPlanCollectionSchema = CollectionSchema(
  name: r'MemorizationPlanCollection',
  id: int.parse('4432947998175925090'),
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'fromAyah': PropertySchema(
      id: 1,
      name: r'fromAyah',
      type: IsarType.long,
    ),
    r'isSynced': PropertySchema(
      id: 2,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'notes': PropertySchema(
      id: 3,
      name: r'notes',
      type: IsarType.string,
    ),
    r'planId': PropertySchema(
      id: 4,
      name: r'planId',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 5,
      name: r'status',
      type: IsarType.string,
    ),
    r'surahId': PropertySchema(
      id: 6,
      name: r'surahId',
      type: IsarType.long,
    ),
    r'toAyah': PropertySchema(
      id: 7,
      name: r'toAyah',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _memorizationPlanCollectionEstimateSize,
  serialize: _memorizationPlanCollectionSerialize,
  deserialize: _memorizationPlanCollectionDeserialize,
  deserializeProp: _memorizationPlanCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'planId': IndexSchema(
      id: int.parse('7282644713036731817'),
      name: r'planId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'planId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _memorizationPlanCollectionGetId,
  getLinks: _memorizationPlanCollectionGetLinks,
  attach: _memorizationPlanCollectionAttach,
  version: '3.1.0+1',
);

int _memorizationPlanCollectionEstimateSize(
  MemorizationPlanCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.planId.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _memorizationPlanCollectionSerialize(
  MemorizationPlanCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.fromAyah);
  writer.writeBool(offsets[2], object.isSynced);
  writer.writeString(offsets[3], object.notes);
  writer.writeString(offsets[4], object.planId);
  writer.writeString(offsets[5], object.status);
  writer.writeLong(offsets[6], object.surahId);
  writer.writeLong(offsets[7], object.toAyah);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

MemorizationPlanCollection _memorizationPlanCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MemorizationPlanCollection(
    createdAt: reader.readDateTime(offsets[0]),
    fromAyah: reader.readLong(offsets[1]),
    isSynced: reader.readBool(offsets[2]),
    notes: reader.readStringOrNull(offsets[3]),
    planId: reader.readString(offsets[4]),
    status: reader.readString(offsets[5]),
    surahId: reader.readLong(offsets[6]),
    toAyah: reader.readLong(offsets[7]),
    updatedAt: reader.readDateTime(offsets[8]),
  );
  object.id = id;
  return object;
}

P _memorizationPlanCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _memorizationPlanCollectionGetId(MemorizationPlanCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _memorizationPlanCollectionGetLinks(
    MemorizationPlanCollection object) {
  return [];
}

void _memorizationPlanCollectionAttach(
    IsarCollection<dynamic> col, Id id, MemorizationPlanCollection object) {
  object.id = id;
}

extension MemorizationPlanCollectionByIndex
    on IsarCollection<MemorizationPlanCollection> {
  Future<MemorizationPlanCollection?> getByPlanId(String planId) {
    return getByIndex(r'planId', [planId]);
  }

  MemorizationPlanCollection? getByPlanIdSync(String planId) {
    return getByIndexSync(r'planId', [planId]);
  }

  Future<bool> deleteByPlanId(String planId) {
    return deleteByIndex(r'planId', [planId]);
  }

  bool deleteByPlanIdSync(String planId) {
    return deleteByIndexSync(r'planId', [planId]);
  }

  Future<List<MemorizationPlanCollection?>> getAllByPlanId(
      List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'planId', values);
  }

  List<MemorizationPlanCollection?> getAllByPlanIdSync(
      List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'planId', values);
  }

  Future<int> deleteAllByPlanId(List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'planId', values);
  }

  int deleteAllByPlanIdSync(List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'planId', values);
  }

  Future<Id> putByPlanId(MemorizationPlanCollection object) {
    return putByIndex(r'planId', object);
  }

  Id putByPlanIdSync(MemorizationPlanCollection object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'planId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPlanId(List<MemorizationPlanCollection> objects) {
    return putAllByIndex(r'planId', objects);
  }

  List<Id> putAllByPlanIdSync(List<MemorizationPlanCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'planId', objects, saveLinks: saveLinks);
  }
}

extension MemorizationPlanCollectionQueryWhereSort on QueryBuilder<
    MemorizationPlanCollection, MemorizationPlanCollection, QWhere> {
  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MemorizationPlanCollectionQueryWhere on QueryBuilder<
    MemorizationPlanCollection, MemorizationPlanCollection, QWhereClause> {
  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterWhereClause> planIdEqualTo(String planId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'planId',
        value: [planId],
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterWhereClause> planIdNotEqualTo(String planId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId',
              lower: [],
              upper: [planId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId',
              lower: [planId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId',
              lower: [planId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId',
              lower: [],
              upper: [planId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MemorizationPlanCollectionQueryFilter on QueryBuilder<
    MemorizationPlanCollection, MemorizationPlanCollection, QFilterCondition> {
  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> fromAyahEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fromAyah',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> fromAyahGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fromAyah',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> fromAyahLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fromAyah',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> fromAyahBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fromAyah',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
          QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
          QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> planIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> planIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> planIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> planIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> planIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> planIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
          QAfterFilterCondition>
      planIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
          QAfterFilterCondition>
      planIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'planId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> planIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> planIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
          QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
          QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> surahIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahId',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> surahIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahId',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> surahIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahId',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> surahIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> toAyahEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toAyah',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> toAyahGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toAyah',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> toAyahLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toAyah',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> toAyahBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toAyah',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MemorizationPlanCollectionQueryObject on QueryBuilder<
    MemorizationPlanCollection, MemorizationPlanCollection, QFilterCondition> {}

extension MemorizationPlanCollectionQueryLinks on QueryBuilder<
    MemorizationPlanCollection, MemorizationPlanCollection, QFilterCondition> {}

extension MemorizationPlanCollectionQuerySortBy on QueryBuilder<
    MemorizationPlanCollection, MemorizationPlanCollection, QSortBy> {
  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByFromAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromAyah', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByFromAyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromAyah', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortBySurahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortBySurahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByToAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAyah', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByToAyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAyah', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MemorizationPlanCollectionQuerySortThenBy on QueryBuilder<
    MemorizationPlanCollection, MemorizationPlanCollection, QSortThenBy> {
  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByFromAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromAyah', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByFromAyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromAyah', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenBySurahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenBySurahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByToAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAyah', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByToAyahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toAyah', Sort.desc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MemorizationPlanCollectionQueryWhereDistinct on QueryBuilder<
    MemorizationPlanCollection, MemorizationPlanCollection, QDistinct> {
  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QDistinct> distinctByFromAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fromAyah');
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QDistinct> distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QDistinct> distinctByPlanId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QDistinct> distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QDistinct> distinctBySurahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahId');
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QDistinct> distinctByToAyah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toAyah');
    });
  }

  QueryBuilder<MemorizationPlanCollection, MemorizationPlanCollection,
      QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MemorizationPlanCollectionQueryProperty on QueryBuilder<
    MemorizationPlanCollection, MemorizationPlanCollection, QQueryProperty> {
  QueryBuilder<MemorizationPlanCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MemorizationPlanCollection, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MemorizationPlanCollection, int, QQueryOperations>
      fromAyahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fromAyah');
    });
  }

  QueryBuilder<MemorizationPlanCollection, bool, QQueryOperations>
      isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<MemorizationPlanCollection, String?, QQueryOperations>
      notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<MemorizationPlanCollection, String, QQueryOperations>
      planIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planId');
    });
  }

  QueryBuilder<MemorizationPlanCollection, String, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<MemorizationPlanCollection, int, QQueryOperations>
      surahIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahId');
    });
  }

  QueryBuilder<MemorizationPlanCollection, int, QQueryOperations>
      toAyahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toAyah');
    });
  }

  QueryBuilder<MemorizationPlanCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMemorizationReviewCollectionCollection on Isar {
  IsarCollection<MemorizationReviewCollection>
      get memorizationReviewCollections => this.collection();
}

final MemorizationReviewCollectionSchema = CollectionSchema(
  name: r'MemorizationReviewCollection',
  id: -int.parse('3956903754914043338'),
  properties: {
    r'isSynced': PropertySchema(
      id: 0,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'performance': PropertySchema(
      id: 1,
      name: r'performance',
      type: IsarType.string,
    ),
    r'planId': PropertySchema(
      id: 2,
      name: r'planId',
      type: IsarType.string,
    ),
    r'reviewId': PropertySchema(
      id: 3,
      name: r'reviewId',
      type: IsarType.string,
    ),
    r'reviewedAt': PropertySchema(
      id: 4,
      name: r'reviewedAt',
      type: IsarType.dateTime,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _memorizationReviewCollectionEstimateSize,
  serialize: _memorizationReviewCollectionSerialize,
  deserialize: _memorizationReviewCollectionDeserialize,
  deserializeProp: _memorizationReviewCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'reviewId': IndexSchema(
      id: int.parse('392236526580651382'),
      name: r'reviewId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reviewId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _memorizationReviewCollectionGetId,
  getLinks: _memorizationReviewCollectionGetLinks,
  attach: _memorizationReviewCollectionAttach,
  version: '3.1.0+1',
);

int _memorizationReviewCollectionEstimateSize(
  MemorizationReviewCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.performance.length * 3;
  bytesCount += 3 + object.planId.length * 3;
  bytesCount += 3 + object.reviewId.length * 3;
  return bytesCount;
}

void _memorizationReviewCollectionSerialize(
  MemorizationReviewCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isSynced);
  writer.writeString(offsets[1], object.performance);
  writer.writeString(offsets[2], object.planId);
  writer.writeString(offsets[3], object.reviewId);
  writer.writeDateTime(offsets[4], object.reviewedAt);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

MemorizationReviewCollection _memorizationReviewCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MemorizationReviewCollection(
    isSynced: reader.readBool(offsets[0]),
    performance: reader.readString(offsets[1]),
    planId: reader.readString(offsets[2]),
    reviewId: reader.readString(offsets[3]),
    reviewedAt: reader.readDateTime(offsets[4]),
    updatedAt: reader.readDateTime(offsets[5]),
  );
  object.id = id;
  return object;
}

P _memorizationReviewCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _memorizationReviewCollectionGetId(MemorizationReviewCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _memorizationReviewCollectionGetLinks(
    MemorizationReviewCollection object) {
  return [];
}

void _memorizationReviewCollectionAttach(
    IsarCollection<dynamic> col, Id id, MemorizationReviewCollection object) {
  object.id = id;
}

extension MemorizationReviewCollectionByIndex
    on IsarCollection<MemorizationReviewCollection> {
  Future<MemorizationReviewCollection?> getByReviewId(String reviewId) {
    return getByIndex(r'reviewId', [reviewId]);
  }

  MemorizationReviewCollection? getByReviewIdSync(String reviewId) {
    return getByIndexSync(r'reviewId', [reviewId]);
  }

  Future<bool> deleteByReviewId(String reviewId) {
    return deleteByIndex(r'reviewId', [reviewId]);
  }

  bool deleteByReviewIdSync(String reviewId) {
    return deleteByIndexSync(r'reviewId', [reviewId]);
  }

  Future<List<MemorizationReviewCollection?>> getAllByReviewId(
      List<String> reviewIdValues) {
    final values = reviewIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'reviewId', values);
  }

  List<MemorizationReviewCollection?> getAllByReviewIdSync(
      List<String> reviewIdValues) {
    final values = reviewIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'reviewId', values);
  }

  Future<int> deleteAllByReviewId(List<String> reviewIdValues) {
    final values = reviewIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'reviewId', values);
  }

  int deleteAllByReviewIdSync(List<String> reviewIdValues) {
    final values = reviewIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'reviewId', values);
  }

  Future<Id> putByReviewId(MemorizationReviewCollection object) {
    return putByIndex(r'reviewId', object);
  }

  Id putByReviewIdSync(MemorizationReviewCollection object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'reviewId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByReviewId(
      List<MemorizationReviewCollection> objects) {
    return putAllByIndex(r'reviewId', objects);
  }

  List<Id> putAllByReviewIdSync(List<MemorizationReviewCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'reviewId', objects, saveLinks: saveLinks);
  }
}

extension MemorizationReviewCollectionQueryWhereSort on QueryBuilder<
    MemorizationReviewCollection, MemorizationReviewCollection, QWhere> {
  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MemorizationReviewCollectionQueryWhere on QueryBuilder<
    MemorizationReviewCollection, MemorizationReviewCollection, QWhereClause> {
  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterWhereClause> reviewIdEqualTo(String reviewId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reviewId',
        value: [reviewId],
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterWhereClause> reviewIdNotEqualTo(String reviewId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reviewId',
              lower: [],
              upper: [reviewId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reviewId',
              lower: [reviewId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reviewId',
              lower: [reviewId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reviewId',
              lower: [],
              upper: [reviewId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MemorizationReviewCollectionQueryFilter on QueryBuilder<
    MemorizationReviewCollection,
    MemorizationReviewCollection,
    QFilterCondition> {
  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> performanceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'performance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> performanceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'performance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> performanceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'performance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> performanceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'performance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> performanceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'performance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> performanceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'performance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
          QAfterFilterCondition>
      performanceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'performance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
          QAfterFilterCondition>
      performanceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'performance',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> performanceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'performance',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> performanceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'performance',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> planIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> planIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> planIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> planIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> planIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> planIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
          QAfterFilterCondition>
      planIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
          QAfterFilterCondition>
      planIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'planId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> planIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> planIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reviewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reviewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reviewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reviewId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reviewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reviewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
          QAfterFilterCondition>
      reviewIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reviewId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
          QAfterFilterCondition>
      reviewIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reviewId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reviewId',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reviewId',
        value: '',
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> reviewedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reviewedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MemorizationReviewCollectionQueryObject on QueryBuilder<
    MemorizationReviewCollection,
    MemorizationReviewCollection,
    QFilterCondition> {}

extension MemorizationReviewCollectionQueryLinks on QueryBuilder<
    MemorizationReviewCollection,
    MemorizationReviewCollection,
    QFilterCondition> {}

extension MemorizationReviewCollectionQuerySortBy on QueryBuilder<
    MemorizationReviewCollection, MemorizationReviewCollection, QSortBy> {
  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByPerformance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performance', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByPerformanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performance', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByReviewId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewId', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByReviewIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewId', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MemorizationReviewCollectionQuerySortThenBy on QueryBuilder<
    MemorizationReviewCollection, MemorizationReviewCollection, QSortThenBy> {
  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByPerformance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performance', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByPerformanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performance', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByReviewId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewId', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByReviewIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewId', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.desc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MemorizationReviewCollectionQueryWhereDistinct on QueryBuilder<
    MemorizationReviewCollection, MemorizationReviewCollection, QDistinct> {
  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QDistinct> distinctByPerformance({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'performance', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QDistinct> distinctByPlanId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QDistinct> distinctByReviewId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reviewId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QDistinct> distinctByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reviewedAt');
    });
  }

  QueryBuilder<MemorizationReviewCollection, MemorizationReviewCollection,
      QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MemorizationReviewCollectionQueryProperty on QueryBuilder<
    MemorizationReviewCollection,
    MemorizationReviewCollection,
    QQueryProperty> {
  QueryBuilder<MemorizationReviewCollection, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MemorizationReviewCollection, bool, QQueryOperations>
      isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<MemorizationReviewCollection, String, QQueryOperations>
      performanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'performance');
    });
  }

  QueryBuilder<MemorizationReviewCollection, String, QQueryOperations>
      planIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planId');
    });
  }

  QueryBuilder<MemorizationReviewCollection, String, QQueryOperations>
      reviewIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reviewId');
    });
  }

  QueryBuilder<MemorizationReviewCollection, DateTime, QQueryOperations>
      reviewedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reviewedAt');
    });
  }

  QueryBuilder<MemorizationReviewCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTasbihSessionCollectionCollection on Isar {
  IsarCollection<TasbihSessionCollection> get tasbihSessionCollections =>
      this.collection();
}

final TasbihSessionCollectionSchema = CollectionSchema(
  name: r'TasbihSessionCollection',
  id: int.parse('6038320167572759588'),
  properties: {
    r'avgPerMinute': PropertySchema(
      id: 0,
      name: r'avgPerMinute',
      type: IsarType.double,
    ),
    r'customDhikrName': PropertySchema(
      id: 1,
      name: r'customDhikrName',
      type: IsarType.string,
    ),
    r'durationSeconds': PropertySchema(
      id: 2,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'endTime': PropertySchema(
      id: 3,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'isSynced': PropertySchema(
      id: 4,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'sessionDate': PropertySchema(
      id: 5,
      name: r'sessionDate',
      type: IsarType.string,
    ),
    r'sessionId': PropertySchema(
      id: 6,
      name: r'sessionId',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 7,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.string,
    ),
    r'totalCount': PropertySchema(
      id: 9,
      name: r'totalCount',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _tasbihSessionCollectionEstimateSize,
  serialize: _tasbihSessionCollectionSerialize,
  deserialize: _tasbihSessionCollectionDeserialize,
  deserializeProp: _tasbihSessionCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'sessionId': IndexSchema(
      id: int.parse('6949518585047923839'),
      name: r'sessionId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sessionId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tasbihSessionCollectionGetId,
  getLinks: _tasbihSessionCollectionGetLinks,
  attach: _tasbihSessionCollectionAttach,
  version: '3.1.0+1',
);

int _tasbihSessionCollectionEstimateSize(
  TasbihSessionCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.customDhikrName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sessionDate.length * 3;
  bytesCount += 3 + object.sessionId.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _tasbihSessionCollectionSerialize(
  TasbihSessionCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.avgPerMinute);
  writer.writeString(offsets[1], object.customDhikrName);
  writer.writeLong(offsets[2], object.durationSeconds);
  writer.writeDateTime(offsets[3], object.endTime);
  writer.writeBool(offsets[4], object.isSynced);
  writer.writeString(offsets[5], object.sessionDate);
  writer.writeString(offsets[6], object.sessionId);
  writer.writeDateTime(offsets[7], object.startTime);
  writer.writeString(offsets[8], object.status);
  writer.writeLong(offsets[9], object.totalCount);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

TasbihSessionCollection _tasbihSessionCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TasbihSessionCollection(
    avgPerMinute: reader.readDouble(offsets[0]),
    customDhikrName: reader.readStringOrNull(offsets[1]),
    durationSeconds: reader.readLong(offsets[2]),
    endTime: reader.readDateTimeOrNull(offsets[3]),
    isSynced: reader.readBool(offsets[4]),
    sessionDate: reader.readString(offsets[5]),
    sessionId: reader.readString(offsets[6]),
    startTime: reader.readDateTime(offsets[7]),
    status: reader.readString(offsets[8]),
    totalCount: reader.readLong(offsets[9]),
    updatedAt: reader.readDateTime(offsets[10]),
  );
  object.id = id;
  return object;
}

P _tasbihSessionCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tasbihSessionCollectionGetId(TasbihSessionCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tasbihSessionCollectionGetLinks(
    TasbihSessionCollection object) {
  return [];
}

void _tasbihSessionCollectionAttach(
    IsarCollection<dynamic> col, Id id, TasbihSessionCollection object) {
  object.id = id;
}

extension TasbihSessionCollectionByIndex
    on IsarCollection<TasbihSessionCollection> {
  Future<TasbihSessionCollection?> getBySessionId(String sessionId) {
    return getByIndex(r'sessionId', [sessionId]);
  }

  TasbihSessionCollection? getBySessionIdSync(String sessionId) {
    return getByIndexSync(r'sessionId', [sessionId]);
  }

  Future<bool> deleteBySessionId(String sessionId) {
    return deleteByIndex(r'sessionId', [sessionId]);
  }

  bool deleteBySessionIdSync(String sessionId) {
    return deleteByIndexSync(r'sessionId', [sessionId]);
  }

  Future<List<TasbihSessionCollection?>> getAllBySessionId(
      List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'sessionId', values);
  }

  List<TasbihSessionCollection?> getAllBySessionIdSync(
      List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'sessionId', values);
  }

  Future<int> deleteAllBySessionId(List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'sessionId', values);
  }

  int deleteAllBySessionIdSync(List<String> sessionIdValues) {
    final values = sessionIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'sessionId', values);
  }

  Future<Id> putBySessionId(TasbihSessionCollection object) {
    return putByIndex(r'sessionId', object);
  }

  Id putBySessionIdSync(TasbihSessionCollection object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'sessionId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySessionId(List<TasbihSessionCollection> objects) {
    return putAllByIndex(r'sessionId', objects);
  }

  List<Id> putAllBySessionIdSync(List<TasbihSessionCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'sessionId', objects, saveLinks: saveLinks);
  }
}

extension TasbihSessionCollectionQueryWhereSort
    on QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QWhere> {
  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TasbihSessionCollectionQueryWhere on QueryBuilder<
    TasbihSessionCollection, TasbihSessionCollection, QWhereClause> {
  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterWhereClause> sessionIdEqualTo(String sessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sessionId',
        value: [sessionId],
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterWhereClause> sessionIdNotEqualTo(String sessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [sessionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionId',
              lower: [],
              upper: [sessionId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TasbihSessionCollectionQueryFilter on QueryBuilder<
    TasbihSessionCollection, TasbihSessionCollection, QFilterCondition> {
  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> avgPerMinuteEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgPerMinute',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> avgPerMinuteGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgPerMinute',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> avgPerMinuteLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgPerMinute',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> avgPerMinuteBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgPerMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> customDhikrNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customDhikrName',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> customDhikrNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customDhikrName',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> customDhikrNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customDhikrName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> customDhikrNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customDhikrName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> customDhikrNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customDhikrName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> customDhikrNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customDhikrName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> customDhikrNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customDhikrName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> customDhikrNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customDhikrName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
          QAfterFilterCondition>
      customDhikrNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customDhikrName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
          QAfterFilterCondition>
      customDhikrNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customDhikrName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> customDhikrNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customDhikrName',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> customDhikrNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customDhikrName',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> durationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> durationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> durationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> durationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> endTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
          QAfterFilterCondition>
      sessionDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
          QAfterFilterCondition>
      sessionDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
          QAfterFilterCondition>
      sessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
          QAfterFilterCondition>
      sessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> sessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
          QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
          QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> totalCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> totalCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> totalCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> totalCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TasbihSessionCollectionQueryObject on QueryBuilder<
    TasbihSessionCollection, TasbihSessionCollection, QFilterCondition> {}

extension TasbihSessionCollectionQueryLinks on QueryBuilder<
    TasbihSessionCollection, TasbihSessionCollection, QFilterCondition> {}

extension TasbihSessionCollectionQuerySortBy
    on QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QSortBy> {
  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByAvgPerMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPerMinute', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByAvgPerMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPerMinute', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByCustomDhikrName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDhikrName', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByCustomDhikrNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDhikrName', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortBySessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortBySessionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TasbihSessionCollectionQuerySortThenBy on QueryBuilder<
    TasbihSessionCollection, TasbihSessionCollection, QSortThenBy> {
  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByAvgPerMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPerMinute', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByAvgPerMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgPerMinute', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByCustomDhikrName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDhikrName', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByCustomDhikrNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDhikrName', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenBySessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenBySessionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.desc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TasbihSessionCollectionQueryWhereDistinct on QueryBuilder<
    TasbihSessionCollection, TasbihSessionCollection, QDistinct> {
  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctByAvgPerMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgPerMinute');
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctByCustomDhikrName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customDhikrName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctBySessionDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctBySessionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCount');
    });
  }

  QueryBuilder<TasbihSessionCollection, TasbihSessionCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension TasbihSessionCollectionQueryProperty on QueryBuilder<
    TasbihSessionCollection, TasbihSessionCollection, QQueryProperty> {
  QueryBuilder<TasbihSessionCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TasbihSessionCollection, double, QQueryOperations>
      avgPerMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgPerMinute');
    });
  }

  QueryBuilder<TasbihSessionCollection, String?, QQueryOperations>
      customDhikrNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customDhikrName');
    });
  }

  QueryBuilder<TasbihSessionCollection, int, QQueryOperations>
      durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<TasbihSessionCollection, DateTime?, QQueryOperations>
      endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<TasbihSessionCollection, bool, QQueryOperations>
      isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<TasbihSessionCollection, String, QQueryOperations>
      sessionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionDate');
    });
  }

  QueryBuilder<TasbihSessionCollection, String, QQueryOperations>
      sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<TasbihSessionCollection, DateTime, QQueryOperations>
      startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<TasbihSessionCollection, String, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<TasbihSessionCollection, int, QQueryOperations>
      totalCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCount');
    });
  }

  QueryBuilder<TasbihSessionCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReadingHistoryCollectionCollection on Isar {
  IsarCollection<ReadingHistoryCollection> get readingHistoryCollections =>
      this.collection();
}

final ReadingHistoryCollectionSchema = CollectionSchema(
  name: r'ReadingHistoryCollection',
  id: -int.parse('2942315340283946227'),
  properties: {
    r'durationSeconds': PropertySchema(
      id: 0,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'pageNumber': PropertySchema(
      id: 1,
      name: r'pageNumber',
      type: IsarType.long,
    ),
    r'readAt': PropertySchema(
      id: 2,
      name: r'readAt',
      type: IsarType.dateTime,
    ),
    r'surahNumber': PropertySchema(
      id: 3,
      name: r'surahNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _readingHistoryCollectionEstimateSize,
  serialize: _readingHistoryCollectionSerialize,
  deserialize: _readingHistoryCollectionDeserialize,
  deserializeProp: _readingHistoryCollectionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _readingHistoryCollectionGetId,
  getLinks: _readingHistoryCollectionGetLinks,
  attach: _readingHistoryCollectionAttach,
  version: '3.1.0+1',
);

int _readingHistoryCollectionEstimateSize(
  ReadingHistoryCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _readingHistoryCollectionSerialize(
  ReadingHistoryCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationSeconds);
  writer.writeLong(offsets[1], object.pageNumber);
  writer.writeDateTime(offsets[2], object.readAt);
  writer.writeLong(offsets[3], object.surahNumber);
}

ReadingHistoryCollection _readingHistoryCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingHistoryCollection(
    durationSeconds: reader.readLong(offsets[0]),
    pageNumber: reader.readLong(offsets[1]),
    readAt: reader.readDateTime(offsets[2]),
    surahNumber: reader.readLong(offsets[3]),
  );
  object.id = id;
  return object;
}

P _readingHistoryCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _readingHistoryCollectionGetId(ReadingHistoryCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _readingHistoryCollectionGetLinks(
    ReadingHistoryCollection object) {
  return [];
}

void _readingHistoryCollectionAttach(
    IsarCollection<dynamic> col, Id id, ReadingHistoryCollection object) {
  object.id = id;
}

extension ReadingHistoryCollectionQueryWhereSort on QueryBuilder<
    ReadingHistoryCollection, ReadingHistoryCollection, QWhere> {
  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReadingHistoryCollectionQueryWhere on QueryBuilder<
    ReadingHistoryCollection, ReadingHistoryCollection, QWhereClause> {
  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReadingHistoryCollectionQueryFilter on QueryBuilder<
    ReadingHistoryCollection, ReadingHistoryCollection, QFilterCondition> {
  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> durationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> durationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> durationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> durationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> pageNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> pageNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> pageNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pageNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> pageNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pageNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> readAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> readAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> readAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> readAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> surahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> surahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> surahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection,
      QAfterFilterCondition> surahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReadingHistoryCollectionQueryObject on QueryBuilder<
    ReadingHistoryCollection, ReadingHistoryCollection, QFilterCondition> {}

extension ReadingHistoryCollectionQueryLinks on QueryBuilder<
    ReadingHistoryCollection, ReadingHistoryCollection, QFilterCondition> {}

extension ReadingHistoryCollectionQuerySortBy on QueryBuilder<
    ReadingHistoryCollection, ReadingHistoryCollection, QSortBy> {
  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      sortByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      sortByPageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      sortByReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      sortByReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }
}

extension ReadingHistoryCollectionQuerySortThenBy on QueryBuilder<
    ReadingHistoryCollection, ReadingHistoryCollection, QSortThenBy> {
  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      thenByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      thenByPageNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pageNumber', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      thenByReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      thenByReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.desc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QAfterSortBy>
      thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }
}

extension ReadingHistoryCollectionQueryWhereDistinct on QueryBuilder<
    ReadingHistoryCollection, ReadingHistoryCollection, QDistinct> {
  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QDistinct>
      distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QDistinct>
      distinctByPageNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pageNumber');
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QDistinct>
      distinctByReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readAt');
    });
  }

  QueryBuilder<ReadingHistoryCollection, ReadingHistoryCollection, QDistinct>
      distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }
}

extension ReadingHistoryCollectionQueryProperty on QueryBuilder<
    ReadingHistoryCollection, ReadingHistoryCollection, QQueryProperty> {
  QueryBuilder<ReadingHistoryCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReadingHistoryCollection, int, QQueryOperations>
      durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<ReadingHistoryCollection, int, QQueryOperations>
      pageNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pageNumber');
    });
  }

  QueryBuilder<ReadingHistoryCollection, DateTime, QQueryOperations>
      readAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readAt');
    });
  }

  QueryBuilder<ReadingHistoryCollection, int, QQueryOperations>
      surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBookmarkCollectionCollection on Isar {
  IsarCollection<BookmarkCollection> get bookmarkCollections =>
      this.collection();
}

final BookmarkCollectionSchema = CollectionSchema(
  name: r'BookmarkCollection',
  id: -int.parse('7433758756138560705'),
  properties: {
    r'ayahNumber': PropertySchema(
      id: 0,
      name: r'ayahNumber',
      type: IsarType.long,
    ),
    r'bookmarkId': PropertySchema(
      id: 1,
      name: r'bookmarkId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isSynced': PropertySchema(
      id: 3,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'surahNumber': PropertySchema(
      id: 4,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _bookmarkCollectionEstimateSize,
  serialize: _bookmarkCollectionSerialize,
  deserialize: _bookmarkCollectionDeserialize,
  deserializeProp: _bookmarkCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'bookmarkId': IndexSchema(
      id: int.parse('7502005763379596484'),
      name: r'bookmarkId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bookmarkId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bookmarkCollectionGetId,
  getLinks: _bookmarkCollectionGetLinks,
  attach: _bookmarkCollectionAttach,
  version: '3.1.0+1',
);

int _bookmarkCollectionEstimateSize(
  BookmarkCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookmarkId.length * 3;
  return bytesCount;
}

void _bookmarkCollectionSerialize(
  BookmarkCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ayahNumber);
  writer.writeString(offsets[1], object.bookmarkId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeBool(offsets[3], object.isSynced);
  writer.writeLong(offsets[4], object.surahNumber);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

BookmarkCollection _bookmarkCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BookmarkCollection(
    ayahNumber: reader.readLong(offsets[0]),
    bookmarkId: reader.readString(offsets[1]),
    createdAt: reader.readDateTime(offsets[2]),
    isSynced: reader.readBool(offsets[3]),
    surahNumber: reader.readLong(offsets[4]),
    updatedAt: reader.readDateTime(offsets[5]),
  );
  object.id = id;
  return object;
}

P _bookmarkCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bookmarkCollectionGetId(BookmarkCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bookmarkCollectionGetLinks(
    BookmarkCollection object) {
  return [];
}

void _bookmarkCollectionAttach(
    IsarCollection<dynamic> col, Id id, BookmarkCollection object) {
  object.id = id;
}

extension BookmarkCollectionByIndex on IsarCollection<BookmarkCollection> {
  Future<BookmarkCollection?> getByBookmarkId(String bookmarkId) {
    return getByIndex(r'bookmarkId', [bookmarkId]);
  }

  BookmarkCollection? getByBookmarkIdSync(String bookmarkId) {
    return getByIndexSync(r'bookmarkId', [bookmarkId]);
  }

  Future<bool> deleteByBookmarkId(String bookmarkId) {
    return deleteByIndex(r'bookmarkId', [bookmarkId]);
  }

  bool deleteByBookmarkIdSync(String bookmarkId) {
    return deleteByIndexSync(r'bookmarkId', [bookmarkId]);
  }

  Future<List<BookmarkCollection?>> getAllByBookmarkId(
      List<String> bookmarkIdValues) {
    final values = bookmarkIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'bookmarkId', values);
  }

  List<BookmarkCollection?> getAllByBookmarkIdSync(
      List<String> bookmarkIdValues) {
    final values = bookmarkIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'bookmarkId', values);
  }

  Future<int> deleteAllByBookmarkId(List<String> bookmarkIdValues) {
    final values = bookmarkIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'bookmarkId', values);
  }

  int deleteAllByBookmarkIdSync(List<String> bookmarkIdValues) {
    final values = bookmarkIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'bookmarkId', values);
  }

  Future<Id> putByBookmarkId(BookmarkCollection object) {
    return putByIndex(r'bookmarkId', object);
  }

  Id putByBookmarkIdSync(BookmarkCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'bookmarkId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBookmarkId(List<BookmarkCollection> objects) {
    return putAllByIndex(r'bookmarkId', objects);
  }

  List<Id> putAllByBookmarkIdSync(List<BookmarkCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'bookmarkId', objects, saveLinks: saveLinks);
  }
}

extension BookmarkCollectionQueryWhereSort
    on QueryBuilder<BookmarkCollection, BookmarkCollection, QWhere> {
  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BookmarkCollectionQueryWhere
    on QueryBuilder<BookmarkCollection, BookmarkCollection, QWhereClause> {
  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterWhereClause>
      bookmarkIdEqualTo(String bookmarkId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookmarkId',
        value: [bookmarkId],
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterWhereClause>
      bookmarkIdNotEqualTo(String bookmarkId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookmarkId',
              lower: [],
              upper: [bookmarkId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookmarkId',
              lower: [bookmarkId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookmarkId',
              lower: [bookmarkId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookmarkId',
              lower: [],
              upper: [bookmarkId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BookmarkCollectionQueryFilter
    on QueryBuilder<BookmarkCollection, BookmarkCollection, QFilterCondition> {
  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      ayahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      ayahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      ayahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      ayahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ayahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      bookmarkIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookmarkId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      bookmarkIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookmarkId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      bookmarkIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookmarkId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      bookmarkIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookmarkId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      bookmarkIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookmarkId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      bookmarkIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookmarkId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      bookmarkIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookmarkId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      bookmarkIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookmarkId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      bookmarkIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookmarkId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      bookmarkIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookmarkId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      surahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      surahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      surahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      surahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BookmarkCollectionQueryObject
    on QueryBuilder<BookmarkCollection, BookmarkCollection, QFilterCondition> {}

extension BookmarkCollectionQueryLinks
    on QueryBuilder<BookmarkCollection, BookmarkCollection, QFilterCondition> {}

extension BookmarkCollectionQuerySortBy
    on QueryBuilder<BookmarkCollection, BookmarkCollection, QSortBy> {
  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortByBookmarkId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarkId', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortByBookmarkIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarkId', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BookmarkCollectionQuerySortThenBy
    on QueryBuilder<BookmarkCollection, BookmarkCollection, QSortThenBy> {
  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByBookmarkId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarkId', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByBookmarkIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarkId', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BookmarkCollectionQueryWhereDistinct
    on QueryBuilder<BookmarkCollection, BookmarkCollection, QDistinct> {
  QueryBuilder<BookmarkCollection, BookmarkCollection, QDistinct>
      distinctByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayahNumber');
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QDistinct>
      distinctByBookmarkId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookmarkId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QDistinct>
      distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }

  QueryBuilder<BookmarkCollection, BookmarkCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension BookmarkCollectionQueryProperty
    on QueryBuilder<BookmarkCollection, BookmarkCollection, QQueryProperty> {
  QueryBuilder<BookmarkCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BookmarkCollection, int, QQueryOperations> ayahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayahNumber');
    });
  }

  QueryBuilder<BookmarkCollection, String, QQueryOperations>
      bookmarkIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookmarkId');
    });
  }

  QueryBuilder<BookmarkCollection, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BookmarkCollection, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<BookmarkCollection, int, QQueryOperations>
      surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }

  QueryBuilder<BookmarkCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNoteCollectionCollection on Isar {
  IsarCollection<NoteCollection> get noteCollections => this.collection();
}

final NoteCollectionSchema = CollectionSchema(
  name: r'NoteCollection',
  id: -int.parse('880493522486186259'),
  properties: {
    r'ayahNumber': PropertySchema(
      id: 0,
      name: r'ayahNumber',
      type: IsarType.long,
    ),
    r'content': PropertySchema(
      id: 1,
      name: r'content',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isSynced': PropertySchema(
      id: 3,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'noteId': PropertySchema(
      id: 4,
      name: r'noteId',
      type: IsarType.string,
    ),
    r'surahNumber': PropertySchema(
      id: 5,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _noteCollectionEstimateSize,
  serialize: _noteCollectionSerialize,
  deserialize: _noteCollectionDeserialize,
  deserializeProp: _noteCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'noteId': IndexSchema(
      id: -int.parse('9014133502494436840'),
      name: r'noteId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'noteId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _noteCollectionGetId,
  getLinks: _noteCollectionGetLinks,
  attach: _noteCollectionAttach,
  version: '3.1.0+1',
);

int _noteCollectionEstimateSize(
  NoteCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.noteId.length * 3;
  return bytesCount;
}

void _noteCollectionSerialize(
  NoteCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ayahNumber);
  writer.writeString(offsets[1], object.content);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeBool(offsets[3], object.isSynced);
  writer.writeString(offsets[4], object.noteId);
  writer.writeLong(offsets[5], object.surahNumber);
  writer.writeDateTime(offsets[6], object.updatedAt);
}

NoteCollection _noteCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NoteCollection(
    ayahNumber: reader.readLong(offsets[0]),
    content: reader.readString(offsets[1]),
    createdAt: reader.readDateTime(offsets[2]),
    isSynced: reader.readBool(offsets[3]),
    noteId: reader.readString(offsets[4]),
    surahNumber: reader.readLong(offsets[5]),
    updatedAt: reader.readDateTime(offsets[6]),
  );
  object.id = id;
  return object;
}

P _noteCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _noteCollectionGetId(NoteCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _noteCollectionGetLinks(NoteCollection object) {
  return [];
}

void _noteCollectionAttach(
    IsarCollection<dynamic> col, Id id, NoteCollection object) {
  object.id = id;
}

extension NoteCollectionByIndex on IsarCollection<NoteCollection> {
  Future<NoteCollection?> getByNoteId(String noteId) {
    return getByIndex(r'noteId', [noteId]);
  }

  NoteCollection? getByNoteIdSync(String noteId) {
    return getByIndexSync(r'noteId', [noteId]);
  }

  Future<bool> deleteByNoteId(String noteId) {
    return deleteByIndex(r'noteId', [noteId]);
  }

  bool deleteByNoteIdSync(String noteId) {
    return deleteByIndexSync(r'noteId', [noteId]);
  }

  Future<List<NoteCollection?>> getAllByNoteId(List<String> noteIdValues) {
    final values = noteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'noteId', values);
  }

  List<NoteCollection?> getAllByNoteIdSync(List<String> noteIdValues) {
    final values = noteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'noteId', values);
  }

  Future<int> deleteAllByNoteId(List<String> noteIdValues) {
    final values = noteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'noteId', values);
  }

  int deleteAllByNoteIdSync(List<String> noteIdValues) {
    final values = noteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'noteId', values);
  }

  Future<Id> putByNoteId(NoteCollection object) {
    return putByIndex(r'noteId', object);
  }

  Id putByNoteIdSync(NoteCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'noteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNoteId(List<NoteCollection> objects) {
    return putAllByIndex(r'noteId', objects);
  }

  List<Id> putAllByNoteIdSync(List<NoteCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'noteId', objects, saveLinks: saveLinks);
  }
}

extension NoteCollectionQueryWhereSort
    on QueryBuilder<NoteCollection, NoteCollection, QWhere> {
  QueryBuilder<NoteCollection, NoteCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NoteCollectionQueryWhere
    on QueryBuilder<NoteCollection, NoteCollection, QWhereClause> {
  QueryBuilder<NoteCollection, NoteCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterWhereClause> noteIdEqualTo(
      String noteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'noteId',
        value: [noteId],
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterWhereClause>
      noteIdNotEqualTo(String noteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [],
              upper: [noteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [noteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [noteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'noteId',
              lower: [],
              upper: [noteId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension NoteCollectionQueryFilter
    on QueryBuilder<NoteCollection, NoteCollection, QFilterCondition> {
  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      ayahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      ayahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      ayahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      ayahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ayahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      noteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      noteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      noteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      noteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      noteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      noteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      noteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      noteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      noteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      noteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noteId',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      surahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      surahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      surahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      surahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NoteCollectionQueryObject
    on QueryBuilder<NoteCollection, NoteCollection, QFilterCondition> {}

extension NoteCollectionQueryLinks
    on QueryBuilder<NoteCollection, NoteCollection, QFilterCondition> {}

extension NoteCollectionQuerySortBy
    on QueryBuilder<NoteCollection, NoteCollection, QSortBy> {
  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      sortByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      sortByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> sortByNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      sortByNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension NoteCollectionQuerySortThenBy
    on QueryBuilder<NoteCollection, NoteCollection, QSortThenBy> {
  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      thenByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      thenByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> thenByNoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      thenByNoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteId', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension NoteCollectionQueryWhereDistinct
    on QueryBuilder<NoteCollection, NoteCollection, QDistinct> {
  QueryBuilder<NoteCollection, NoteCollection, QDistinct>
      distinctByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayahNumber');
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QDistinct> distinctByNoteId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QDistinct>
      distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }

  QueryBuilder<NoteCollection, NoteCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension NoteCollectionQueryProperty
    on QueryBuilder<NoteCollection, NoteCollection, QQueryProperty> {
  QueryBuilder<NoteCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NoteCollection, int, QQueryOperations> ayahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayahNumber');
    });
  }

  QueryBuilder<NoteCollection, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<NoteCollection, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<NoteCollection, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<NoteCollection, String, QQueryOperations> noteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteId');
    });
  }

  QueryBuilder<NoteCollection, int, QQueryOperations> surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }

  QueryBuilder<NoteCollection, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
