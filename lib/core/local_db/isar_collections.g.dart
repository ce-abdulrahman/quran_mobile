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

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAudioFavoriteCollectionCollection on Isar {
  IsarCollection<AudioFavoriteCollection> get audioFavoriteCollections =>
      this.collection();
}

final AudioFavoriteCollectionSchema = CollectionSchema(
  name: r'AudioFavoriteCollection',
  id: int.parse('8320977553766732322'),
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'favoritableId': PropertySchema(
      id: 1,
      name: r'favoritableId',
      type: IsarType.long,
    ),
    r'favoritableType': PropertySchema(
      id: 2,
      name: r'favoritableType',
      type: IsarType.string,
    ),
    r'favoriteKey': PropertySchema(
      id: 3,
      name: r'favoriteKey',
      type: IsarType.string,
    )
  },
  estimateSize: _audioFavoriteCollectionEstimateSize,
  serialize: _audioFavoriteCollectionSerialize,
  deserialize: _audioFavoriteCollectionDeserialize,
  deserializeProp: _audioFavoriteCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'favoriteKey': IndexSchema(
      id: int.parse('2684096142477831931'),
      name: r'favoriteKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'favoriteKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _audioFavoriteCollectionGetId,
  getLinks: _audioFavoriteCollectionGetLinks,
  attach: _audioFavoriteCollectionAttach,
  version: '3.1.0+1',
);

int _audioFavoriteCollectionEstimateSize(
  AudioFavoriteCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.favoritableType.length * 3;
  bytesCount += 3 + object.favoriteKey.length * 3;
  return bytesCount;
}

void _audioFavoriteCollectionSerialize(
  AudioFavoriteCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.favoritableId);
  writer.writeString(offsets[2], object.favoritableType);
  writer.writeString(offsets[3], object.favoriteKey);
}

AudioFavoriteCollection _audioFavoriteCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AudioFavoriteCollection(
    createdAt: reader.readDateTime(offsets[0]),
    favoritableId: reader.readLong(offsets[1]),
    favoritableType: reader.readString(offsets[2]),
    favoriteKey: reader.readString(offsets[3]),
  );
  object.id = id;
  return object;
}

P _audioFavoriteCollectionDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _audioFavoriteCollectionGetId(AudioFavoriteCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _audioFavoriteCollectionGetLinks(
    AudioFavoriteCollection object) {
  return [];
}

void _audioFavoriteCollectionAttach(
    IsarCollection<dynamic> col, Id id, AudioFavoriteCollection object) {
  object.id = id;
}

extension AudioFavoriteCollectionByIndex
    on IsarCollection<AudioFavoriteCollection> {
  Future<AudioFavoriteCollection?> getByFavoriteKey(String favoriteKey) {
    return getByIndex(r'favoriteKey', [favoriteKey]);
  }

  AudioFavoriteCollection? getByFavoriteKeySync(String favoriteKey) {
    return getByIndexSync(r'favoriteKey', [favoriteKey]);
  }

  Future<bool> deleteByFavoriteKey(String favoriteKey) {
    return deleteByIndex(r'favoriteKey', [favoriteKey]);
  }

  bool deleteByFavoriteKeySync(String favoriteKey) {
    return deleteByIndexSync(r'favoriteKey', [favoriteKey]);
  }

  Future<List<AudioFavoriteCollection?>> getAllByFavoriteKey(
      List<String> favoriteKeyValues) {
    final values = favoriteKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'favoriteKey', values);
  }

  List<AudioFavoriteCollection?> getAllByFavoriteKeySync(
      List<String> favoriteKeyValues) {
    final values = favoriteKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'favoriteKey', values);
  }

  Future<int> deleteAllByFavoriteKey(List<String> favoriteKeyValues) {
    final values = favoriteKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'favoriteKey', values);
  }

  int deleteAllByFavoriteKeySync(List<String> favoriteKeyValues) {
    final values = favoriteKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'favoriteKey', values);
  }

  Future<Id> putByFavoriteKey(AudioFavoriteCollection object) {
    return putByIndex(r'favoriteKey', object);
  }

  Id putByFavoriteKeySync(AudioFavoriteCollection object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'favoriteKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFavoriteKey(List<AudioFavoriteCollection> objects) {
    return putAllByIndex(r'favoriteKey', objects);
  }

  List<Id> putAllByFavoriteKeySync(List<AudioFavoriteCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'favoriteKey', objects, saveLinks: saveLinks);
  }
}

extension AudioFavoriteCollectionQueryWhereSort
    on QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QWhere> {
  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AudioFavoriteCollectionQueryWhere on QueryBuilder<
    AudioFavoriteCollection, AudioFavoriteCollection, QWhereClause> {
  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
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

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
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

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterWhereClause> favoriteKeyEqualTo(String favoriteKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'favoriteKey',
        value: [favoriteKey],
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterWhereClause> favoriteKeyNotEqualTo(String favoriteKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteKey',
              lower: [],
              upper: [favoriteKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteKey',
              lower: [favoriteKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteKey',
              lower: [favoriteKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteKey',
              lower: [],
              upper: [favoriteKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AudioFavoriteCollectionQueryFilter on QueryBuilder<
    AudioFavoriteCollection, AudioFavoriteCollection, QFilterCondition> {
  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
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

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
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

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
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

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoritableId',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favoritableId',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favoritableId',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favoritableId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favoritableType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
          QAfterFilterCondition>
      favoritableTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
          QAfterFilterCondition>
      favoritableTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'favoritableType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoritableType',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoritableTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'favoritableType',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoriteKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoriteKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoriteKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favoriteKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoriteKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favoriteKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoriteKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favoriteKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoriteKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'favoriteKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoriteKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'favoriteKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
          QAfterFilterCondition>
      favoriteKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'favoriteKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
          QAfterFilterCondition>
      favoriteKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'favoriteKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoriteKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoriteKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> favoriteKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'favoriteKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
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

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
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

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection,
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
}

extension AudioFavoriteCollectionQueryObject on QueryBuilder<
    AudioFavoriteCollection, AudioFavoriteCollection, QFilterCondition> {}

extension AudioFavoriteCollectionQueryLinks on QueryBuilder<
    AudioFavoriteCollection, AudioFavoriteCollection, QFilterCondition> {}

extension AudioFavoriteCollectionQuerySortBy
    on QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QSortBy> {
  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      sortByFavoritableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableId', Sort.asc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      sortByFavoritableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableId', Sort.desc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      sortByFavoritableType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableType', Sort.asc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      sortByFavoritableTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableType', Sort.desc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      sortByFavoriteKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteKey', Sort.asc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      sortByFavoriteKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteKey', Sort.desc);
    });
  }
}

extension AudioFavoriteCollectionQuerySortThenBy on QueryBuilder<
    AudioFavoriteCollection, AudioFavoriteCollection, QSortThenBy> {
  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      thenByFavoritableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableId', Sort.asc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      thenByFavoritableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableId', Sort.desc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      thenByFavoritableType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableType', Sort.asc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      thenByFavoritableTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableType', Sort.desc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      thenByFavoriteKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteKey', Sort.asc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      thenByFavoriteKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteKey', Sort.desc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension AudioFavoriteCollectionQueryWhereDistinct on QueryBuilder<
    AudioFavoriteCollection, AudioFavoriteCollection, QDistinct> {
  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QDistinct>
      distinctByFavoritableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoritableId');
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QDistinct>
      distinctByFavoritableType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoritableType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AudioFavoriteCollection, AudioFavoriteCollection, QDistinct>
      distinctByFavoriteKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoriteKey', caseSensitive: caseSensitive);
    });
  }
}

extension AudioFavoriteCollectionQueryProperty on QueryBuilder<
    AudioFavoriteCollection, AudioFavoriteCollection, QQueryProperty> {
  QueryBuilder<AudioFavoriteCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AudioFavoriteCollection, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AudioFavoriteCollection, int, QQueryOperations>
      favoritableIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoritableId');
    });
  }

  QueryBuilder<AudioFavoriteCollection, String, QQueryOperations>
      favoritableTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoritableType');
    });
  }

  QueryBuilder<AudioFavoriteCollection, String, QQueryOperations>
      favoriteKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoriteKey');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadCollectionCollection on Isar {
  IsarCollection<DownloadCollection> get downloadCollections =>
      this.collection();
}

final DownloadCollectionSchema = CollectionSchema(
  name: r'DownloadCollection',
  id: int.parse('8807255898380263598'),
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'downloadKey': PropertySchema(
      id: 1,
      name: r'downloadKey',
      type: IsarType.string,
    ),
    r'filePath': PropertySchema(
      id: 2,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'lastAccessedAt': PropertySchema(
      id: 3,
      name: r'lastAccessedAt',
      type: IsarType.dateTime,
    ),
    r'progress': PropertySchema(
      id: 4,
      name: r'progress',
      type: IsarType.double,
    ),
    r'reciterId': PropertySchema(
      id: 5,
      name: r'reciterId',
      type: IsarType.long,
    ),
    r'sizeMb': PropertySchema(
      id: 6,
      name: r'sizeMb',
      type: IsarType.double,
    ),
    r'status': PropertySchema(
      id: 7,
      name: r'status',
      type: IsarType.string,
    ),
    r'surahId': PropertySchema(
      id: 8,
      name: r'surahId',
      type: IsarType.long,
    )
  },
  estimateSize: _downloadCollectionEstimateSize,
  serialize: _downloadCollectionSerialize,
  deserialize: _downloadCollectionDeserialize,
  deserializeProp: _downloadCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'downloadKey': IndexSchema(
      id: -int.parse('3924819050589750973'),
      name: r'downloadKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'downloadKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _downloadCollectionGetId,
  getLinks: _downloadCollectionGetLinks,
  attach: _downloadCollectionAttach,
  version: '3.1.0+1',
);

int _downloadCollectionEstimateSize(
  DownloadCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.downloadKey.length * 3;
  bytesCount += 3 + object.filePath.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _downloadCollectionSerialize(
  DownloadCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.downloadKey);
  writer.writeString(offsets[2], object.filePath);
  writer.writeDateTime(offsets[3], object.lastAccessedAt);
  writer.writeDouble(offsets[4], object.progress);
  writer.writeLong(offsets[5], object.reciterId);
  writer.writeDouble(offsets[6], object.sizeMb);
  writer.writeString(offsets[7], object.status);
  writer.writeLong(offsets[8], object.surahId);
}

DownloadCollection _downloadCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadCollection(
    createdAt: reader.readDateTime(offsets[0]),
    downloadKey: reader.readString(offsets[1]),
    filePath: reader.readString(offsets[2]),
    lastAccessedAt: reader.readDateTime(offsets[3]),
    progress: reader.readDouble(offsets[4]),
    reciterId: reader.readLong(offsets[5]),
    sizeMb: reader.readDouble(offsets[6]),
    status: reader.readString(offsets[7]),
    surahId: reader.readLong(offsets[8]),
  );
  object.id = id;
  return object;
}

