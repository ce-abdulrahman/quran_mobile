// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SurahsTable extends Surahs with TableInfo<$SurahsTable, Surah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameKuMeta = const VerificationMeta('nameKu');
  @override
  late final GeneratedColumn<String> nameKu = GeneratedColumn<String>(
      'name_ku', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalAyahsMeta =
      const VerificationMeta('totalAyahs');
  @override
  late final GeneratedColumn<int> totalAyahs = GeneratedColumn<int>(
      'total_ayahs', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _revelationTypeMeta =
      const VerificationMeta('revelationType');
  @override
  late final GeneratedColumn<String> revelationType = GeneratedColumn<String>(
      'revelation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, number, nameAr, nameEn, nameKu, totalAyahs, revelationType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(Insertable<Surah> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ku')) {
      context.handle(_nameKuMeta,
          nameKu.isAcceptableOrUnknown(data['name_ku']!, _nameKuMeta));
    }
    if (data.containsKey('total_ayahs')) {
      context.handle(
          _totalAyahsMeta,
          totalAyahs.isAcceptableOrUnknown(
              data['total_ayahs']!, _totalAyahsMeta));
    } else if (isInserting) {
      context.missing(_totalAyahsMeta);
    }
    if (data.containsKey('revelation_type')) {
      context.handle(
          _revelationTypeMeta,
          revelationType.isAcceptableOrUnknown(
              data['revelation_type']!, _revelationTypeMeta));
    } else if (isInserting) {
      context.missing(_revelationTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Surah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Surah(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      nameKu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ku']),
      totalAyahs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_ayahs'])!,
      revelationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}revelation_type'])!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class Surah extends DataClass implements Insertable<Surah> {
  final int id;
  final int number;
  final String nameAr;
  final String nameEn;
  final String? nameKu;
  final int totalAyahs;
  final String revelationType;
  const Surah(
      {required this.id,
      required this.number,
      required this.nameAr,
      required this.nameEn,
      this.nameKu,
      required this.totalAyahs,
      required this.revelationType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || nameKu != null) {
      map['name_ku'] = Variable<String>(nameKu);
    }
    map['total_ayahs'] = Variable<int>(totalAyahs);
    map['revelation_type'] = Variable<String>(revelationType);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      id: Value(id),
      number: Value(number),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      nameKu:
          nameKu == null && nullToAbsent ? const Value.absent() : Value(nameKu),
      totalAyahs: Value(totalAyahs),
      revelationType: Value(revelationType),
    );
  }

  factory Surah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Surah(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameKu: serializer.fromJson<String?>(json['nameKu']),
      totalAyahs: serializer.fromJson<int>(json['totalAyahs']),
      revelationType: serializer.fromJson<String>(json['revelationType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameKu': serializer.toJson<String?>(nameKu),
      'totalAyahs': serializer.toJson<int>(totalAyahs),
      'revelationType': serializer.toJson<String>(revelationType),
    };
  }

  Surah copyWith(
          {int? id,
          int? number,
          String? nameAr,
          String? nameEn,
          Value<String?> nameKu = const Value.absent(),
          int? totalAyahs,
          String? revelationType}) =>
      Surah(
        id: id ?? this.id,
        number: number ?? this.number,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        nameKu: nameKu.present ? nameKu.value : this.nameKu,
        totalAyahs: totalAyahs ?? this.totalAyahs,
        revelationType: revelationType ?? this.revelationType,
      );
  Surah copyWithCompanion(SurahsCompanion data) {
    return Surah(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameKu: data.nameKu.present ? data.nameKu.value : this.nameKu,
      totalAyahs:
          data.totalAyahs.present ? data.totalAyahs.value : this.totalAyahs,
      revelationType: data.revelationType.present
          ? data.revelationType.value
          : this.revelationType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Surah(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameKu: $nameKu, ')
          ..write('totalAyahs: $totalAyahs, ')
          ..write('revelationType: $revelationType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, number, nameAr, nameEn, nameKu, totalAyahs, revelationType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.id == this.id &&
          other.number == this.number &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.nameKu == this.nameKu &&
          other.totalAyahs == this.totalAyahs &&
          other.revelationType == this.revelationType);
}

class SurahsCompanion extends UpdateCompanion<Surah> {
  final Value<int> id;
  final Value<int> number;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String?> nameKu;
  final Value<int> totalAyahs;
  final Value<String> revelationType;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameKu = const Value.absent(),
    this.totalAyahs = const Value.absent(),
    this.revelationType = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    required String nameAr,
    required String nameEn,
    this.nameKu = const Value.absent(),
    required int totalAyahs,
    required String revelationType,
  })  : number = Value(number),
        nameAr = Value(nameAr),
        nameEn = Value(nameEn),
        totalAyahs = Value(totalAyahs),
        revelationType = Value(revelationType);
  static Insertable<Surah> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? nameKu,
    Expression<int>? totalAyahs,
    Expression<String>? revelationType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (nameKu != null) 'name_ku': nameKu,
      if (totalAyahs != null) 'total_ayahs': totalAyahs,
      if (revelationType != null) 'revelation_type': revelationType,
    });
  }

  SurahsCompanion copyWith(
      {Value<int>? id,
      Value<int>? number,
      Value<String>? nameAr,
      Value<String>? nameEn,
      Value<String?>? nameKu,
      Value<int>? totalAyahs,
      Value<String>? revelationType}) {
    return SurahsCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      nameKu: nameKu ?? this.nameKu,
      totalAyahs: totalAyahs ?? this.totalAyahs,
      revelationType: revelationType ?? this.revelationType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameKu.present) {
      map['name_ku'] = Variable<String>(nameKu.value);
    }
    if (totalAyahs.present) {
      map['total_ayahs'] = Variable<int>(totalAyahs.value);
    }
    if (revelationType.present) {
      map['revelation_type'] = Variable<String>(revelationType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameKu: $nameKu, ')
          ..write('totalAyahs: $totalAyahs, ')
          ..write('revelationType: $revelationType')
          ..write(')'))
        .toString();
  }
}

