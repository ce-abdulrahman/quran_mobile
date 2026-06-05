class TajweedSegmentModel {
  final String textSegment;
  final int? startIndex;
  final int? endIndex;
  final String? note;
  final String? ruleName;
  final String? ruleNameKu;
  final String? ruleNameAr;
  final String? colorCode;

  const TajweedSegmentModel({
    required this.textSegment,
    this.startIndex,
    this.endIndex,
    this.note,
    this.ruleName,
    this.ruleNameKu,
    this.ruleNameAr,
    this.colorCode,
  });

  factory TajweedSegmentModel.fromJson(Map<String, dynamic> json) {
    final rule = json['rule'] as Map<String, dynamic>? ?? {};
    return TajweedSegmentModel(
      textSegment: json['text_segment'] as String? ?? '',
      startIndex: json['start_index'] as int?,
      endIndex: json['end_index'] as int?,
      note: json['note'] as String?,
      ruleName: rule['name'] as String?,
      ruleNameKu: rule['name_ku'] as String?,
      ruleNameAr: rule['name_ar'] as String?,
      colorCode: rule['color_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text_segment': textSegment,
      'start_index': startIndex,
      'end_index': endIndex,
      'note': note,
      'rule': {
        'name': ruleName,
        'name_ku': ruleNameKu,
        'name_ar': ruleNameAr,
        'color_code': colorCode,
      },
    };
  }
}