P _downloadCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _downloadCollectionGetId(DownloadCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _downloadCollectionGetLinks(
    DownloadCollection object) {
  return [];
}

void _downloadCollectionAttach(
    IsarCollection<dynamic> col, Id id, DownloadCollection object) {
  object.id = id;
}

extension DownloadCollectionByIndex on IsarCollection<DownloadCollection> {
  Future<DownloadCollection?> getByDownloadKey(String downloadKey) {
    return getByIndex(r'downloadKey', [downloadKey]);
  }

  DownloadCollection? getByDownloadKeySync(String downloadKey) {
    return getByIndexSync(r'downloadKey', [downloadKey]);
  }

  Future<bool> deleteByDownloadKey(String downloadKey) {
    return deleteByIndex(r'downloadKey', [downloadKey]);
  }

  bool deleteByDownloadKeySync(String downloadKey) {
    return deleteByIndexSync(r'downloadKey', [downloadKey]);
  }

  Future<List<DownloadCollection?>> getAllByDownloadKey(
      List<String> downloadKeyValues) {
    final values = downloadKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'downloadKey', values);
  }

  List<DownloadCollection?> getAllByDownloadKeySync(
      List<String> downloadKeyValues) {
    final values = downloadKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'downloadKey', values);
  }

  Future<int> deleteAllByDownloadKey(List<String> downloadKeyValues) {
    final values = downloadKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'downloadKey', values);
  }

  int deleteAllByDownloadKeySync(List<String> downloadKeyValues) {
    final values = downloadKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'downloadKey', values);
  }

  Future<Id> putByDownloadKey(DownloadCollection object) {
    return putByIndex(r'downloadKey', object);
  }

  Id putByDownloadKeySync(DownloadCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'downloadKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDownloadKey(List<DownloadCollection> objects) {
    return putAllByIndex(r'downloadKey', objects);
  }

  List<Id> putAllByDownloadKeySync(List<DownloadCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'downloadKey', objects, saveLinks: saveLinks);
  }
}

extension DownloadCollectionQueryWhereSort
    on QueryBuilder<DownloadCollection, DownloadCollection, QWhere> {
  QueryBuilder<DownloadCollection, DownloadCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DownloadCollectionQueryWhere
    on QueryBuilder<DownloadCollection, DownloadCollection, QWhereClause> {
  QueryBuilder<DownloadCollection, DownloadCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterWhereClause>
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterWhereClause>
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterWhereClause>
      downloadKeyEqualTo(String downloadKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'downloadKey',
        value: [downloadKey],
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterWhereClause>
      downloadKeyNotEqualTo(String downloadKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadKey',
              lower: [],
              upper: [downloadKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadKey',
              lower: [downloadKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadKey',
              lower: [downloadKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'downloadKey',
              lower: [],
              upper: [downloadKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DownloadCollectionQueryFilter
    on QueryBuilder<DownloadCollection, DownloadCollection, QFilterCondition> {
  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      downloadKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      downloadKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      downloadKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      downloadKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      downloadKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'downloadKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      downloadKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'downloadKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      downloadKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'downloadKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      downloadKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'downloadKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      downloadKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadKey',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      downloadKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'downloadKey',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      filePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      filePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      filePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      filePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      filePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      filePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      filePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      lastAccessedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAccessedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      lastAccessedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAccessedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      lastAccessedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAccessedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      lastAccessedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAccessedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      progressEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      progressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      progressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      progressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      reciterIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciterId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      reciterIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reciterId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      reciterIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reciterId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      reciterIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reciterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      sizeMbEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sizeMb',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      sizeMbGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sizeMb',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      sizeMbLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sizeMb',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      sizeMbBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sizeMb',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      statusEqualTo(
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      statusGreaterThan(
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      statusLessThan(
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      statusBetween(
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      statusStartsWith(
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      statusEndsWith(
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      surahIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahId',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      surahIdGreaterThan(
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      surahIdLessThan(
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

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterFilterCondition>
      surahIdBetween(
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
}

extension DownloadCollectionQueryObject
    on QueryBuilder<DownloadCollection, DownloadCollection, QFilterCondition> {}

extension DownloadCollectionQueryLinks
    on QueryBuilder<DownloadCollection, DownloadCollection, QFilterCondition> {}

extension DownloadCollectionQuerySortBy
    on QueryBuilder<DownloadCollection, DownloadCollection, QSortBy> {
  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByDownloadKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadKey', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByDownloadKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadKey', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByLastAccessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccessedAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByLastAccessedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccessedAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByReciterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortBySizeMb() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeMb', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortBySizeMbDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeMb', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortBySurahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      sortBySurahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.desc);
    });
  }
}

extension DownloadCollectionQuerySortThenBy
    on QueryBuilder<DownloadCollection, DownloadCollection, QSortThenBy> {
  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByDownloadKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadKey', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByDownloadKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadKey', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByLastAccessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccessedAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByLastAccessedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAccessedAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByReciterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenBySizeMb() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeMb', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenBySizeMbDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeMb', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenBySurahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.asc);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QAfterSortBy>
      thenBySurahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.desc);
    });
  }
}

extension DownloadCollectionQueryWhereDistinct
    on QueryBuilder<DownloadCollection, DownloadCollection, QDistinct> {
  QueryBuilder<DownloadCollection, DownloadCollection, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QDistinct>
      distinctByDownloadKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QDistinct>
      distinctByFilePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QDistinct>
      distinctByLastAccessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAccessedAt');
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QDistinct>
      distinctByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progress');
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QDistinct>
      distinctByReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reciterId');
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QDistinct>
      distinctBySizeMb() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sizeMb');
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadCollection, DownloadCollection, QDistinct>
      distinctBySurahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahId');
    });
  }
}

extension DownloadCollectionQueryProperty
    on QueryBuilder<DownloadCollection, DownloadCollection, QQueryProperty> {
  QueryBuilder<DownloadCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DownloadCollection, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DownloadCollection, String, QQueryOperations>
      downloadKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadKey');
    });
  }

  QueryBuilder<DownloadCollection, String, QQueryOperations>
      filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filePath');
    });
  }

  QueryBuilder<DownloadCollection, DateTime, QQueryOperations>
      lastAccessedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAccessedAt');
    });
  }

  QueryBuilder<DownloadCollection, double, QQueryOperations>
      progressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progress');
    });
  }

  QueryBuilder<DownloadCollection, int, QQueryOperations> reciterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reciterId');
    });
  }

  QueryBuilder<DownloadCollection, double, QQueryOperations> sizeMbProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sizeMb');
    });
  }

  QueryBuilder<DownloadCollection, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<DownloadCollection, int, QQueryOperations> surahIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNamesOfAllahCollectionCollection on Isar {
  IsarCollection<NamesOfAllahCollection> get namesOfAllahCollections =>
      this.collection();
}

final NamesOfAllahCollectionSchema = CollectionSchema(
  name: r'NamesOfAllahCollection',
  id: int.parse('2016929537859491863'),
  properties: {
    r'meaningEn': PropertySchema(
      id: 0,
      name: r'meaningEn',
      type: IsarType.string,
    ),
    r'meaningKu': PropertySchema(
      id: 1,
      name: r'meaningKu',
      type: IsarType.string,
    ),
    r'nameAr': PropertySchema(
      id: 2,
      name: r'nameAr',
      type: IsarType.string,
    ),
    r'nameId': PropertySchema(
      id: 3,
      name: r'nameId',
      type: IsarType.long,
    ),
    r'nameKu': PropertySchema(
      id: 4,
      name: r'nameKu',
      type: IsarType.string,
    ),
    r'slug': PropertySchema(
      id: 5,
      name: r'slug',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'verseAr': PropertySchema(
      id: 7,
      name: r'verseAr',
      type: IsarType.string,
    ),
    r'verseKu': PropertySchema(
      id: 8,
      name: r'verseKu',
      type: IsarType.string,
    ),
    r'version': PropertySchema(
      id: 9,
      name: r'version',
      type: IsarType.long,
    ),
    r'virtueKu': PropertySchema(
      id: 10,
      name: r'virtueKu',
      type: IsarType.string,
    )
  },
  estimateSize: _namesOfAllahCollectionEstimateSize,
  serialize: _namesOfAllahCollectionSerialize,
  deserialize: _namesOfAllahCollectionDeserialize,
  deserializeProp: _namesOfAllahCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'nameId': IndexSchema(
      id: -int.parse('6985159207553840634'),
      name: r'nameId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nameId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'slug': IndexSchema(
      id: int.parse('6169444064746062836'),
      name: r'slug',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'slug',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _namesOfAllahCollectionGetId,
  getLinks: _namesOfAllahCollectionGetLinks,
  attach: _namesOfAllahCollectionAttach,
  version: '3.1.0+1',
);

int _namesOfAllahCollectionEstimateSize(
  NamesOfAllahCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.meaningEn.length * 3;
  bytesCount += 3 + object.meaningKu.length * 3;
  bytesCount += 3 + object.nameAr.length * 3;
  bytesCount += 3 + object.nameKu.length * 3;
  bytesCount += 3 + object.slug.length * 3;
  bytesCount += 3 + object.verseAr.length * 3;
  bytesCount += 3 + object.verseKu.length * 3;
  bytesCount += 3 + object.virtueKu.length * 3;
  return bytesCount;
}

void _namesOfAllahCollectionSerialize(
  NamesOfAllahCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.meaningEn);
  writer.writeString(offsets[1], object.meaningKu);
  writer.writeString(offsets[2], object.nameAr);
  writer.writeLong(offsets[3], object.nameId);
  writer.writeString(offsets[4], object.nameKu);
  writer.writeString(offsets[5], object.slug);
  writer.writeDateTime(offsets[6], object.updatedAt);
  writer.writeString(offsets[7], object.verseAr);
  writer.writeString(offsets[8], object.verseKu);
  writer.writeLong(offsets[9], object.version);
  writer.writeString(offsets[10], object.virtueKu);
}

NamesOfAllahCollection _namesOfAllahCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NamesOfAllahCollection(
    meaningEn: reader.readString(offsets[0]),
    meaningKu: reader.readString(offsets[1]),
    nameAr: reader.readString(offsets[2]),
    nameId: reader.readLong(offsets[3]),
    nameKu: reader.readString(offsets[4]),
    slug: reader.readString(offsets[5]),
    updatedAt: reader.readDateTime(offsets[6]),
    verseAr: reader.readString(offsets[7]),
    verseKu: reader.readString(offsets[8]),
    version: reader.readLong(offsets[9]),
    virtueKu: reader.readString(offsets[10]),
  );
  object.id = id;
  return object;
}

P _namesOfAllahCollectionDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _namesOfAllahCollectionGetId(NamesOfAllahCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _namesOfAllahCollectionGetLinks(
    NamesOfAllahCollection object) {
  return [];
}

void _namesOfAllahCollectionAttach(
    IsarCollection<dynamic> col, Id id, NamesOfAllahCollection object) {
  object.id = id;
}

extension NamesOfAllahCollectionByIndex
    on IsarCollection<NamesOfAllahCollection> {
  Future<NamesOfAllahCollection?> getByNameId(int nameId) {
    return getByIndex(r'nameId', [nameId]);
  }

  NamesOfAllahCollection? getByNameIdSync(int nameId) {
    return getByIndexSync(r'nameId', [nameId]);
  }

  Future<bool> deleteByNameId(int nameId) {
    return deleteByIndex(r'nameId', [nameId]);
  }

  bool deleteByNameIdSync(int nameId) {
    return deleteByIndexSync(r'nameId', [nameId]);
  }

  Future<List<NamesOfAllahCollection?>> getAllByNameId(List<int> nameIdValues) {
    final values = nameIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'nameId', values);
  }

  List<NamesOfAllahCollection?> getAllByNameIdSync(List<int> nameIdValues) {
    final values = nameIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'nameId', values);
  }

  Future<int> deleteAllByNameId(List<int> nameIdValues) {
    final values = nameIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'nameId', values);
  }

  int deleteAllByNameIdSync(List<int> nameIdValues) {
    final values = nameIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'nameId', values);
  }

  Future<Id> putByNameId(NamesOfAllahCollection object) {
    return putByIndex(r'nameId', object);
  }

  Id putByNameIdSync(NamesOfAllahCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'nameId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNameId(List<NamesOfAllahCollection> objects) {
    return putAllByIndex(r'nameId', objects);
  }

  List<Id> putAllByNameIdSync(List<NamesOfAllahCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'nameId', objects, saveLinks: saveLinks);
  }
}