class $AyahsTable extends Ayahs with TableInfo<$AyahsTable, Ayah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _surahIdMeta =
      const VerificationMeta('surahId');
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
      'surah_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ayahNumberMeta =
      const VerificationMeta('ayahNumber');
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
      'ayah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pageNumberMeta =
      const VerificationMeta('pageNumber');
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
      'page_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _juzNumberMeta =
      const VerificationMeta('juzNumber');
  @override
  late final GeneratedColumn<int> juzNumber = GeneratedColumn<int>(
      'juz_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _textUthmaniMeta =
      const VerificationMeta('textUthmani');
  @override
  late final GeneratedColumn<String> textUthmani = GeneratedColumn<String>(
      'text_uthmani', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _textSimpleMeta =
      const VerificationMeta('textSimple');
  @override
  late final GeneratedColumn<String> textSimple = GeneratedColumn<String>(
      'text_simple', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _textEnMeta = const VerificationMeta('textEn');
  @override
  late final GeneratedColumn<String> textEn = GeneratedColumn<String>(
      'text_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _textKuMeta = const VerificationMeta('textKu');
  @override
  late final GeneratedColumn<String> textKu = GeneratedColumn<String>(
      'text_ku', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        surahId,
        ayahNumber,
        pageNumber,
        juzNumber,
        textUthmani,
        textSimple,
        textEn,
        textKu
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayahs';
  @override
  VerificationContext validateIntegrity(Insertable<Ayah> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_id')) {
      context.handle(_surahIdMeta,
          surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta));
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
          _ayahNumberMeta,
          ayahNumber.isAcceptableOrUnknown(
              data['ayah_number']!, _ayahNumberMeta));
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
          _pageNumberMeta,
          pageNumber.isAcceptableOrUnknown(
              data['page_number']!, _pageNumberMeta));
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('juz_number')) {
      context.handle(_juzNumberMeta,
          juzNumber.isAcceptableOrUnknown(data['juz_number']!, _juzNumberMeta));
    } else if (isInserting) {
      context.missing(_juzNumberMeta);
    }
    if (data.containsKey('text_uthmani')) {
      context.handle(
          _textUthmaniMeta,
          textUthmani.isAcceptableOrUnknown(
              data['text_uthmani']!, _textUthmaniMeta));
    } else if (isInserting) {
      context.missing(_textUthmaniMeta);
    }
    if (data.containsKey('text_simple')) {
      context.handle(
          _textSimpleMeta,
          textSimple.isAcceptableOrUnknown(
              data['text_simple']!, _textSimpleMeta));
    }
    if (data.containsKey('text_en')) {
      context.handle(_textEnMeta,
          textEn.isAcceptableOrUnknown(data['text_en']!, _textEnMeta));
    }
    if (data.containsKey('text_ku')) {
      context.handle(_textKuMeta,
          textKu.isAcceptableOrUnknown(data['text_ku']!, _textKuMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ayah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ayah(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      surahId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_id'])!,
      ayahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ayah_number'])!,
      pageNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_number'])!,
      juzNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}juz_number'])!,
      textUthmani: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_uthmani'])!,
      textSimple: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_simple']),
      textEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_en']),
      textKu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_ku']),
    );
  }

  @override
  $AyahsTable createAlias(String alias) {
    return $AyahsTable(attachedDatabase, alias);
  }
}

class Ayah extends DataClass implements Insertable<Ayah> {
  final int id;
  final int surahId;
  final int ayahNumber;
  final int pageNumber;
  final int juzNumber;
  final String textUthmani;
  final String? textSimple;
  final String? textEn;
  final String? textKu;
  const Ayah(
      {required this.id,
      required this.surahId,
      required this.ayahNumber,
      required this.pageNumber,
      required this.juzNumber,
      required this.textUthmani,
      this.textSimple,
      this.textEn,
      this.textKu});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_id'] = Variable<int>(surahId);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['page_number'] = Variable<int>(pageNumber);
    map['juz_number'] = Variable<int>(juzNumber);
    map['text_uthmani'] = Variable<String>(textUthmani);
    if (!nullToAbsent || textSimple != null) {
      map['text_simple'] = Variable<String>(textSimple);
    }
    if (!nullToAbsent || textEn != null) {
      map['text_en'] = Variable<String>(textEn);
    }
    if (!nullToAbsent || textKu != null) {
      map['text_ku'] = Variable<String>(textKu);
    }
    return map;
  }

  AyahsCompanion toCompanion(bool nullToAbsent) {
    return AyahsCompanion(
      id: Value(id),
      surahId: Value(surahId),
      ayahNumber: Value(ayahNumber),
      pageNumber: Value(pageNumber),
      juzNumber: Value(juzNumber),
      textUthmani: Value(textUthmani),
      textSimple: textSimple == null && nullToAbsent
          ? const Value.absent()
          : Value(textSimple),
      textEn:
          textEn == null && nullToAbsent ? const Value.absent() : Value(textEn),
      textKu:
          textKu == null && nullToAbsent ? const Value.absent() : Value(textKu),
    );
  }

  factory Ayah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ayah(
      id: serializer.fromJson<int>(json['id']),
      surahId: serializer.fromJson<int>(json['surahId']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      juzNumber: serializer.fromJson<int>(json['juzNumber']),
      textUthmani: serializer.fromJson<String>(json['textUthmani']),
      textSimple: serializer.fromJson<String?>(json['textSimple']),
      textEn: serializer.fromJson<String?>(json['textEn']),
      textKu: serializer.fromJson<String?>(json['textKu']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahId': serializer.toJson<int>(surahId),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'juzNumber': serializer.toJson<int>(juzNumber),
      'textUthmani': serializer.toJson<String>(textUthmani),
      'textSimple': serializer.toJson<String?>(textSimple),
      'textEn': serializer.toJson<String?>(textEn),
      'textKu': serializer.toJson<String?>(textKu),
    };
  }

  Ayah copyWith(
          {int? id,
          int? surahId,
          int? ayahNumber,
          int? pageNumber,
          int? juzNumber,
          String? textUthmani,
          Value<String?> textSimple = const Value.absent(),
          Value<String?> textEn = const Value.absent(),
          Value<String?> textKu = const Value.absent()}) =>
      Ayah(
        id: id ?? this.id,
        surahId: surahId ?? this.surahId,
        ayahNumber: ayahNumber ?? this.ayahNumber,
        pageNumber: pageNumber ?? this.pageNumber,
        juzNumber: juzNumber ?? this.juzNumber,
        textUthmani: textUthmani ?? this.textUthmani,
        textSimple: textSimple.present ? textSimple.value : this.textSimple,
        textEn: textEn.present ? textEn.value : this.textEn,
        textKu: textKu.present ? textKu.value : this.textKu,
      );
  Ayah copyWithCompanion(AyahsCompanion data) {
    return Ayah(
      id: data.id.present ? data.id.value : this.id,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      ayahNumber:
          data.ayahNumber.present ? data.ayahNumber.value : this.ayahNumber,
      pageNumber:
          data.pageNumber.present ? data.pageNumber.value : this.pageNumber,
      juzNumber: data.juzNumber.present ? data.juzNumber.value : this.juzNumber,
      textUthmani:
          data.textUthmani.present ? data.textUthmani.value : this.textUthmani,
      textSimple:
          data.textSimple.present ? data.textSimple.value : this.textSimple,
      textEn: data.textEn.present ? data.textEn.value : this.textEn,
      textKu: data.textKu.present ? data.textKu.value : this.textKu,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ayah(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('textSimple: $textSimple, ')
          ..write('textEn: $textEn, ')
          ..write('textKu: $textKu')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahId, ayahNumber, pageNumber,
      juzNumber, textUthmani, textSimple, textEn, textKu);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ayah &&
          other.id == this.id &&
          other.surahId == this.surahId &&
          other.ayahNumber == this.ayahNumber &&
          other.pageNumber == this.pageNumber &&
          other.juzNumber == this.juzNumber &&
          other.textUthmani == this.textUthmani &&
          other.textSimple == this.textSimple &&
          other.textEn == this.textEn &&
          other.textKu == this.textKu);
}

class AyahsCompanion extends UpdateCompanion<Ayah> {
  final Value<int> id;
  final Value<int> surahId;
  final Value<int> ayahNumber;
  final Value<int> pageNumber;
  final Value<int> juzNumber;
  final Value<String> textUthmani;
  final Value<String?> textSimple;
  final Value<String?> textEn;
  final Value<String?> textKu;
  const AyahsCompanion({
    this.id = const Value.absent(),
    this.surahId = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.juzNumber = const Value.absent(),
    this.textUthmani = const Value.absent(),
    this.textSimple = const Value.absent(),
    this.textEn = const Value.absent(),
    this.textKu = const Value.absent(),
  });
  AyahsCompanion.insert({
    this.id = const Value.absent(),
    required int surahId,
    required int ayahNumber,
    required int pageNumber,
    required int juzNumber,
    required String textUthmani,
    this.textSimple = const Value.absent(),
    this.textEn = const Value.absent(),
    this.textKu = const Value.absent(),
  })  : surahId = Value(surahId),
        ayahNumber = Value(ayahNumber),
        pageNumber = Value(pageNumber),
        juzNumber = Value(juzNumber),
        textUthmani = Value(textUthmani);
  static Insertable<Ayah> custom({
    Expression<int>? id,
    Expression<int>? surahId,
    Expression<int>? ayahNumber,
    Expression<int>? pageNumber,
    Expression<int>? juzNumber,
    Expression<String>? textUthmani,
    Expression<String>? textSimple,
    Expression<String>? textEn,
    Expression<String>? textKu,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahId != null) 'surah_id': surahId,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (pageNumber != null) 'page_number': pageNumber,
      if (juzNumber != null) 'juz_number': juzNumber,
      if (textUthmani != null) 'text_uthmani': textUthmani,
      if (textSimple != null) 'text_simple': textSimple,
      if (textEn != null) 'text_en': textEn,
      if (textKu != null) 'text_ku': textKu,
    });
  }

  AyahsCompanion copyWith(
      {Value<int>? id,
      Value<int>? surahId,
      Value<int>? ayahNumber,
      Value<int>? pageNumber,
      Value<int>? juzNumber,
      Value<String>? textUthmani,
      Value<String?>? textSimple,
      Value<String?>? textEn,
      Value<String?>? textKu}) {
    return AyahsCompanion(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      juzNumber: juzNumber ?? this.juzNumber,
      textUthmani: textUthmani ?? this.textUthmani,
      textSimple: textSimple ?? this.textSimple,
      textEn: textEn ?? this.textEn,
      textKu: textKu ?? this.textKu,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (juzNumber.present) {
      map['juz_number'] = Variable<int>(juzNumber.value);
    }
    if (textUthmani.present) {
      map['text_uthmani'] = Variable<String>(textUthmani.value);
    }
    if (textSimple.present) {
      map['text_simple'] = Variable<String>(textSimple.value);
    }
    if (textEn.present) {
      map['text_en'] = Variable<String>(textEn.value);
    }
    if (textKu.present) {
      map['text_ku'] = Variable<String>(textKu.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahsCompanion(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('textSimple: $textSimple, ')
          ..write('textEn: $textEn, ')
          ..write('textKu: $textKu')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ayahIdMeta = const VerificationMeta('ayahId');
  @override
  late final GeneratedColumn<int> ayahId = GeneratedColumn<int>(
      'ayah_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, ayahId, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<Bookmark> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ayah_id')) {
      context.handle(_ayahIdMeta,
          ayahId.isAcceptableOrUnknown(data['ayah_id']!, _ayahIdMeta));
    } else if (isInserting) {
      context.missing(_ayahIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ayahId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ayah_id'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final int id;
  final int ayahId;
  final String? note;
  final DateTime createdAt;
  const Bookmark(
      {required this.id,
      required this.ayahId,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ayah_id'] = Variable<int>(ayahId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      ayahId: Value(ayahId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Bookmark.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      id: serializer.fromJson<int>(json['id']),
      ayahId: serializer.fromJson<int>(json['ayahId']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ayahId': serializer.toJson<int>(ayahId),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Bookmark copyWith(
          {int? id,
          int? ayahId,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      Bookmark(
        id: id ?? this.id,
        ayahId: ayahId ?? this.ayahId,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      id: data.id.present ? data.id.value : this.id,
      ayahId: data.ayahId.present ? data.ayahId.value : this.ayahId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('id: $id, ')
          ..write('ayahId: $ayahId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ayahId, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.id == this.id &&
          other.ayahId == this.ayahId &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<int> id;
  final Value<int> ayahId;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.ayahId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    required int ayahId,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : ayahId = Value(ayahId);
  static Insertable<Bookmark> custom({
    Expression<int>? id,
    Expression<int>? ayahId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ayahId != null) 'ayah_id': ayahId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BookmarksCompanion copyWith(
      {Value<int>? id,
      Value<int>? ayahId,
      Value<String?>? note,
      Value<DateTime>? createdAt}) {
    return BookmarksCompanion(
      id: id ?? this.id,
      ayahId: ayahId ?? this.ayahId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ayahId.present) {
      map['ayah_id'] = Variable<int>(ayahId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('ayahId: $ayahId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TasbihLogsTable extends TasbihLogs
    with TableInfo<$TasbihLogsTable, TasbihLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasbihLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dhikrMeta = const VerificationMeta('dhikr');
  @override
  late final GeneratedColumn<String> dhikr = GeneratedColumn<String>(
      'dhikr', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, date, count, dhikr];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasbih_logs';
  @override
  VerificationContext validateIntegrity(Insertable<TasbihLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('dhikr')) {
      context.handle(
          _dhikrMeta, dhikr.isAcceptableOrUnknown(data['dhikr']!, _dhikrMeta));
    } else if (isInserting) {
      context.missing(_dhikrMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasbihLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasbihLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      dhikr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dhikr'])!,
    );
  }

  @override
  $TasbihLogsTable createAlias(String alias) {
    return $TasbihLogsTable(attachedDatabase, alias);
  }
}

class TasbihLog extends DataClass implements Insertable<TasbihLog> {
  final int id;
  final String date;
  final int count;
  final String dhikr;
  const TasbihLog(
      {required this.id,
      required this.date,
      required this.count,
      required this.dhikr});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['count'] = Variable<int>(count);
    map['dhikr'] = Variable<String>(dhikr);
    return map;
  }

  TasbihLogsCompanion toCompanion(bool nullToAbsent) {
    return TasbihLogsCompanion(
      id: Value(id),
      date: Value(date),
      count: Value(count),
      dhikr: Value(dhikr),
    );
  }

  factory TasbihLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasbihLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      count: serializer.fromJson<int>(json['count']),
      dhikr: serializer.fromJson<String>(json['dhikr']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'count': serializer.toJson<int>(count),
      'dhikr': serializer.toJson<String>(dhikr),
    };
  }

  TasbihLog copyWith({int? id, String? date, int? count, String? dhikr}) =>
      TasbihLog(
        id: id ?? this.id,
        date: date ?? this.date,
        count: count ?? this.count,
        dhikr: dhikr ?? this.dhikr,
      );
  TasbihLog copyWithCompanion(TasbihLogsCompanion data) {
    return TasbihLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      count: data.count.present ? data.count.value : this.count,
      dhikr: data.dhikr.present ? data.dhikr.value : this.dhikr,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasbihLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('dhikr: $dhikr')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, count, dhikr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasbihLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.count == this.count &&
          other.dhikr == this.dhikr);
}

class TasbihLogsCompanion extends UpdateCompanion<TasbihLog> {
  final Value<int> id;
  final Value<String> date;
  final Value<int> count;
  final Value<String> dhikr;
  const TasbihLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.count = const Value.absent(),
    this.dhikr = const Value.absent(),
  });
  TasbihLogsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int count,
    required String dhikr,
  })  : date = Value(date),
        count = Value(count),
        dhikr = Value(dhikr);
  static Insertable<TasbihLog> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? count,
    Expression<String>? dhikr,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (count != null) 'count': count,
      if (dhikr != null) 'dhikr': dhikr,
    });
  }

  TasbihLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<int>? count,
      Value<String>? dhikr}) {
    return TasbihLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      count: count ?? this.count,
      dhikr: dhikr ?? this.dhikr,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (dhikr.present) {
      map['dhikr'] = Variable<String>(dhikr.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasbihLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('dhikr: $dhikr')
          ..write(')'))
        .toString();
  }
}

class $DhikrsTable extends Dhikrs with TableInfo<$DhikrsTable, Dhikr> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DhikrsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _arabicMeta = const VerificationMeta('arabic');
  @override
  late final GeneratedColumn<String> arabic = GeneratedColumn<String>(
      'arabic', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
      'target', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, arabic, target, count, isSystem];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dhikrs';
  @override
  VerificationContext validateIntegrity(Insertable<Dhikr> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('arabic')) {
      context.handle(_arabicMeta,
          arabic.isAcceptableOrUnknown(data['arabic']!, _arabicMeta));
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta,
          target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dhikr map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dhikr(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      arabic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arabic']),
      target: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
    );
  }

  @override
  $DhikrsTable createAlias(String alias) {
    return $DhikrsTable(attachedDatabase, alias);
  }
}

class Dhikr extends DataClass implements Insertable<Dhikr> {
  final int id;
  final String name;
  final String? arabic;
  final int target;
  final int count;
  final bool isSystem;
  const Dhikr(
      {required this.id,
      required this.name,
      this.arabic,
      required this.target,
      required this.count,
      required this.isSystem});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || arabic != null) {
      map['arabic'] = Variable<String>(arabic);
    }
    map['target'] = Variable<int>(target);
    map['count'] = Variable<int>(count);
    map['is_system'] = Variable<bool>(isSystem);
    return map;
  }

  DhikrsCompanion toCompanion(bool nullToAbsent) {
    return DhikrsCompanion(
      id: Value(id),
      name: Value(name),
      arabic:
          arabic == null && nullToAbsent ? const Value.absent() : Value(arabic),
      target: Value(target),
      count: Value(count),
      isSystem: Value(isSystem),
    );
  }

  factory Dhikr.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dhikr(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      arabic: serializer.fromJson<String?>(json['arabic']),
      target: serializer.fromJson<int>(json['target']),
      count: serializer.fromJson<int>(json['count']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'arabic': serializer.toJson<String?>(arabic),
      'target': serializer.toJson<int>(target),
      'count': serializer.toJson<int>(count),
      'isSystem': serializer.toJson<bool>(isSystem),
    };
  }

  Dhikr copyWith(
          {int? id,
          String? name,
          Value<String?> arabic = const Value.absent(),
          int? target,
          int? count,
          bool? isSystem}) =>
      Dhikr(
        id: id ?? this.id,
        name: name ?? this.name,
        arabic: arabic.present ? arabic.value : this.arabic,
        target: target ?? this.target,
        count: count ?? this.count,
        isSystem: isSystem ?? this.isSystem,
      );
  Dhikr copyWithCompanion(DhikrsCompanion data) {
    return Dhikr(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      arabic: data.arabic.present ? data.arabic.value : this.arabic,
      target: data.target.present ? data.target.value : this.target,
      count: data.count.present ? data.count.value : this.count,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dhikr(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('arabic: $arabic, ')
          ..write('target: $target, ')
          ..write('count: $count, ')
          ..write('isSystem: $isSystem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, arabic, target, count, isSystem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dhikr &&
          other.id == this.id &&
          other.name == this.name &&
          other.arabic == this.arabic &&
          other.target == this.target &&
          other.count == this.count &&
          other.isSystem == this.isSystem);
}

class DhikrsCompanion extends UpdateCompanion<Dhikr> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> arabic;
  final Value<int> target;
  final Value<int> count;
  final Value<bool> isSystem;
  const DhikrsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.arabic = const Value.absent(),
    this.target = const Value.absent(),
    this.count = const Value.absent(),
    this.isSystem = const Value.absent(),
  });
  DhikrsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.arabic = const Value.absent(),
    required int target,
    this.count = const Value.absent(),
    this.isSystem = const Value.absent(),
  })  : name = Value(name),
        target = Value(target);
  static Insertable<Dhikr> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? arabic,
    Expression<int>? target,
    Expression<int>? count,
    Expression<bool>? isSystem,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (arabic != null) 'arabic': arabic,
      if (target != null) 'target': target,
      if (count != null) 'count': count,
      if (isSystem != null) 'is_system': isSystem,
    });
  }

  DhikrsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? arabic,
      Value<int>? target,
      Value<int>? count,
      Value<bool>? isSystem}) {
    return DhikrsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      arabic: arabic ?? this.arabic,
      target: target ?? this.target,
      count: count ?? this.count,
      isSystem: isSystem ?? this.isSystem,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (arabic.present) {
      map['arabic'] = Variable<String>(arabic.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DhikrsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('arabic: $arabic, ')
          ..write('target: $target, ')
          ..write('count: $count, ')
          ..write('isSystem: $isSystem')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $AyahsTable ayahs = $AyahsTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $TasbihLogsTable tasbihLogs = $TasbihLogsTable(this);
  late final $DhikrsTable dhikrs = $DhikrsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [surahs, ayahs, bookmarks, tasbihLogs, dhikrs];
}

typedef $$SurahsTableCreateCompanionBuilder = SurahsCompanion Function({
  Value<int> id,
  required int number,
  required String nameAr,
  required String nameEn,
  Value<String?> nameKu,
  required int totalAyahs,
  required String revelationType,
});
typedef $$SurahsTableUpdateCompanionBuilder = SurahsCompanion Function({
  Value<int> id,
  Value<int> number,
  Value<String> nameAr,
  Value<String> nameEn,
  Value<String?> nameKu,
  Value<int> totalAyahs,
  Value<String> revelationType,
});

class $$SurahsTableFilterComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameKu => $composableBuilder(
      column: $table.nameKu, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalAyahs => $composableBuilder(
      column: $table.totalAyahs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get revelationType => $composableBuilder(
      column: $table.revelationType,
      builder: (column) => ColumnFilters(column));
}

class $$SurahsTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameKu => $composableBuilder(
      column: $table.nameKu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalAyahs => $composableBuilder(
      column: $table.totalAyahs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get revelationType => $composableBuilder(
      column: $table.revelationType,
      builder: (column) => ColumnOrderings(column));
}

class $$SurahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameKu =>
      $composableBuilder(column: $table.nameKu, builder: (column) => column);

  GeneratedColumn<int> get totalAyahs => $composableBuilder(
      column: $table.totalAyahs, builder: (column) => column);

  GeneratedColumn<String> get revelationType => $composableBuilder(
      column: $table.revelationType, builder: (column) => column);
}

class $$SurahsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SurahsTable,
    Surah,
    $$SurahsTableFilterComposer,
    $$SurahsTableOrderingComposer,
    $$SurahsTableAnnotationComposer,
    $$SurahsTableCreateCompanionBuilder,
    $$SurahsTableUpdateCompanionBuilder,
    (Surah, BaseReferences<_$AppDatabase, $SurahsTable, Surah>),
    Surah,
    PrefetchHooks Function()> {
  $$SurahsTableTableManager(_$AppDatabase db, $SurahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> number = const Value.absent(),
            Value<String> nameAr = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> nameKu = const Value.absent(),
            Value<int> totalAyahs = const Value.absent(),
            Value<String> revelationType = const Value.absent(),
          }) =>
              SurahsCompanion(
            id: id,
            number: number,
            nameAr: nameAr,
            nameEn: nameEn,
            nameKu: nameKu,
            totalAyahs: totalAyahs,
            revelationType: revelationType,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int number,
            required String nameAr,
            required String nameEn,
            Value<String?> nameKu = const Value.absent(),
            required int totalAyahs,
            required String revelationType,
          }) =>
              SurahsCompanion.insert(
            id: id,
            number: number,
            nameAr: nameAr,
            nameEn: nameEn,
            nameKu: nameKu,
            totalAyahs: totalAyahs,
            revelationType: revelationType,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SurahsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SurahsTable,
    Surah,
    $$SurahsTableFilterComposer,
    $$SurahsTableOrderingComposer,
    $$SurahsTableAnnotationComposer,
    $$SurahsTableCreateCompanionBuilder,
    $$SurahsTableUpdateCompanionBuilder,
    (Surah, BaseReferences<_$AppDatabase, $SurahsTable, Surah>),
    Surah,
    PrefetchHooks Function()>;
typedef $$AyahsTableCreateCompanionBuilder = AyahsCompanion Function({
  Value<int> id,
  required int surahId,
  required int ayahNumber,
  required int pageNumber,
  required int juzNumber,
  required String textUthmani,
  Value<String?> textSimple,
  Value<String?> textEn,
  Value<String?> textKu,
});
typedef $$AyahsTableUpdateCompanionBuilder = AyahsCompanion Function({
  Value<int> id,
  Value<int> surahId,
  Value<int> ayahNumber,
  Value<int> pageNumber,
  Value<int> juzNumber,
  Value<String> textUthmani,
  Value<String?> textSimple,
  Value<String?> textEn,
  Value<String?> textKu,
});

class $$AyahsTableFilterComposer extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get surahId => $composableBuilder(
      column: $table.surahId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ayahNumber => $composableBuilder(
      column: $table.ayahNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pageNumber => $composableBuilder(
      column: $table.pageNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get juzNumber => $composableBuilder(
      column: $table.juzNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textUthmani => $composableBuilder(
      column: $table.textUthmani, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textSimple => $composableBuilder(
      column: $table.textSimple, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textEn => $composableBuilder(
      column: $table.textEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textKu => $composableBuilder(
      column: $table.textKu, builder: (column) => ColumnFilters(column));
}

class $$AyahsTableOrderingComposer
    extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get surahId => $composableBuilder(
      column: $table.surahId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
      column: $table.ayahNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pageNumber => $composableBuilder(
      column: $table.pageNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get juzNumber => $composableBuilder(
      column: $table.juzNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textUthmani => $composableBuilder(
      column: $table.textUthmani, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textSimple => $composableBuilder(
      column: $table.textSimple, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textEn => $composableBuilder(
      column: $table.textEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textKu => $composableBuilder(
      column: $table.textKu, builder: (column) => ColumnOrderings(column));
}

class $$AyahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahId =>
      $composableBuilder(column: $table.surahId, builder: (column) => column);

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
      column: $table.ayahNumber, builder: (column) => column);

  GeneratedColumn<int> get pageNumber => $composableBuilder(
      column: $table.pageNumber, builder: (column) => column);

  GeneratedColumn<int> get juzNumber =>
      $composableBuilder(column: $table.juzNumber, builder: (column) => column);

  GeneratedColumn<String> get textUthmani => $composableBuilder(
      column: $table.textUthmani, builder: (column) => column);

  GeneratedColumn<String> get textSimple => $composableBuilder(
      column: $table.textSimple, builder: (column) => column);

  GeneratedColumn<String> get textEn =>
      $composableBuilder(column: $table.textEn, builder: (column) => column);

  GeneratedColumn<String> get textKu =>
      $composableBuilder(column: $table.textKu, builder: (column) => column);
}

class $$AyahsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AyahsTable,
    Ayah,
    $$AyahsTableFilterComposer,
    $$AyahsTableOrderingComposer,
    $$AyahsTableAnnotationComposer,
    $$AyahsTableCreateCompanionBuilder,
    $$AyahsTableUpdateCompanionBuilder,
    (Ayah, BaseReferences<_$AppDatabase, $AyahsTable, Ayah>),
    Ayah,
    PrefetchHooks Function()> {
  $$AyahsTableTableManager(_$AppDatabase db, $AyahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AyahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AyahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AyahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> surahId = const Value.absent(),
            Value<int> ayahNumber = const Value.absent(),
            Value<int> pageNumber = const Value.absent(),
            Value<int> juzNumber = const Value.absent(),
            Value<String> textUthmani = const Value.absent(),
            Value<String?> textSimple = const Value.absent(),
            Value<String?> textEn = const Value.absent(),
            Value<String?> textKu = const Value.absent(),
          }) =>
              AyahsCompanion(
            id: id,
            surahId: surahId,
            ayahNumber: ayahNumber,
            pageNumber: pageNumber,
            juzNumber: juzNumber,
            textUthmani: textUthmani,
            textSimple: textSimple,
            textEn: textEn,
            textKu: textKu,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int surahId,
            required int ayahNumber,
            required int pageNumber,
            required int juzNumber,
            required String textUthmani,
            Value<String?> textSimple = const Value.absent(),
            Value<String?> textEn = const Value.absent(),
            Value<String?> textKu = const Value.absent(),
          }) =>
              AyahsCompanion.insert(
            id: id,
            surahId: surahId,
            ayahNumber: ayahNumber,
            pageNumber: pageNumber,
            juzNumber: juzNumber,
            textUthmani: textUthmani,
            textSimple: textSimple,
            textEn: textEn,
            textKu: textKu,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AyahsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AyahsTable,
    Ayah,
    $$AyahsTableFilterComposer,
    $$AyahsTableOrderingComposer,
    $$AyahsTableAnnotationComposer,
    $$AyahsTableCreateCompanionBuilder,
    $$AyahsTableUpdateCompanionBuilder,
    (Ayah, BaseReferences<_$AppDatabase, $AyahsTable, Ayah>),
    Ayah,
    PrefetchHooks Function()>;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  Value<int> id,
  required int ayahId,
  Value<String?> note,
  Value<DateTime> createdAt,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<int> id,
  Value<int> ayahId,
  Value<String?> note,
  Value<DateTime> createdAt,
});

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ayahId => $composableBuilder(
      column: $table.ayahId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ayahId => $composableBuilder(
      column: $table.ayahId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ayahId =>
      $composableBuilder(column: $table.ayahId, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BookmarksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
    Bookmark,
    PrefetchHooks Function()> {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> ayahId = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BookmarksCompanion(
            id: id,
            ayahId: ayahId,
            note: note,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int ayahId,
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BookmarksCompanion.insert(
            id: id,
            ayahId: ayahId,
            note: note,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BookmarksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
    Bookmark,
    PrefetchHooks Function()>;
typedef $$TasbihLogsTableCreateCompanionBuilder = TasbihLogsCompanion Function({
  Value<int> id,
  required String date,
  required int count,
  required String dhikr,
});
typedef $$TasbihLogsTableUpdateCompanionBuilder = TasbihLogsCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<int> count,
  Value<String> dhikr,
});

class $$TasbihLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TasbihLogsTable> {
  $$TasbihLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dhikr => $composableBuilder(
      column: $table.dhikr, builder: (column) => ColumnFilters(column));
}

class $$TasbihLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TasbihLogsTable> {
  $$TasbihLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dhikr => $composableBuilder(
      column: $table.dhikr, builder: (column) => ColumnOrderings(column));
}

class $$TasbihLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasbihLogsTable> {
  $$TasbihLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<String> get dhikr =>
      $composableBuilder(column: $table.dhikr, builder: (column) => column);
}

class $$TasbihLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasbihLogsTable,
    TasbihLog,
    $$TasbihLogsTableFilterComposer,
    $$TasbihLogsTableOrderingComposer,
    $$TasbihLogsTableAnnotationComposer,
    $$TasbihLogsTableCreateCompanionBuilder,
    $$TasbihLogsTableUpdateCompanionBuilder,
    (TasbihLog, BaseReferences<_$AppDatabase, $TasbihLogsTable, TasbihLog>),
    TasbihLog,
    PrefetchHooks Function()> {
  $$TasbihLogsTableTableManager(_$AppDatabase db, $TasbihLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasbihLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasbihLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasbihLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<String> dhikr = const Value.absent(),
          }) =>
              TasbihLogsCompanion(
            id: id,
            date: date,
            count: count,
            dhikr: dhikr,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            required int count,
            required String dhikr,
          }) =>
              TasbihLogsCompanion.insert(
            id: id,
            date: date,
            count: count,
            dhikr: dhikr,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasbihLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasbihLogsTable,
    TasbihLog,
    $$TasbihLogsTableFilterComposer,
    $$TasbihLogsTableOrderingComposer,
    $$TasbihLogsTableAnnotationComposer,
    $$TasbihLogsTableCreateCompanionBuilder,
    $$TasbihLogsTableUpdateCompanionBuilder,
    (TasbihLog, BaseReferences<_$AppDatabase, $TasbihLogsTable, TasbihLog>),
    TasbihLog,
    PrefetchHooks Function()>;
typedef $$DhikrsTableCreateCompanionBuilder = DhikrsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> arabic,
  required int target,
  Value<int> count,
  Value<bool> isSystem,
});
typedef $$DhikrsTableUpdateCompanionBuilder = DhikrsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> arabic,
  Value<int> target,
  Value<int> count,
  Value<bool> isSystem,
});

class $$DhikrsTableFilterComposer
    extends Composer<_$AppDatabase, $DhikrsTable> {
  $$DhikrsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get arabic => $composableBuilder(
      column: $table.arabic, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get target => $composableBuilder(
      column: $table.target, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnFilters(column));
}

class $$DhikrsTableOrderingComposer
    extends Composer<_$AppDatabase, $DhikrsTable> {
  $$DhikrsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get arabic => $composableBuilder(
      column: $table.arabic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get target => $composableBuilder(
      column: $table.target, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSystem => $composableBuilder(
      column: $table.isSystem, builder: (column) => ColumnOrderings(column));
}

class $$DhikrsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DhikrsTable> {
  $$DhikrsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get arabic =>
      $composableBuilder(column: $table.arabic, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);
}

class $$DhikrsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DhikrsTable,
    Dhikr,
    $$DhikrsTableFilterComposer,
    $$DhikrsTableOrderingComposer,
    $$DhikrsTableAnnotationComposer,
    $$DhikrsTableCreateCompanionBuilder,
    $$DhikrsTableUpdateCompanionBuilder,
    (Dhikr, BaseReferences<_$AppDatabase, $DhikrsTable, Dhikr>),
    Dhikr,
    PrefetchHooks Function()> {
  $$DhikrsTableTableManager(_$AppDatabase db, $DhikrsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DhikrsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DhikrsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DhikrsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> arabic = const Value.absent(),
            Value<int> target = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
          }) =>
              DhikrsCompanion(
            id: id,
            name: name,
            arabic: arabic,
            target: target,
            count: count,
            isSystem: isSystem,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> arabic = const Value.absent(),
            required int target,
            Value<int> count = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
          }) =>
              DhikrsCompanion.insert(
            id: id,
            name: name,
            arabic: arabic,
            target: target,
            count: count,
            isSystem: isSystem,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DhikrsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DhikrsTable,
    Dhikr,
    $$DhikrsTableFilterComposer,
    $$DhikrsTableOrderingComposer,
    $$DhikrsTableAnnotationComposer,
    $$DhikrsTableCreateCompanionBuilder,
    $$DhikrsTableUpdateCompanionBuilder,
    (Dhikr, BaseReferences<_$AppDatabase, $DhikrsTable, Dhikr>),
    Dhikr,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$AyahsTableTableManager get ayahs =>
      $$AyahsTableTableManager(_db, _db.ayahs);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$TasbihLogsTableTableManager get tasbihLogs =>
      $$TasbihLogsTableTableManager(_db, _db.tasbihLogs);
  $$DhikrsTableTableManager get dhikrs =>
      $$DhikrsTableTableManager(_db, _db.dhikrs);
}
