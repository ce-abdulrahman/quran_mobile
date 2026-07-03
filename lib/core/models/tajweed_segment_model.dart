class TajweedSegmentModel {
  final String textSegment;
  final int? startIndex;
  final int? endIndex;
  final String? note;
  final String? ruleName;
  final String? ruleNameKu;
  final String? ruleNameAr;
  final String? colorCode;
  final String? ruleSlug;
  final int? ruleId;
  final int? colorId;
  final bool? connectsToLeft;
  final bool? connectsToRight;

  const TajweedSegmentModel({
    required this.textSegment,
    this.startIndex,
    this.endIndex,
    this.note,
    this.ruleName,
    this.ruleNameKu,
    this.ruleNameAr,
    this.colorCode,
    this.ruleSlug,
    this.ruleId,
    this.colorId,
    this.connectsToLeft,
    this.connectsToRight,
  });

  factory TajweedSegmentModel.fromJson(Map<String, dynamic> json) {
    // Laravel eager loads as 'tajweed_rule', but allow 'rule' as fallback
    final rule = (json['tajweed_rule'] ?? json['rule']) as Map<String, dynamic>? ?? {};
    return TajweedSegmentModel(
      textSegment: json['text_segment'] as String? ?? '',
      startIndex: json['start_index'] as int?,
      endIndex: json['end_index'] as int?,
      note: json['note'] as String?,
      ruleName: rule['name'] as String?,
      ruleNameKu: rule['name_ku'] as String?,
      ruleNameAr: rule['name_ar'] as String?,
      colorCode: rule['color_code'] as String? ?? json['color_code'] as String?,
      ruleSlug: rule['slug'] as String? ?? json['rule_slug'] as String?,
      ruleId: json['rule_id'] as int? ?? rule['id'] as int?,
      colorId: json['color_id'] as int?,
      connectsToLeft: json['connects_to_left'] as bool?,
      connectsToRight: json['connects_to_right'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text_segment': textSegment,
      'start_index': startIndex,
      'end_index': endIndex,
      'note': note,
      'rule_id': ruleId,
      'color_id': colorId,
      'connects_to_left': connectsToLeft,
      'connects_to_right': connectsToRight,
      'rule': {
        'slug': ruleSlug,
        'name': ruleName,
        'name_ku': ruleNameKu,
        'name_ar': ruleNameAr,
        'color_code': colorCode,
      },
    };
  }
}