extension NamesOfAllahCollectionQueryWhereSort
    on QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QWhere> {
  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterWhere>
      anyNameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'nameId'),
      );
    });
  }
}

extension NamesOfAllahCollectionQueryWhere on QueryBuilder<
    NamesOfAllahCollection, NamesOfAllahCollection, QWhereClause> {
  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterWhereClause> nameIdEqualTo(int nameId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'nameId',
        value: [nameId],
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterWhereClause> nameIdNotEqualTo(int nameId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nameId',
              lower: [],
              upper: [nameId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nameId',
              lower: [nameId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nameId',
              lower: [nameId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'nameId',
              lower: [],
              upper: [nameId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterWhereClause> nameIdGreaterThan(
    int nameId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nameId',
        lower: [nameId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterWhereClause> nameIdLessThan(
    int nameId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nameId',
        lower: [],
        upper: [nameId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterWhereClause> nameIdBetween(
    int lowerNameId,
    int upperNameId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'nameId',
        lower: [lowerNameId],
        includeLower: includeLower,
        upper: [upperNameId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterWhereClause> slugEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'slug',
        value: [slug],
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterWhereClause> slugNotEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ));
      }
    });
  }
}

extension NamesOfAllahCollectionQueryFilter on QueryBuilder<
    NamesOfAllahCollection, NamesOfAllahCollection, QFilterCondition> {
  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningEnEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meaningEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningEnGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'meaningEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningEnLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'meaningEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningEnBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'meaningEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningEnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'meaningEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningEnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'meaningEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      meaningEnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'meaningEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      meaningEnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'meaningEn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningEnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meaningEn',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningEnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'meaningEn',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meaningKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'meaningKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'meaningKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'meaningKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'meaningKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'meaningKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      meaningKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'meaningKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      meaningKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'meaningKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meaningKu',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> meaningKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'meaningKu',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> nameArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> nameArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> nameIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameId',
        value: value,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> nameIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameId',
        value: value,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> nameIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameId',
        value: value,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> nameIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> nameKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> nameKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> slugEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> slugGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> slugLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> slugBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slug',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> slugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> slugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      slugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      slugMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slug',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> slugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> slugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
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

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseArEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseArGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseArLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseArBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseAr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseArStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'verseAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseArEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'verseAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      verseArContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'verseAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      verseArMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'verseAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseAr',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'verseAr',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'verseKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'verseKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      verseKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'verseKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      verseKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'verseKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseKu',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> verseKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'verseKu',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> virtueKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'virtueKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> virtueKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'virtueKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> virtueKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'virtueKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> virtueKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'virtueKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> virtueKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'virtueKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> virtueKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'virtueKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      virtueKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'virtueKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
          QAfterFilterCondition>
      virtueKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'virtueKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> virtueKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'virtueKu',
        value: '',
      ));
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection,
      QAfterFilterCondition> virtueKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'virtueKu',
        value: '',
      ));
    });
  }
}

extension NamesOfAllahCollectionQueryObject on QueryBuilder<
    NamesOfAllahCollection, NamesOfAllahCollection, QFilterCondition> {}

extension NamesOfAllahCollectionQueryLinks on QueryBuilder<
    NamesOfAllahCollection, NamesOfAllahCollection, QFilterCondition> {}

extension NamesOfAllahCollectionQuerySortBy
    on QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QSortBy> {
  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByMeaningEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meaningEn', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByMeaningEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meaningEn', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByMeaningKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meaningKu', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByMeaningKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meaningKu', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByNameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameId', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByNameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameId', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByVerseAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseAr', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByVerseArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseAr', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByVerseKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseKu', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByVerseKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseKu', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByVirtueKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtueKu', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      sortByVirtueKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtueKu', Sort.desc);
    });
  }
}

extension NamesOfAllahCollectionQuerySortThenBy on QueryBuilder<
    NamesOfAllahCollection, NamesOfAllahCollection, QSortThenBy> {
  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByMeaningEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meaningEn', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByMeaningEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meaningEn', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByMeaningKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meaningKu', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByMeaningKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'meaningKu', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByNameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameId', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByNameIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameId', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByVerseAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseAr', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByVerseArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseAr', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByVerseKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseKu', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByVerseKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseKu', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByVirtueKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtueKu', Sort.asc);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QAfterSortBy>
      thenByVirtueKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtueKu', Sort.desc);
    });
  }
}

extension NamesOfAllahCollectionQueryWhereDistinct
    on QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct> {
  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctByMeaningEn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'meaningEn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctByMeaningKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'meaningKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctByNameAr({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctByNameId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameId');
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctByNameKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctBySlug({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slug', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctByVerseAr({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctByVerseKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }

  QueryBuilder<NamesOfAllahCollection, NamesOfAllahCollection, QDistinct>
      distinctByVirtueKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'virtueKu', caseSensitive: caseSensitive);
    });
  }
}

extension NamesOfAllahCollectionQueryProperty on QueryBuilder<
    NamesOfAllahCollection, NamesOfAllahCollection, QQueryProperty> {
  QueryBuilder<NamesOfAllahCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NamesOfAllahCollection, String, QQueryOperations>
      meaningEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'meaningEn');
    });
  }

  QueryBuilder<NamesOfAllahCollection, String, QQueryOperations>
      meaningKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'meaningKu');
    });
  }

  QueryBuilder<NamesOfAllahCollection, String, QQueryOperations>
      nameArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameAr');
    });
  }

  QueryBuilder<NamesOfAllahCollection, int, QQueryOperations> nameIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameId');
    });
  }

  QueryBuilder<NamesOfAllahCollection, String, QQueryOperations>
      nameKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameKu');
    });
  }

  QueryBuilder<NamesOfAllahCollection, String, QQueryOperations>
      slugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slug');
    });
  }

  QueryBuilder<NamesOfAllahCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<NamesOfAllahCollection, String, QQueryOperations>
      verseArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseAr');
    });
  }

  QueryBuilder<NamesOfAllahCollection, String, QQueryOperations>
      verseKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseKu');
    });
  }

  QueryBuilder<NamesOfAllahCollection, int, QQueryOperations>
      versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }

  QueryBuilder<NamesOfAllahCollection, String, QQueryOperations>
      virtueKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'virtueKu');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSeerahCollectionCollection on Isar {
  IsarCollection<SeerahCollection> get seerahCollections => this.collection();
}

final SeerahCollectionSchema = CollectionSchema(
  name: r'SeerahCollection',
  id: -int.parse('5218421529354325023'),
  properties: {
    r'contentMd': PropertySchema(
      id: 0,
      name: r'contentMd',
      type: IsarType.string,
    ),
    r'period': PropertySchema(
      id: 1,
      name: r'period',
      type: IsarType.string,
    ),
    r'seerahId': PropertySchema(
      id: 2,
      name: r'seerahId',
      type: IsarType.long,
    ),
    r'slug': PropertySchema(
      id: 3,
      name: r'slug',
      type: IsarType.string,
    ),
    r'titleAr': PropertySchema(
      id: 4,
      name: r'titleAr',
      type: IsarType.string,
    ),
    r'titleKu': PropertySchema(
      id: 5,
      name: r'titleKu',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'version': PropertySchema(
      id: 7,
      name: r'version',
      type: IsarType.long,
    )
  },
  estimateSize: _seerahCollectionEstimateSize,
  serialize: _seerahCollectionSerialize,
  deserialize: _seerahCollectionDeserialize,
  deserializeProp: _seerahCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'seerahId': IndexSchema(
      id: -int.parse('1086402056972916924'),
      name: r'seerahId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'seerahId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'slug': IndexSchema(
      id: int.parse('6169444064746062836'),
      name: r'slug',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'slug',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _seerahCollectionGetId,
  getLinks: _seerahCollectionGetLinks,
  attach: _seerahCollectionAttach,
  version: '3.1.0+1',
);

int _seerahCollectionEstimateSize(
  SeerahCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.contentMd.length * 3;
  bytesCount += 3 + object.period.length * 3;
  bytesCount += 3 + object.slug.length * 3;
  bytesCount += 3 + object.titleAr.length * 3;
  bytesCount += 3 + object.titleKu.length * 3;
  return bytesCount;
}

void _seerahCollectionSerialize(
  SeerahCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.contentMd);
  writer.writeString(offsets[1], object.period);
  writer.writeLong(offsets[2], object.seerahId);
  writer.writeString(offsets[3], object.slug);
  writer.writeString(offsets[4], object.titleAr);
  writer.writeString(offsets[5], object.titleKu);
  writer.writeDateTime(offsets[6], object.updatedAt);
  writer.writeLong(offsets[7], object.version);
}

SeerahCollection _seerahCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SeerahCollection(
    contentMd: reader.readString(offsets[0]),
    period: reader.readString(offsets[1]),
    seerahId: reader.readLong(offsets[2]),
    slug: reader.readString(offsets[3]),
    titleAr: reader.readString(offsets[4]),
    titleKu: reader.readString(offsets[5]),
    updatedAt: reader.readDateTime(offsets[6]),
    version: reader.readLong(offsets[7]),
  );
  object.id = id;
  return object;
}

P _seerahCollectionDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _seerahCollectionGetId(SeerahCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _seerahCollectionGetLinks(SeerahCollection object) {
  return [];
}

void _seerahCollectionAttach(
    IsarCollection<dynamic> col, Id id, SeerahCollection object) {
  object.id = id;
}

extension SeerahCollectionByIndex on IsarCollection<SeerahCollection> {
  Future<SeerahCollection?> getBySeerahId(int seerahId) {
    return getByIndex(r'seerahId', [seerahId]);
  }

  SeerahCollection? getBySeerahIdSync(int seerahId) {
    return getByIndexSync(r'seerahId', [seerahId]);
  }

  Future<bool> deleteBySeerahId(int seerahId) {
    return deleteByIndex(r'seerahId', [seerahId]);
  }

  bool deleteBySeerahIdSync(int seerahId) {
    return deleteByIndexSync(r'seerahId', [seerahId]);
  }

  Future<List<SeerahCollection?>> getAllBySeerahId(List<int> seerahIdValues) {
    final values = seerahIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'seerahId', values);
  }

  List<SeerahCollection?> getAllBySeerahIdSync(List<int> seerahIdValues) {
    final values = seerahIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'seerahId', values);
  }

  Future<int> deleteAllBySeerahId(List<int> seerahIdValues) {
    final values = seerahIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'seerahId', values);
  }

  int deleteAllBySeerahIdSync(List<int> seerahIdValues) {
    final values = seerahIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'seerahId', values);
  }

  Future<Id> putBySeerahId(SeerahCollection object) {
    return putByIndex(r'seerahId', object);
  }

  Id putBySeerahIdSync(SeerahCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'seerahId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySeerahId(List<SeerahCollection> objects) {
    return putAllByIndex(r'seerahId', objects);
  }

  List<Id> putAllBySeerahIdSync(List<SeerahCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'seerahId', objects, saveLinks: saveLinks);
  }
}

extension SeerahCollectionQueryWhereSort
    on QueryBuilder<SeerahCollection, SeerahCollection, QWhere> {
  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhere> anySeerahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'seerahId'),
      );
    });
  }
}

extension SeerahCollectionQueryWhere
    on QueryBuilder<SeerahCollection, SeerahCollection, QWhereClause> {
  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause>
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

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause> idBetween(
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

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause>
      seerahIdEqualTo(int seerahId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'seerahId',
        value: [seerahId],
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause>
      seerahIdNotEqualTo(int seerahId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'seerahId',
              lower: [],
              upper: [seerahId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'seerahId',
              lower: [seerahId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'seerahId',
              lower: [seerahId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'seerahId',
              lower: [],
              upper: [seerahId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause>
      seerahIdGreaterThan(
    int seerahId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'seerahId',
        lower: [seerahId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause>
      seerahIdLessThan(
    int seerahId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'seerahId',
        lower: [],
        upper: [seerahId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause>
      seerahIdBetween(
    int lowerSeerahId,
    int upperSeerahId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'seerahId',
        lower: [lowerSeerahId],
        includeLower: includeLower,
        upper: [upperSeerahId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause>
      slugEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'slug',
        value: [slug],
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterWhereClause>
      slugNotEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SeerahCollectionQueryFilter
    on QueryBuilder<SeerahCollection, SeerahCollection, QFilterCondition> {
  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      contentMdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      contentMdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      contentMdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      contentMdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentMd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      contentMdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contentMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      contentMdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contentMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      contentMdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      contentMdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentMd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      contentMdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentMd',
        value: '',
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      contentMdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentMd',
        value: '',
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
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

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
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

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
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

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      periodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      periodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      periodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      periodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'period',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      periodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      periodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      periodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      periodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'period',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      periodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'period',
        value: '',
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      periodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'period',
        value: '',
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      seerahIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seerahId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      seerahIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seerahId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      seerahIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seerahId',
        value: value,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      seerahIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seerahId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      slugEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      slugGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      slugLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      slugBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slug',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      slugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      slugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      slugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      slugMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slug',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      slugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      slugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleArEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleArGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleArLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleArBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titleAr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleArStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleArEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleArContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titleAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleArMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titleAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleAr',
        value: '',
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titleAr',
        value: '',
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titleKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titleKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titleKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titleKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titleKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titleKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titleKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      titleKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titleKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
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

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
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

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
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

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterFilterCondition>
      versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SeerahCollectionQueryObject
    on QueryBuilder<SeerahCollection, SeerahCollection, QFilterCondition> {}

extension SeerahCollectionQueryLinks
    on QueryBuilder<SeerahCollection, SeerahCollection, QFilterCondition> {}

extension SeerahCollectionQuerySortBy
    on QueryBuilder<SeerahCollection, SeerahCollection, QSortBy> {
  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByContentMd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentMd', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByContentMdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentMd', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortBySeerahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seerahId', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortBySeerahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seerahId', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy> sortBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByTitleAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByTitleArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByTitleKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleKu', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByTitleKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleKu', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension SeerahCollectionQuerySortThenBy
    on QueryBuilder<SeerahCollection, SeerahCollection, QSortThenBy> {
  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByContentMd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentMd', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByContentMdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentMd', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenBySeerahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seerahId', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenBySeerahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seerahId', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy> thenBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByTitleAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByTitleArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleAr', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByTitleKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleKu', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByTitleKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleKu', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension SeerahCollectionQueryWhereDistinct
    on QueryBuilder<SeerahCollection, SeerahCollection, QDistinct> {
  QueryBuilder<SeerahCollection, SeerahCollection, QDistinct>
      distinctByContentMd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentMd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QDistinct> distinctByPeriod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'period', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QDistinct>
      distinctBySeerahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seerahId');
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QDistinct> distinctBySlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slug', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QDistinct> distinctByTitleAr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titleAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QDistinct> distinctByTitleKu(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titleKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<SeerahCollection, SeerahCollection, QDistinct>
      distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension SeerahCollectionQueryProperty
    on QueryBuilder<SeerahCollection, SeerahCollection, QQueryProperty> {
  QueryBuilder<SeerahCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SeerahCollection, String, QQueryOperations> contentMdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentMd');
    });
  }

  QueryBuilder<SeerahCollection, String, QQueryOperations> periodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'period');
    });
  }

  QueryBuilder<SeerahCollection, int, QQueryOperations> seerahIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seerahId');
    });
  }

  QueryBuilder<SeerahCollection, String, QQueryOperations> slugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slug');
    });
  }

  QueryBuilder<SeerahCollection, String, QQueryOperations> titleArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titleAr');
    });
  }

  QueryBuilder<SeerahCollection, String, QQueryOperations> titleKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titleKu');
    });
  }

  QueryBuilder<SeerahCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<SeerahCollection, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSahabaCollectionCollection on Isar {
  IsarCollection<SahabaCollection> get sahabaCollections => this.collection();
}

final SahabaCollectionSchema = CollectionSchema(
  name: r'SahabaCollection',
  id: int.parse('2260652625311812399'),
  properties: {
    r'biographyMd': PropertySchema(
      id: 0,
      name: r'biographyMd',
      type: IsarType.string,
    ),
    r'epithetKu': PropertySchema(
      id: 1,
      name: r'epithetKu',
      type: IsarType.string,
    ),
    r'nameAr': PropertySchema(
      id: 2,
      name: r'nameAr',
      type: IsarType.string,
    ),
    r'nameKu': PropertySchema(
      id: 3,
      name: r'nameKu',
      type: IsarType.string,
    ),
    r'sahabaId': PropertySchema(
      id: 4,
      name: r'sahabaId',
      type: IsarType.long,
    ),
    r'slug': PropertySchema(
      id: 5,
      name: r'slug',
      type: IsarType.string,
    ),
    r'summaryKu': PropertySchema(
      id: 6,
      name: r'summaryKu',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'version': PropertySchema(
      id: 8,
      name: r'version',
      type: IsarType.long,
    ),
    r'virtuesKu': PropertySchema(
      id: 9,
      name: r'virtuesKu',
      type: IsarType.string,
    )
  },
  estimateSize: _sahabaCollectionEstimateSize,
  serialize: _sahabaCollectionSerialize,
  deserialize: _sahabaCollectionDeserialize,
  deserializeProp: _sahabaCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'sahabaId': IndexSchema(
      id: -int.parse('2393680415312519979'),
      name: r'sahabaId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sahabaId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'slug': IndexSchema(
      id: int.parse('6169444064746062836'),
      name: r'slug',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'slug',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _sahabaCollectionGetId,
  getLinks: _sahabaCollectionGetLinks,
  attach: _sahabaCollectionAttach,
  version: '3.1.0+1',
);

int _sahabaCollectionEstimateSize(
  SahabaCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.biographyMd.length * 3;
  bytesCount += 3 + object.epithetKu.length * 3;
  bytesCount += 3 + object.nameAr.length * 3;
  bytesCount += 3 + object.nameKu.length * 3;
  bytesCount += 3 + object.slug.length * 3;
  bytesCount += 3 + object.summaryKu.length * 3;
  bytesCount += 3 + object.virtuesKu.length * 3;
  return bytesCount;
}

void _sahabaCollectionSerialize(
  SahabaCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.biographyMd);
  writer.writeString(offsets[1], object.epithetKu);
  writer.writeString(offsets[2], object.nameAr);
  writer.writeString(offsets[3], object.nameKu);
  writer.writeLong(offsets[4], object.sahabaId);
  writer.writeString(offsets[5], object.slug);
  writer.writeString(offsets[6], object.summaryKu);
  writer.writeDateTime(offsets[7], object.updatedAt);
  writer.writeLong(offsets[8], object.version);
  writer.writeString(offsets[9], object.virtuesKu);
}

SahabaCollection _sahabaCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SahabaCollection(
    biographyMd: reader.readString(offsets[0]),
    epithetKu: reader.readString(offsets[1]),
    nameAr: reader.readString(offsets[2]),
    nameKu: reader.readString(offsets[3]),
    sahabaId: reader.readLong(offsets[4]),
    slug: reader.readString(offsets[5]),
    summaryKu: reader.readString(offsets[6]),
    updatedAt: reader.readDateTime(offsets[7]),
    version: reader.readLong(offsets[8]),
    virtuesKu: reader.readString(offsets[9]),
  );
  object.id = id;
  return object;
}

P _sahabaCollectionDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sahabaCollectionGetId(SahabaCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sahabaCollectionGetLinks(SahabaCollection object) {
  return [];
}

void _sahabaCollectionAttach(
    IsarCollection<dynamic> col, Id id, SahabaCollection object) {
  object.id = id;
}

extension SahabaCollectionByIndex on IsarCollection<SahabaCollection> {
  Future<SahabaCollection?> getBySahabaId(int sahabaId) {
    return getByIndex(r'sahabaId', [sahabaId]);
  }

  SahabaCollection? getBySahabaIdSync(int sahabaId) {
    return getByIndexSync(r'sahabaId', [sahabaId]);
  }

  Future<bool> deleteBySahabaId(int sahabaId) {
    return deleteByIndex(r'sahabaId', [sahabaId]);
  }

  bool deleteBySahabaIdSync(int sahabaId) {
    return deleteByIndexSync(r'sahabaId', [sahabaId]);
  }

  Future<List<SahabaCollection?>> getAllBySahabaId(List<int> sahabaIdValues) {
    final values = sahabaIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'sahabaId', values);
  }

  List<SahabaCollection?> getAllBySahabaIdSync(List<int> sahabaIdValues) {
    final values = sahabaIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'sahabaId', values);
  }

  Future<int> deleteAllBySahabaId(List<int> sahabaIdValues) {
    final values = sahabaIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'sahabaId', values);
  }

  int deleteAllBySahabaIdSync(List<int> sahabaIdValues) {
    final values = sahabaIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'sahabaId', values);
  }

  Future<Id> putBySahabaId(SahabaCollection object) {
    return putByIndex(r'sahabaId', object);
  }

  Id putBySahabaIdSync(SahabaCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'sahabaId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySahabaId(List<SahabaCollection> objects) {
    return putAllByIndex(r'sahabaId', objects);
  }

  List<Id> putAllBySahabaIdSync(List<SahabaCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'sahabaId', objects, saveLinks: saveLinks);
  }
}

extension SahabaCollectionQueryWhereSort
    on QueryBuilder<SahabaCollection, SahabaCollection, QWhere> {
  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhere> anySahabaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sahabaId'),
      );
    });
  }
}

extension SahabaCollectionQueryWhere
    on QueryBuilder<SahabaCollection, SahabaCollection, QWhereClause> {
  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause> idBetween(
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause>
      sahabaIdEqualTo(int sahabaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sahabaId',
        value: [sahabaId],
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause>
      sahabaIdNotEqualTo(int sahabaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sahabaId',
              lower: [],
              upper: [sahabaId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sahabaId',
              lower: [sahabaId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sahabaId',
              lower: [sahabaId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sahabaId',
              lower: [],
              upper: [sahabaId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause>
      sahabaIdGreaterThan(
    int sahabaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sahabaId',
        lower: [sahabaId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause>
      sahabaIdLessThan(
    int sahabaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sahabaId',
        lower: [],
        upper: [sahabaId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause>
      sahabaIdBetween(
    int lowerSahabaId,
    int upperSahabaId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sahabaId',
        lower: [lowerSahabaId],
        includeLower: includeLower,
        upper: [upperSahabaId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause>
      slugEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'slug',
        value: [slug],
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterWhereClause>
      slugNotEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SahabaCollectionQueryFilter
    on QueryBuilder<SahabaCollection, SahabaCollection, QFilterCondition> {
  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      biographyMdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'biographyMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      biographyMdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'biographyMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      biographyMdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'biographyMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      biographyMdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'biographyMd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      biographyMdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'biographyMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      biographyMdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'biographyMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      biographyMdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'biographyMd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      biographyMdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'biographyMd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      biographyMdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'biographyMd',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      biographyMdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'biographyMd',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      epithetKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'epithetKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      epithetKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'epithetKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      epithetKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'epithetKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      epithetKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'epithetKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      epithetKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'epithetKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      epithetKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'epithetKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      epithetKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'epithetKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      epithetKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'epithetKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      epithetKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'epithetKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      epithetKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'epithetKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      nameArContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      nameArMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      nameArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      nameArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      nameKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      nameKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      nameKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      nameKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      sahabaIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sahabaId',
        value: value,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      sahabaIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sahabaId',
        value: value,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      sahabaIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sahabaId',
        value: value,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      sahabaIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sahabaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      slugEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      slugGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      slugLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      slugBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slug',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      slugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      slugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      slugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      slugMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slug',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      slugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      slugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      summaryKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summaryKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      summaryKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'summaryKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      summaryKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'summaryKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      summaryKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'summaryKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      summaryKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'summaryKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      summaryKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'summaryKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      summaryKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'summaryKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      summaryKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'summaryKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      summaryKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summaryKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      summaryKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'summaryKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
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

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      virtuesKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'virtuesKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      virtuesKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'virtuesKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      virtuesKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'virtuesKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      virtuesKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'virtuesKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      virtuesKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'virtuesKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      virtuesKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'virtuesKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      virtuesKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'virtuesKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      virtuesKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'virtuesKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      virtuesKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'virtuesKu',
        value: '',
      ));
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterFilterCondition>
      virtuesKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'virtuesKu',
        value: '',
      ));
    });
  }
}

extension SahabaCollectionQueryObject
    on QueryBuilder<SahabaCollection, SahabaCollection, QFilterCondition> {}

extension SahabaCollectionQueryLinks
    on QueryBuilder<SahabaCollection, SahabaCollection, QFilterCondition> {}

extension SahabaCollectionQuerySortBy
    on QueryBuilder<SahabaCollection, SahabaCollection, QSortBy> {
  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByBiographyMd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biographyMd', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByBiographyMdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biographyMd', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByEpithetKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epithetKu', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByEpithetKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epithetKu', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortBySahabaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sahabaId', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortBySahabaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sahabaId', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy> sortBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortBySummaryKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryKu', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortBySummaryKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryKu', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByVirtuesKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtuesKu', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      sortByVirtuesKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtuesKu', Sort.desc);
    });
  }
}

extension SahabaCollectionQuerySortThenBy
    on QueryBuilder<SahabaCollection, SahabaCollection, QSortThenBy> {
  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByBiographyMd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biographyMd', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByBiographyMdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biographyMd', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByEpithetKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epithetKu', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByEpithetKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'epithetKu', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenBySahabaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sahabaId', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenBySahabaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sahabaId', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy> thenBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenBySummaryKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryKu', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenBySummaryKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryKu', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByVirtuesKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtuesKu', Sort.asc);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QAfterSortBy>
      thenByVirtuesKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtuesKu', Sort.desc);
    });
  }
}

extension SahabaCollectionQueryWhereDistinct
    on QueryBuilder<SahabaCollection, SahabaCollection, QDistinct> {
  QueryBuilder<SahabaCollection, SahabaCollection, QDistinct>
      distinctByBiographyMd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'biographyMd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QDistinct>
      distinctByEpithetKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'epithetKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QDistinct> distinctByNameAr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QDistinct> distinctByNameKu(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QDistinct>
      distinctBySahabaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sahabaId');
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QDistinct> distinctBySlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slug', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QDistinct>
      distinctBySummaryKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summaryKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QDistinct>
      distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }

  QueryBuilder<SahabaCollection, SahabaCollection, QDistinct>
      distinctByVirtuesKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'virtuesKu', caseSensitive: caseSensitive);
    });
  }
}

extension SahabaCollectionQueryProperty
    on QueryBuilder<SahabaCollection, SahabaCollection, QQueryProperty> {
  QueryBuilder<SahabaCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SahabaCollection, String, QQueryOperations>
      biographyMdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'biographyMd');
    });
  }

  QueryBuilder<SahabaCollection, String, QQueryOperations> epithetKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'epithetKu');
    });
  }

  QueryBuilder<SahabaCollection, String, QQueryOperations> nameArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameAr');
    });
  }

  QueryBuilder<SahabaCollection, String, QQueryOperations> nameKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameKu');
    });
  }

  QueryBuilder<SahabaCollection, int, QQueryOperations> sahabaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sahabaId');
    });
  }

  QueryBuilder<SahabaCollection, String, QQueryOperations> slugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slug');
    });
  }

  QueryBuilder<SahabaCollection, String, QQueryOperations> summaryKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summaryKu');
    });
  }

  QueryBuilder<SahabaCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<SahabaCollection, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }

  QueryBuilder<SahabaCollection, String, QQueryOperations> virtuesKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'virtuesKu');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHadithCollectionCollection on Isar {
  IsarCollection<HadithCollection> get hadithCollections => this.collection();
}

final HadithCollectionSchema = CollectionSchema(
  name: r'HadithCollection',
  id: -int.parse('7963363437607057576'),
  properties: {
    r'arabicText': PropertySchema(
      id: 0,
      name: r'arabicText',
      type: IsarType.string,
    ),
    r'categoryId': PropertySchema(
      id: 1,
      name: r'categoryId',
      type: IsarType.long,
    ),
    r'categoryNameAr': PropertySchema(
      id: 2,
      name: r'categoryNameAr',
      type: IsarType.string,
    ),
    r'categoryNameKu': PropertySchema(
      id: 3,
      name: r'categoryNameKu',
      type: IsarType.string,
    ),
    r'explanationEn': PropertySchema(
      id: 4,
      name: r'explanationEn',
      type: IsarType.string,
    ),
    r'explanationKu': PropertySchema(
      id: 5,
      name: r'explanationKu',
      type: IsarType.string,
    ),
    r'hadithId': PropertySchema(
      id: 6,
      name: r'hadithId',
      type: IsarType.long,
    ),
    r'isActive': PropertySchema(
      id: 7,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'narrator': PropertySchema(
      id: 8,
      name: r'narrator',
      type: IsarType.string,
    ),
    r'order': PropertySchema(
      id: 9,
      name: r'order',
      type: IsarType.long,
    ),
    r'slug': PropertySchema(
      id: 10,
      name: r'slug',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 11,
      name: r'source',
      type: IsarType.string,
    ),
    r'translationEn': PropertySchema(
      id: 12,
      name: r'translationEn',
      type: IsarType.string,
    ),
    r'translationKu': PropertySchema(
      id: 13,
      name: r'translationKu',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'version': PropertySchema(
      id: 15,
      name: r'version',
      type: IsarType.long,
    )
  },
  estimateSize: _hadithCollectionEstimateSize,
  serialize: _hadithCollectionSerialize,
  deserialize: _hadithCollectionDeserialize,
  deserializeProp: _hadithCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'hadithId': IndexSchema(
      id: int.parse('3874849906276205956'),
      name: r'hadithId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'hadithId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'slug': IndexSchema(
      id: int.parse('6169444064746062836'),
      name: r'slug',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'slug',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _hadithCollectionGetId,
  getLinks: _hadithCollectionGetLinks,
  attach: _hadithCollectionAttach,
  version: '3.1.0+1',
);

int _hadithCollectionEstimateSize(
  HadithCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.arabicText.length * 3;
  bytesCount += 3 + object.categoryNameAr.length * 3;
  bytesCount += 3 + object.categoryNameKu.length * 3;
  {
    final value = object.explanationEn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.explanationKu;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.narrator;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.slug.length * 3;
  {
    final value = object.source;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.translationEn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.translationKu.length * 3;
  return bytesCount;
}

void _hadithCollectionSerialize(
  HadithCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.arabicText);
  writer.writeLong(offsets[1], object.categoryId);
  writer.writeString(offsets[2], object.categoryNameAr);
  writer.writeString(offsets[3], object.categoryNameKu);
  writer.writeString(offsets[4], object.explanationEn);
  writer.writeString(offsets[5], object.explanationKu);
  writer.writeLong(offsets[6], object.hadithId);
  writer.writeBool(offsets[7], object.isActive);
  writer.writeString(offsets[8], object.narrator);
  writer.writeLong(offsets[9], object.order);
  writer.writeString(offsets[10], object.slug);
  writer.writeString(offsets[11], object.source);
  writer.writeString(offsets[12], object.translationEn);
  writer.writeString(offsets[13], object.translationKu);
  writer.writeDateTime(offsets[14], object.updatedAt);
  writer.writeLong(offsets[15], object.version);
}

HadithCollection _hadithCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HadithCollection(
    arabicText: reader.readString(offsets[0]),
    categoryId: reader.readLong(offsets[1]),
    categoryNameAr: reader.readString(offsets[2]),
    categoryNameKu: reader.readString(offsets[3]),
    explanationEn: reader.readStringOrNull(offsets[4]),
    explanationKu: reader.readStringOrNull(offsets[5]),
    hadithId: reader.readLong(offsets[6]),
    isActive: reader.readBool(offsets[7]),
    narrator: reader.readStringOrNull(offsets[8]),
    order: reader.readLong(offsets[9]),
    slug: reader.readString(offsets[10]),
    source: reader.readStringOrNull(offsets[11]),
    translationEn: reader.readStringOrNull(offsets[12]),
    translationKu: reader.readString(offsets[13]),
    updatedAt: reader.readDateTime(offsets[14]),
    version: reader.readLong(offsets[15]),
  );
  object.id = id;
  return object;
}

P _hadithCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hadithCollectionGetId(HadithCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hadithCollectionGetLinks(HadithCollection object) {
  return [];
}

void _hadithCollectionAttach(
    IsarCollection<dynamic> col, Id id, HadithCollection object) {
  object.id = id;
}

extension HadithCollectionByIndex on IsarCollection<HadithCollection> {
  Future<HadithCollection?> getByHadithId(int hadithId) {
    return getByIndex(r'hadithId', [hadithId]);
  }

  HadithCollection? getByHadithIdSync(int hadithId) {
    return getByIndexSync(r'hadithId', [hadithId]);
  }

  Future<bool> deleteByHadithId(int hadithId) {
    return deleteByIndex(r'hadithId', [hadithId]);
  }

  bool deleteByHadithIdSync(int hadithId) {
    return deleteByIndexSync(r'hadithId', [hadithId]);
  }

  Future<List<HadithCollection?>> getAllByHadithId(List<int> hadithIdValues) {
    final values = hadithIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'hadithId', values);
  }

  List<HadithCollection?> getAllByHadithIdSync(List<int> hadithIdValues) {
    final values = hadithIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'hadithId', values);
  }

  Future<int> deleteAllByHadithId(List<int> hadithIdValues) {
    final values = hadithIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'hadithId', values);
  }

  int deleteAllByHadithIdSync(List<int> hadithIdValues) {
    final values = hadithIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'hadithId', values);
  }

  Future<Id> putByHadithId(HadithCollection object) {
    return putByIndex(r'hadithId', object);
  }

  Id putByHadithIdSync(HadithCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'hadithId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHadithId(List<HadithCollection> objects) {
    return putAllByIndex(r'hadithId', objects);
  }

  List<Id> putAllByHadithIdSync(List<HadithCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'hadithId', objects, saveLinks: saveLinks);
  }
}

extension HadithCollectionQueryWhereSort
    on QueryBuilder<HadithCollection, HadithCollection, QWhere> {
  QueryBuilder<HadithCollection, HadithCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhere> anyHadithId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'hadithId'),
      );
    });
  }
}

extension HadithCollectionQueryWhere
    on QueryBuilder<HadithCollection, HadithCollection, QWhereClause> {
  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause>
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

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause> idBetween(
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

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause>
      hadithIdEqualTo(int hadithId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'hadithId',
        value: [hadithId],
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause>
      hadithIdNotEqualTo(int hadithId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hadithId',
              lower: [],
              upper: [hadithId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hadithId',
              lower: [hadithId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hadithId',
              lower: [hadithId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'hadithId',
              lower: [],
              upper: [hadithId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause>
      hadithIdGreaterThan(
    int hadithId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'hadithId',
        lower: [hadithId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause>
      hadithIdLessThan(
    int hadithId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'hadithId',
        lower: [],
        upper: [hadithId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause>
      hadithIdBetween(
    int lowerHadithId,
    int upperHadithId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'hadithId',
        lower: [lowerHadithId],
        includeLower: includeLower,
        upper: [upperHadithId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause>
      slugEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'slug',
        value: [slug],
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterWhereClause>
      slugNotEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ));
      }
    });
  }
}

extension HadithCollectionQueryFilter
    on QueryBuilder<HadithCollection, HadithCollection, QFilterCondition> {
  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      arabicTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      arabicTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      arabicTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      arabicTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'arabicText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      arabicTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      arabicTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      arabicTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      arabicTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'arabicText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      arabicTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arabicText',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      arabicTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'arabicText',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameArEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryNameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameArGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryNameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameArLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryNameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameArBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryNameAr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameArStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryNameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameArEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryNameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameArContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryNameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameArMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryNameAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryNameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryNameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryNameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryNameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryNameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryNameKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryNameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryNameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryNameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryNameKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryNameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      categoryNameKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryNameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'explanationEn',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'explanationEn',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'explanationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'explanationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'explanationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'explanationEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'explanationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'explanationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'explanationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'explanationEn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'explanationEn',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationEnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'explanationEn',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'explanationKu',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'explanationKu',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'explanationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'explanationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'explanationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'explanationKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'explanationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'explanationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'explanationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'explanationKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'explanationKu',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      explanationKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'explanationKu',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      hadithIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hadithId',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      hadithIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hadithId',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      hadithIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hadithId',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      hadithIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hadithId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
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

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
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

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
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

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'narrator',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'narrator',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'narrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'narrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'narrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'narrator',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'narrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'narrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'narrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'narrator',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'narrator',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      narratorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'narrator',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      orderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      orderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      orderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      orderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'order',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      slugEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      slugGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      slugLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      slugBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slug',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      slugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      slugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      slugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      slugMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slug',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      slugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      slugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'source',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'source',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'translationEn',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'translationEn',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translationEn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translationEn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translationEn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationEn',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationEnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translationEn',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translationKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translationKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translationKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationKu',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      translationKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translationKu',
        value: '',
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
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

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
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

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
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

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterFilterCondition>
      versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HadithCollectionQueryObject
    on QueryBuilder<HadithCollection, HadithCollection, QFilterCondition> {}

extension HadithCollectionQueryLinks
    on QueryBuilder<HadithCollection, HadithCollection, QFilterCondition> {}

extension HadithCollectionQuerySortBy
    on QueryBuilder<HadithCollection, HadithCollection, QSortBy> {
  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByArabicText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arabicText', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByArabicTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arabicText', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByCategoryNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryNameAr', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByCategoryNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryNameAr', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByCategoryNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryNameKu', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByCategoryNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryNameKu', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByExplanationEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explanationEn', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByExplanationEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explanationEn', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByExplanationKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explanationKu', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByExplanationKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explanationKu', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByHadithId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithId', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByHadithIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithId', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByNarrator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narrator', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByNarratorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narrator', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy> sortByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy> sortBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByTranslationEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationEn', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByTranslationEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationEn', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByTranslationKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationKu', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByTranslationKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationKu', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension HadithCollectionQuerySortThenBy
    on QueryBuilder<HadithCollection, HadithCollection, QSortThenBy> {
  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByArabicText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arabicText', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByArabicTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arabicText', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByCategoryNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryNameAr', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByCategoryNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryNameAr', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByCategoryNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryNameKu', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByCategoryNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryNameKu', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByExplanationEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explanationEn', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByExplanationEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explanationEn', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByExplanationKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explanationKu', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByExplanationKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explanationKu', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByHadithId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithId', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByHadithIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithId', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByNarrator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narrator', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByNarratorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narrator', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy> thenByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy> thenBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByTranslationEn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationEn', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByTranslationEnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationEn', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByTranslationKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationKu', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByTranslationKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationKu', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension HadithCollectionQueryWhereDistinct
    on QueryBuilder<HadithCollection, HadithCollection, QDistinct> {
  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByArabicText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arabicText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByCategoryNameAr({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryNameAr',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByCategoryNameKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryNameKu',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByExplanationEn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'explanationEn',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByExplanationKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'explanationKu',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByHadithId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hadithId');
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByNarrator({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'narrator', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'order');
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct> distinctBySlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slug', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct> distinctBySource(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByTranslationEn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translationEn',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByTranslationKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translationKu',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<HadithCollection, HadithCollection, QDistinct>
      distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension HadithCollectionQueryProperty
    on QueryBuilder<HadithCollection, HadithCollection, QQueryProperty> {
  QueryBuilder<HadithCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HadithCollection, String, QQueryOperations>
      arabicTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arabicText');
    });
  }

  QueryBuilder<HadithCollection, int, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<HadithCollection, String, QQueryOperations>
      categoryNameArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryNameAr');
    });
  }

  QueryBuilder<HadithCollection, String, QQueryOperations>
      categoryNameKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryNameKu');
    });
  }

  QueryBuilder<HadithCollection, String?, QQueryOperations>
      explanationEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'explanationEn');
    });
  }

  QueryBuilder<HadithCollection, String?, QQueryOperations>
      explanationKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'explanationKu');
    });
  }

  QueryBuilder<HadithCollection, int, QQueryOperations> hadithIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hadithId');
    });
  }

  QueryBuilder<HadithCollection, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<HadithCollection, String?, QQueryOperations> narratorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'narrator');
    });
  }

  QueryBuilder<HadithCollection, int, QQueryOperations> orderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'order');
    });
  }

  QueryBuilder<HadithCollection, String, QQueryOperations> slugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slug');
    });
  }

  QueryBuilder<HadithCollection, String?, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<HadithCollection, String?, QQueryOperations>
      translationEnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translationEn');
    });
  }

  QueryBuilder<HadithCollection, String, QQueryOperations>
      translationKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translationKu');
    });
  }

  QueryBuilder<HadithCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<HadithCollection, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTafsirCollectionCollection on Isar {
  IsarCollection<TafsirCollection> get tafsirCollections => this.collection();
}

final TafsirCollectionSchema = CollectionSchema(
  name: r'TafsirCollection',
  id: int.parse('5104404639102638749'),
  properties: {
    r'ayahNumber': PropertySchema(
      id: 0,
      name: r'ayahNumber',
      type: IsarType.long,
    ),
    r'slug': PropertySchema(
      id: 1,
      name: r'slug',
      type: IsarType.string,
    ),
    r'surahNumber': PropertySchema(
      id: 2,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'text': PropertySchema(
      id: 3,
      name: r'text',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'version': PropertySchema(
      id: 5,
      name: r'version',
      type: IsarType.long,
    )
  },
  estimateSize: _tafsirCollectionEstimateSize,
  serialize: _tafsirCollectionSerialize,
  deserialize: _tafsirCollectionDeserialize,
  deserializeProp: _tafsirCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'surahNumber_ayahNumber': IndexSchema(
      id: int.parse('5327427526691098780'),
      name: r'surahNumber_ayahNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'surahNumber',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'ayahNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'slug': IndexSchema(
      id: int.parse('6169444064746062836'),
      name: r'slug',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'slug',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _tafsirCollectionGetId,
  getLinks: _tafsirCollectionGetLinks,
  attach: _tafsirCollectionAttach,
  version: '3.1.0+1',
);

int _tafsirCollectionEstimateSize(
  TafsirCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.slug.length * 3;
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _tafsirCollectionSerialize(
  TafsirCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ayahNumber);
  writer.writeString(offsets[1], object.slug);
  writer.writeLong(offsets[2], object.surahNumber);
  writer.writeString(offsets[3], object.text);
  writer.writeDateTime(offsets[4], object.updatedAt);
  writer.writeLong(offsets[5], object.version);
}

TafsirCollection _tafsirCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TafsirCollection(
    ayahNumber: reader.readLong(offsets[0]),
    slug: reader.readString(offsets[1]),
    surahNumber: reader.readLong(offsets[2]),
    text: reader.readString(offsets[3]),
    updatedAt: reader.readDateTime(offsets[4]),
    version: reader.readLong(offsets[5]),
  );
  object.id = id;
  return object;
}

P _tafsirCollectionDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tafsirCollectionGetId(TafsirCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tafsirCollectionGetLinks(TafsirCollection object) {
  return [];
}

void _tafsirCollectionAttach(
    IsarCollection<dynamic> col, Id id, TafsirCollection object) {
  object.id = id;
}

extension TafsirCollectionQueryWhereSort
    on QueryBuilder<TafsirCollection, TafsirCollection, QWhere> {
  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhere>
      anySurahNumberAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'surahNumber_ayahNumber'),
      );
    });
  }
}

extension TafsirCollectionQueryWhere
    on QueryBuilder<TafsirCollection, TafsirCollection, QWhereClause> {
  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause> idBetween(
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      surahNumberEqualToAnyAyahNumber(int surahNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'surahNumber_ayahNumber',
        value: [surahNumber],
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      surahNumberNotEqualToAnyAyahNumber(int surahNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber_ayahNumber',
              lower: [],
              upper: [surahNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber_ayahNumber',
              lower: [surahNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber_ayahNumber',
              lower: [surahNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber_ayahNumber',
              lower: [],
              upper: [surahNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      surahNumberGreaterThanAnyAyahNumber(
    int surahNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber_ayahNumber',
        lower: [surahNumber],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      surahNumberLessThanAnyAyahNumber(
    int surahNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber_ayahNumber',
        lower: [],
        upper: [surahNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      surahNumberBetweenAnyAyahNumber(
    int lowerSurahNumber,
    int upperSurahNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber_ayahNumber',
        lower: [lowerSurahNumber],
        includeLower: includeLower,
        upper: [upperSurahNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      surahNumberAyahNumberEqualTo(int surahNumber, int ayahNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'surahNumber_ayahNumber',
        value: [surahNumber, ayahNumber],
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      surahNumberEqualToAyahNumberNotEqualTo(int surahNumber, int ayahNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber_ayahNumber',
              lower: [surahNumber],
              upper: [surahNumber, ayahNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber_ayahNumber',
              lower: [surahNumber, ayahNumber],
              includeLower: false,
              upper: [surahNumber],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber_ayahNumber',
              lower: [surahNumber, ayahNumber],
              includeLower: false,
              upper: [surahNumber],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber_ayahNumber',
              lower: [surahNumber],
              upper: [surahNumber, ayahNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      surahNumberEqualToAyahNumberGreaterThan(
    int surahNumber,
    int ayahNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber_ayahNumber',
        lower: [surahNumber, ayahNumber],
        includeLower: include,
        upper: [surahNumber],
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      surahNumberEqualToAyahNumberLessThan(
    int surahNumber,
    int ayahNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber_ayahNumber',
        lower: [surahNumber],
        upper: [surahNumber, ayahNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      surahNumberEqualToAyahNumberBetween(
    int surahNumber,
    int lowerAyahNumber,
    int upperAyahNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber_ayahNumber',
        lower: [surahNumber, lowerAyahNumber],
        includeLower: includeLower,
        upper: [surahNumber, upperAyahNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      slugEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'slug',
        value: [slug],
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterWhereClause>
      slugNotEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TafsirCollectionQueryFilter
    on QueryBuilder<TafsirCollection, TafsirCollection, QFilterCondition> {
  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      ayahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      slugEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      slugGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      slugLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      slugBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slug',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      slugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      slugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      slugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      slugMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slug',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      slugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      slugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      surahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
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

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterFilterCondition>
      versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TafsirCollectionQueryObject
    on QueryBuilder<TafsirCollection, TafsirCollection, QFilterCondition> {}

extension TafsirCollectionQueryLinks
    on QueryBuilder<TafsirCollection, TafsirCollection, QFilterCondition> {}

extension TafsirCollectionQuerySortBy
    on QueryBuilder<TafsirCollection, TafsirCollection, QSortBy> {
  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      sortByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      sortByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy> sortBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      sortBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension TafsirCollectionQuerySortThenBy
    on QueryBuilder<TafsirCollection, TafsirCollection, QSortThenBy> {
  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy> thenBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension TafsirCollectionQueryWhereDistinct
    on QueryBuilder<TafsirCollection, TafsirCollection, QDistinct> {
  QueryBuilder<TafsirCollection, TafsirCollection, QDistinct>
      distinctByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayahNumber');
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QDistinct> distinctBySlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slug', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QDistinct>
      distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<TafsirCollection, TafsirCollection, QDistinct>
      distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension TafsirCollectionQueryProperty
    on QueryBuilder<TafsirCollection, TafsirCollection, QQueryProperty> {
  QueryBuilder<TafsirCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TafsirCollection, int, QQueryOperations> ayahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayahNumber');
    });
  }

  QueryBuilder<TafsirCollection, String, QQueryOperations> slugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slug');
    });
  }

  QueryBuilder<TafsirCollection, int, QQueryOperations> surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }

  QueryBuilder<TafsirCollection, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<TafsirCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<TafsirCollection, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReciterCollectionCollection on Isar {
  IsarCollection<ReciterCollection> get reciterCollections => this.collection();
}

final ReciterCollectionSchema = CollectionSchema(
  name: r'ReciterCollection',
  id: -int.parse('7542606624115583787'),
  properties: {
    r'bioKu': PropertySchema(
      id: 0,
      name: r'bioKu',
      type: IsarType.string,
    ),
    r'downloadBaseUrl': PropertySchema(
      id: 1,
      name: r'downloadBaseUrl',
      type: IsarType.string,
    ),
    r'imageAsset': PropertySchema(
      id: 2,
      name: r'imageAsset',
      type: IsarType.string,
    ),
    r'nameAr': PropertySchema(
      id: 3,
      name: r'nameAr',
      type: IsarType.string,
    ),
    r'nameKu': PropertySchema(
      id: 4,
      name: r'nameKu',
      type: IsarType.string,
    ),
    r'reciterId': PropertySchema(
      id: 5,
      name: r'reciterId',
      type: IsarType.long,
    ),
    r'sampleAudioUrl': PropertySchema(
      id: 6,
      name: r'sampleAudioUrl',
      type: IsarType.string,
    ),
    r'slug': PropertySchema(
      id: 7,
      name: r'slug',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 8,
      name: r'type',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'version': PropertySchema(
      id: 10,
      name: r'version',
      type: IsarType.long,
    )
  },
  estimateSize: _reciterCollectionEstimateSize,
  serialize: _reciterCollectionSerialize,
  deserialize: _reciterCollectionDeserialize,
  deserializeProp: _reciterCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'reciterId': IndexSchema(
      id: -int.parse('5029838260836744949'),
      name: r'reciterId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reciterId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'slug': IndexSchema(
      id: int.parse('6169444064746062836'),
      name: r'slug',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'slug',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _reciterCollectionGetId,
  getLinks: _reciterCollectionGetLinks,
  attach: _reciterCollectionAttach,
  version: '3.1.0+1',
);

int _reciterCollectionEstimateSize(
  ReciterCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bioKu.length * 3;
  bytesCount += 3 + object.downloadBaseUrl.length * 3;
  bytesCount += 3 + object.imageAsset.length * 3;
  bytesCount += 3 + object.nameAr.length * 3;
  bytesCount += 3 + object.nameKu.length * 3;
  bytesCount += 3 + object.sampleAudioUrl.length * 3;
  bytesCount += 3 + object.slug.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _reciterCollectionSerialize(
  ReciterCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bioKu);
  writer.writeString(offsets[1], object.downloadBaseUrl);
  writer.writeString(offsets[2], object.imageAsset);
  writer.writeString(offsets[3], object.nameAr);
  writer.writeString(offsets[4], object.nameKu);
  writer.writeLong(offsets[5], object.reciterId);
  writer.writeString(offsets[6], object.sampleAudioUrl);
  writer.writeString(offsets[7], object.slug);
  writer.writeString(offsets[8], object.type);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeLong(offsets[10], object.version);
}

ReciterCollection _reciterCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReciterCollection(
    bioKu: reader.readString(offsets[0]),
    downloadBaseUrl: reader.readString(offsets[1]),
    imageAsset: reader.readString(offsets[2]),
    nameAr: reader.readString(offsets[3]),
    nameKu: reader.readString(offsets[4]),
    reciterId: reader.readLong(offsets[5]),
    sampleAudioUrl: reader.readString(offsets[6]),
    slug: reader.readString(offsets[7]),
    type: reader.readString(offsets[8]),
    updatedAt: reader.readDateTime(offsets[9]),
    version: reader.readLong(offsets[10]),
  );
  object.id = id;
  return object;
}

P _reciterCollectionDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reciterCollectionGetId(ReciterCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reciterCollectionGetLinks(
    ReciterCollection object) {
  return [];
}

void _reciterCollectionAttach(
    IsarCollection<dynamic> col, Id id, ReciterCollection object) {
  object.id = id;
}

extension ReciterCollectionByIndex on IsarCollection<ReciterCollection> {
  Future<ReciterCollection?> getByReciterId(int reciterId) {
    return getByIndex(r'reciterId', [reciterId]);
  }

  ReciterCollection? getByReciterIdSync(int reciterId) {
    return getByIndexSync(r'reciterId', [reciterId]);
  }

  Future<bool> deleteByReciterId(int reciterId) {
    return deleteByIndex(r'reciterId', [reciterId]);
  }

  bool deleteByReciterIdSync(int reciterId) {
    return deleteByIndexSync(r'reciterId', [reciterId]);
  }

  Future<List<ReciterCollection?>> getAllByReciterId(
      List<int> reciterIdValues) {
    final values = reciterIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'reciterId', values);
  }

  List<ReciterCollection?> getAllByReciterIdSync(List<int> reciterIdValues) {
    final values = reciterIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'reciterId', values);
  }

  Future<int> deleteAllByReciterId(List<int> reciterIdValues) {
    final values = reciterIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'reciterId', values);
  }

  int deleteAllByReciterIdSync(List<int> reciterIdValues) {
    final values = reciterIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'reciterId', values);
  }

  Future<Id> putByReciterId(ReciterCollection object) {
    return putByIndex(r'reciterId', object);
  }

  Id putByReciterIdSync(ReciterCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'reciterId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByReciterId(List<ReciterCollection> objects) {
    return putAllByIndex(r'reciterId', objects);
  }

  List<Id> putAllByReciterIdSync(List<ReciterCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'reciterId', objects, saveLinks: saveLinks);
  }
}

extension ReciterCollectionQueryWhereSort
    on QueryBuilder<ReciterCollection, ReciterCollection, QWhere> {
  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhere>
      anyReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'reciterId'),
      );
    });
  }
}

extension ReciterCollectionQueryWhere
    on QueryBuilder<ReciterCollection, ReciterCollection, QWhereClause> {
  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
      reciterIdEqualTo(int reciterId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reciterId',
        value: [reciterId],
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
      reciterIdNotEqualTo(int reciterId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reciterId',
              lower: [],
              upper: [reciterId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reciterId',
              lower: [reciterId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reciterId',
              lower: [reciterId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reciterId',
              lower: [],
              upper: [reciterId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
      reciterIdGreaterThan(
    int reciterId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reciterId',
        lower: [reciterId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
      reciterIdLessThan(
    int reciterId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reciterId',
        lower: [],
        upper: [reciterId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
      reciterIdBetween(
    int lowerReciterId,
    int upperReciterId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reciterId',
        lower: [lowerReciterId],
        includeLower: includeLower,
        upper: [upperReciterId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
      slugEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'slug',
        value: [slug],
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterWhereClause>
      slugNotEqualTo(String slug) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ReciterCollectionQueryFilter
    on QueryBuilder<ReciterCollection, ReciterCollection, QFilterCondition> {
  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      bioKuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bioKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      bioKuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bioKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      bioKuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bioKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      bioKuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bioKu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      bioKuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bioKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      bioKuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bioKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      bioKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bioKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      bioKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bioKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      bioKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bioKu',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      bioKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bioKu',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      downloadBaseUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      downloadBaseUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      downloadBaseUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      downloadBaseUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadBaseUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      downloadBaseUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'downloadBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      downloadBaseUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'downloadBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      downloadBaseUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'downloadBaseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      downloadBaseUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'downloadBaseUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      downloadBaseUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadBaseUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      downloadBaseUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'downloadBaseUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      imageAssetEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageAsset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      imageAssetGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageAsset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      imageAssetLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageAsset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      imageAssetBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageAsset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      imageAssetStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageAsset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      imageAssetEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageAsset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      imageAssetContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageAsset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      imageAssetMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageAsset',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      imageAssetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageAsset',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      imageAssetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageAsset',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      nameArContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameAr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      nameArMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameAr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      nameArIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      nameArIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameAr',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      nameKuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameKu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      nameKuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameKu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      nameKuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      nameKuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameKu',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      reciterIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciterId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      reciterIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reciterId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      reciterIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reciterId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      reciterIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reciterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      sampleAudioUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sampleAudioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      sampleAudioUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sampleAudioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      sampleAudioUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sampleAudioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      sampleAudioUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sampleAudioUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      sampleAudioUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sampleAudioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      sampleAudioUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sampleAudioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      sampleAudioUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sampleAudioUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      sampleAudioUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sampleAudioUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      sampleAudioUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sampleAudioUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      sampleAudioUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sampleAudioUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      slugEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      slugGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      slugLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      slugBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slug',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      slugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      slugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      slugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      slugMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slug',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      slugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      slugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
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

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterFilterCondition>
      versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReciterCollectionQueryObject
    on QueryBuilder<ReciterCollection, ReciterCollection, QFilterCondition> {}

extension ReciterCollectionQueryLinks
    on QueryBuilder<ReciterCollection, ReciterCollection, QFilterCondition> {}

extension ReciterCollectionQuerySortBy
    on QueryBuilder<ReciterCollection, ReciterCollection, QSortBy> {
  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByBioKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bioKu', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByBioKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bioKu', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByDownloadBaseUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadBaseUrl', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByDownloadBaseUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadBaseUrl', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByImageAsset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageAsset', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByImageAssetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageAsset', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByReciterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortBySampleAudioUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sampleAudioUrl', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortBySampleAudioUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sampleAudioUrl', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension ReciterCollectionQuerySortThenBy
    on QueryBuilder<ReciterCollection, ReciterCollection, QSortThenBy> {
  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByBioKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bioKu', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByBioKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bioKu', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByDownloadBaseUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadBaseUrl', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByDownloadBaseUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadBaseUrl', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByImageAsset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageAsset', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByImageAssetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageAsset', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByNameAr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByNameArDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameAr', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByNameKu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByNameKuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameKu', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByReciterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterId', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenBySampleAudioUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sampleAudioUrl', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenBySampleAudioUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sampleAudioUrl', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension ReciterCollectionQueryWhereDistinct
    on QueryBuilder<ReciterCollection, ReciterCollection, QDistinct> {
  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct> distinctByBioKu(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bioKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct>
      distinctByDownloadBaseUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadBaseUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct>
      distinctByImageAsset({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageAsset', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct>
      distinctByNameAr({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameAr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct>
      distinctByNameKu({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameKu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct>
      distinctByReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reciterId');
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct>
      distinctBySampleAudioUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sampleAudioUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct> distinctBySlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slug', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ReciterCollection, ReciterCollection, QDistinct>
      distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension ReciterCollectionQueryProperty
    on QueryBuilder<ReciterCollection, ReciterCollection, QQueryProperty> {
  QueryBuilder<ReciterCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReciterCollection, String, QQueryOperations> bioKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bioKu');
    });
  }

  QueryBuilder<ReciterCollection, String, QQueryOperations>
      downloadBaseUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadBaseUrl');
    });
  }

  QueryBuilder<ReciterCollection, String, QQueryOperations>
      imageAssetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageAsset');
    });
  }

  QueryBuilder<ReciterCollection, String, QQueryOperations> nameArProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameAr');
    });
  }

  QueryBuilder<ReciterCollection, String, QQueryOperations> nameKuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameKu');
    });
  }

  QueryBuilder<ReciterCollection, int, QQueryOperations> reciterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reciterId');
    });
  }

  QueryBuilder<ReciterCollection, String, QQueryOperations>
      sampleAudioUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sampleAudioUrl');
    });
  }

  QueryBuilder<ReciterCollection, String, QQueryOperations> slugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slug');
    });
  }

  QueryBuilder<ReciterCollection, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<ReciterCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ReciterCollection, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteCollectionCollection on Isar {
  IsarCollection<FavoriteCollection> get favoriteCollections =>
      this.collection();
}

final FavoriteCollectionSchema = CollectionSchema(
  name: r'FavoriteCollection',
  id: int.parse('1010039148232529629'),
  properties: {
    r'ayahNumber': PropertySchema(
      id: 0,
      name: r'ayahNumber',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'favoritableId': PropertySchema(
      id: 2,
      name: r'favoritableId',
      type: IsarType.long,
    ),
    r'favoritableType': PropertySchema(
      id: 3,
      name: r'favoritableType',
      type: IsarType.string,
    ),
    r'favoriteId': PropertySchema(
      id: 4,
      name: r'favoriteId',
      type: IsarType.string,
    ),
    r'isSynced': PropertySchema(
      id: 5,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'previewText': PropertySchema(
      id: 6,
      name: r'previewText',
      type: IsarType.string,
    ),
    r'surahNumber': PropertySchema(
      id: 7,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _favoriteCollectionEstimateSize,
  serialize: _favoriteCollectionSerialize,
  deserialize: _favoriteCollectionDeserialize,
  deserializeProp: _favoriteCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'favoriteId': IndexSchema(
      id: -int.parse('1075630253902077187'),
      name: r'favoriteId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'favoriteId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _favoriteCollectionGetId,
  getLinks: _favoriteCollectionGetLinks,
  attach: _favoriteCollectionAttach,
  version: '3.1.0+1',
);

int _favoriteCollectionEstimateSize(
  FavoriteCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.favoritableType.length * 3;
  bytesCount += 3 + object.favoriteId.length * 3;
  {
    final value = object.previewText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _favoriteCollectionSerialize(
  FavoriteCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ayahNumber);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.favoritableId);
  writer.writeString(offsets[3], object.favoritableType);
  writer.writeString(offsets[4], object.favoriteId);
  writer.writeBool(offsets[5], object.isSynced);
  writer.writeString(offsets[6], object.previewText);
  writer.writeLong(offsets[7], object.surahNumber);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

FavoriteCollection _favoriteCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteCollection(
    ayahNumber: reader.readLongOrNull(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    favoritableId: reader.readLong(offsets[2]),
    favoritableType: reader.readString(offsets[3]),
    favoriteId: reader.readString(offsets[4]),
    isSynced: reader.readBool(offsets[5]),
    previewText: reader.readStringOrNull(offsets[6]),
    surahNumber: reader.readLongOrNull(offsets[7]),
    updatedAt: reader.readDateTime(offsets[8]),
  );
  object.id = id;
  return object;
}

P _favoriteCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favoriteCollectionGetId(FavoriteCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favoriteCollectionGetLinks(
    FavoriteCollection object) {
  return [];
}

void _favoriteCollectionAttach(
    IsarCollection<dynamic> col, Id id, FavoriteCollection object) {
  object.id = id;
}

extension FavoriteCollectionByIndex on IsarCollection<FavoriteCollection> {
  Future<FavoriteCollection?> getByFavoriteId(String favoriteId) {
    return getByIndex(r'favoriteId', [favoriteId]);
  }

  FavoriteCollection? getByFavoriteIdSync(String favoriteId) {
    return getByIndexSync(r'favoriteId', [favoriteId]);
  }

  Future<bool> deleteByFavoriteId(String favoriteId) {
    return deleteByIndex(r'favoriteId', [favoriteId]);
  }

  bool deleteByFavoriteIdSync(String favoriteId) {
    return deleteByIndexSync(r'favoriteId', [favoriteId]);
  }

  Future<List<FavoriteCollection?>> getAllByFavoriteId(
      List<String> favoriteIdValues) {
    final values = favoriteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'favoriteId', values);
  }

  List<FavoriteCollection?> getAllByFavoriteIdSync(
      List<String> favoriteIdValues) {
    final values = favoriteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'favoriteId', values);
  }

  Future<int> deleteAllByFavoriteId(List<String> favoriteIdValues) {
    final values = favoriteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'favoriteId', values);
  }

  int deleteAllByFavoriteIdSync(List<String> favoriteIdValues) {
    final values = favoriteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'favoriteId', values);
  }

  Future<Id> putByFavoriteId(FavoriteCollection object) {
    return putByIndex(r'favoriteId', object);
  }

  Id putByFavoriteIdSync(FavoriteCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'favoriteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFavoriteId(List<FavoriteCollection> objects) {
    return putAllByIndex(r'favoriteId', objects);
  }

  List<Id> putAllByFavoriteIdSync(List<FavoriteCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'favoriteId', objects, saveLinks: saveLinks);
  }
}

extension FavoriteCollectionQueryWhereSort
    on QueryBuilder<FavoriteCollection, FavoriteCollection, QWhere> {
  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FavoriteCollectionQueryWhere
    on QueryBuilder<FavoriteCollection, FavoriteCollection, QWhereClause> {
  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterWhereClause>
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterWhereClause>
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterWhereClause>
      favoriteIdEqualTo(String favoriteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'favoriteId',
        value: [favoriteId],
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterWhereClause>
      favoriteIdNotEqualTo(String favoriteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteId',
              lower: [],
              upper: [favoriteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteId',
              lower: [favoriteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteId',
              lower: [favoriteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favoriteId',
              lower: [],
              upper: [favoriteId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FavoriteCollectionQueryFilter
    on QueryBuilder<FavoriteCollection, FavoriteCollection, QFilterCondition> {
  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      ayahNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ayahNumber',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      ayahNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ayahNumber',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      ayahNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      ayahNumberGreaterThan(
    int? value, {
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      ayahNumberLessThan(
    int? value, {
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      ayahNumberBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoritableId',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favoritableId',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favoritableId',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favoritableId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favoritableType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'favoritableType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'favoritableType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoritableType',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoritableTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'favoritableType',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoriteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoriteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoriteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'favoriteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoriteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'favoriteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoriteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'favoriteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoriteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'favoriteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoriteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'favoriteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoriteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'favoriteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoriteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'favoriteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoriteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favoriteId',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      favoriteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'favoriteId',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'previewText',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'previewText',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previewText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previewText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previewText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previewText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'previewText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'previewText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'previewText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'previewText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previewText',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      previewTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'previewText',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      surahNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'surahNumber',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      surahNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'surahNumber',
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      surahNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      surahNumberGreaterThan(
    int? value, {
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      surahNumberLessThan(
    int? value, {
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      surahNumberBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
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

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterFilterCondition>
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

extension FavoriteCollectionQueryObject
    on QueryBuilder<FavoriteCollection, FavoriteCollection, QFilterCondition> {}

extension FavoriteCollectionQueryLinks
    on QueryBuilder<FavoriteCollection, FavoriteCollection, QFilterCondition> {}

extension FavoriteCollectionQuerySortBy
    on QueryBuilder<FavoriteCollection, FavoriteCollection, QSortBy> {
  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByFavoritableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByFavoritableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByFavoritableType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableType', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByFavoritableTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableType', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByFavoriteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByFavoriteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByPreviewText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewText', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByPreviewTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewText', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FavoriteCollectionQuerySortThenBy
    on QueryBuilder<FavoriteCollection, FavoriteCollection, QSortThenBy> {
  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByFavoritableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByFavoritableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByFavoritableType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableType', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByFavoritableTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoritableType', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByFavoriteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByFavoriteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favoriteId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByPreviewText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewText', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByPreviewTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previewText', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FavoriteCollectionQueryWhereDistinct
    on QueryBuilder<FavoriteCollection, FavoriteCollection, QDistinct> {
  QueryBuilder<FavoriteCollection, FavoriteCollection, QDistinct>
      distinctByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayahNumber');
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QDistinct>
      distinctByFavoritableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoritableId');
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QDistinct>
      distinctByFavoritableType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoritableType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QDistinct>
      distinctByFavoriteId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favoriteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QDistinct>
      distinctByPreviewText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previewText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QDistinct>
      distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }

  QueryBuilder<FavoriteCollection, FavoriteCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension FavoriteCollectionQueryProperty
    on QueryBuilder<FavoriteCollection, FavoriteCollection, QQueryProperty> {
  QueryBuilder<FavoriteCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavoriteCollection, int?, QQueryOperations>
      ayahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayahNumber');
    });
  }

  QueryBuilder<FavoriteCollection, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FavoriteCollection, int, QQueryOperations>
      favoritableIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoritableId');
    });
  }

  QueryBuilder<FavoriteCollection, String, QQueryOperations>
      favoritableTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoritableType');
    });
  }

  QueryBuilder<FavoriteCollection, String, QQueryOperations>
      favoriteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favoriteId');
    });
  }

  QueryBuilder<FavoriteCollection, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<FavoriteCollection, String?, QQueryOperations>
      previewTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previewText');
    });
  }

  QueryBuilder<FavoriteCollection, int?, QQueryOperations>
      surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }

  QueryBuilder<FavoriteCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
