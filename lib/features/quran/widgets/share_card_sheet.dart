import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/ayah_model.dart';
import '../../../core/providers/favorites_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Share Ayah Data Model
// ─────────────────────────────────────────────────────────────────────────────

class ShareAyahData {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final String textUthmani;
  final String? textKu;
  final String? textEn;

  ShareAyahData({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.textUthmani,
    this.textKu,
    this.textEn,
  });

  factory ShareAyahData.fromAyahModel(AyahModel ayah, String fallbackSurahName) {
    return ShareAyahData(
      surahId: ayah.surah?.id ?? 0,
      surahName: ayah.surah?.nameEn ?? fallbackSurahName,
      ayahNumber: ayah.ayahNumber,
      textUthmani: ayah.textUthmani,
      textKu: ayah.textKu,
      textEn: ayah.textEn,
    );
  }

  factory ShareAyahData.fromLocalFavorite(LocalFavorite favorite) {
    return ShareAyahData(
      surahId: favorite.surahId,
      surahName: favorite.surahName,
      ayahNumber: favorite.ayahNumber,
      textUthmani: favorite.textUthmani,
      textKu: favorite.textKu,
      textEn: favorite.textEn,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Sheet Entry Point
// ─────────────────────────────────────────────────────────────────────────────

void showShareCardSheet(BuildContext context, ShareAyahData data) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ShareCardSheet(data: data),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Share Card Sheet Widget
// ─────────────────────────────────────────────────────────────────────────────

class ShareCardSheet extends StatefulWidget {
  final ShareAyahData data;
  const ShareCardSheet({super.key, required this.data});

  @override
  State<ShareCardSheet> createState() => _ShareCardSheetState();
}

class _ShareCardSheetState extends State<ShareCardSheet> {
  final GlobalKey _boundaryKey = GlobalKey();
  int _selectedBgIndex = 0;
  bool _showKurdish = true;
  bool _showEnglish = false;
  bool _isSharing = false;

  String _selectedArabicFont = 'AmiriQuran';
  String _selectedKurdishFont = 'Cairo';
  String _selectedEnglishFont = 'Cairo';

  // Font mappings with friendly names and fontFamily values
  static const List<Map<String, String>> _arabicFonts = [
    {'name': 'Amiri Quran (Default)', 'family': 'AmiriQuran'},
    {'name': 'Scheherazade New', 'family': 'ScheherazadeNew'},
    {'name': 'Lateef', 'family': 'Lateef'},
    {'name': 'Noto Naskh Arabic', 'family': 'NotoNaskhArabic'},
    {'name': 'IBMPlexSansArabic', 'family': 'IBMPlexSansArabic'},
  ];

  static const List<Map<String, String>> _kurdishFonts = [
    {'name': 'Cairo (Default)', 'family': 'Cairo'},
    {'name': 'Nizar Nastaliq', 'family': 'NizarNastaliq'},
    {'name': 'UniQAIDAR', 'family': 'UniQAIDAR'},
    {'name': 'NRT Bd', 'family': 'NRTBd'},
    {'name': 'Normal Ganel', 'family': 'NormalGanel'},
    {'name': 'Sarchia Qaisy', 'family': 'SarchiaQaisy'},
    {'name': 'Sarchia Makka', 'family': 'SarchiaMakka'},
    {'name': 'Rudaw Bold', 'family': 'RudawBold'},
  ];

  static const List<Map<String, String>> _englishFonts = [
    {'name': 'Cairo (Default)', 'family': 'Cairo'},
    {'name': 'Patua One', 'family': 'Patua One'},
  ];

  // Premium Background Templates
  final List<Map<String, dynamic>> _bgTemplates = [
    {
      'name': 'زمردی ئیسلامی', // Emerald Gradient
      'isDark': true,
      'gradient': const LinearGradient(
        colors: [Color(0xFF0F3A20), Color(0xFF1B6A3B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'textColor': Colors.white,
      'translationColor': const Color(0xFFE2E8F0),
      'accentColor': const Color(0xFF1AB66D),
    },
    {
      'name': 'مۆڕی شاهانە', // Royal Purple
      'isDark': true,
      'gradient': const LinearGradient(
        colors: [Color(0xFF2E0854), Color(0xFF6B1D9B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'textColor': Colors.white,
      'translationColor': const Color(0xFFF3E8FF),
      'accentColor': const Color(0xFFC084FC),
    },
    {
      'name': 'شینی کانی', // Lapis Blue
      'isDark': true,
      'gradient': const LinearGradient(
        colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'textColor': Colors.white,
      'translationColor': const Color(0xFFE2E8F0),
      'accentColor': const Color(0xFF60A5FA),
    },
    {
      'name': 'پەڕەیی کلاسیک', // Classic Cream Manuscript
      'isDark': false,
      'color': const Color(0xFFFCF8F2),
      'textColor': const Color(0xFF2C1802),
      'translationColor': const Color(0xFF5E4E3D),
      'accentColor': const Color(0xFFCD9D27),
      'borderColor': const Color(0xFFE2C999),
    },
  ];

  Future<void> _shareImage(AppLocalizations l) async {
    setState(() => _isSharing = true);
    await Future.delayed(const Duration(milliseconds: 150));

    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception("Could not find repaint boundary");

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) throw Exception("Failed to convert image to bytes");

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/share_ayah_${widget.data.surahId}_${widget.data.ayahNumber}.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      if (mounted) {
        final shareText = '${widget.data.textUthmani}\n\n'
            '${_showKurdish && widget.data.textKu != null ? '${widget.data.textKu}\n\n' : ''}'
            '(${widget.data.surahName} : ${widget.data.ayahNumber})';

        await Share.shareXFiles(
          [XFile(filePath)],
          text: shareText,
        );
      }
    } catch (e) {
      debugPrint("Error sharing image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('کێشەیەک ڕوویدا لە دروستکردنی وێنەکە: $e', style: const TextStyle(fontFamily: 'Cairo')),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  void _copyText(AppLocalizations l) {
    final textList = [
      widget.data.textUthmani,
      if (_showKurdish && widget.data.textKu != null) widget.data.textKu!,
      if (_showEnglish && widget.data.textEn != null) widget.data.textEn!,
      '(${widget.data.surahName} : ${widget.data.ayahNumber})'
    ];
    Clipboard.setData(ClipboardData(text: textList.join('\n\n')));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.shareCopiedText, style: const TextStyle(fontFamily: 'Cairo')),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildToggleRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppColorScheme cs,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: cs.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: cs.primary,
          activeTrackColor: cs.primary.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;

    final template = _bgTemplates[_selectedBgIndex];
    final Color textColor = template['textColor'] as Color;
    final Color translationColor = template['translationColor'] as Color;
    final Color accentColor = template['accentColor'] as Color;

    final cardDecoration = template.containsKey('gradient')
        ? BoxDecoration(
            gradient: template['gradient'] as Gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          )
        : BoxDecoration(
            color: template['color'] as Color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: template['borderColor'] as Color, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          );

    return Container(
      decoration: BoxDecoration(
        color: cs.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Top Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                  color: cs.textSecondary,
                ),
                Text(
                  l.shareCardTitle,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(width: 40), // spacer for alignment
              ],
            ),
            const SizedBox(height: 20),

            // ── Card Preview (RepaintBoundary) ──────────────────────
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: RepaintBoundary(
                  key: _boundaryKey,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: cardDecoration,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Decorative Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_border_purple500_rounded, color: accentColor, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'قورئانی پیرۆز',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.star_border_purple500_rounded, color: accentColor, size: 18),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Arabic Text
                        Text(
                          widget.data.textUthmani,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: _selectedArabicFont,
                            fontSize: 22,
                            height: 1.9,
                            color: textColor,
                          ),
                        ),

                        // Kurdish Translation
                        if (_showKurdish && widget.data.textKu != null && widget.data.textKu!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            widget.data.textKu!,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: _selectedKurdishFont,
                              fontSize: 13.5,
                              height: 1.6,
                              color: translationColor,
                            ),
                          ),
                        ],

                        // English Translation
                        if (_showEnglish && widget.data.textEn != null && widget.data.textEn!.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Text(
                            widget.data.textEn!,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: _selectedEnglishFont,
                              fontSize: 12.5,
                              height: 1.5,
                              color: translationColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Footer Surah Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: textColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
                          ),
                          child: Text(
                            '${widget.data.surahName} : ${widget.data.ayahNumber}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // App watermark branding
                        Text(
                          'قورئانەکەم - My Quran',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: accentColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Background Customizer ─────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.shareSelectBg,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: cs.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_bgTemplates.length, (i) {
                    final temp = _bgTemplates[i];
                    final active = i == _selectedBgIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedBgIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: active ? cs.primary : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: temp.containsKey('gradient') ? (temp['gradient'] as Gradient) : null,
                              color: temp.containsKey('color') ? (temp['color'] as Color) : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Toggle Options ────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.cardBorder),
              ),
              child: Column(
                children: [
                  if (widget.data.textKu != null) ...[
                    _buildToggleRow(
                      label: l.shareTranslateKu,
                      value: _showKurdish,
                      onChanged: (val) => setState(() => _showKurdish = val),
                      cs: cs,
                    ),
                  ],
                  if (widget.data.textEn != null) ...[
                    if (widget.data.textKu != null) Divider(color: cs.divider),
                    _buildToggleRow(
                      label: l.shareTranslateEn,
                      value: _showEnglish,
                      onChanged: (val) => setState(() => _showEnglish = val),
                      cs: cs,
                    ),
                  ],
                ],
              ),
            ),

            // ── Font Customizer ──────────────────────────────────
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'هەڵبژاردنی فۆنتی زمانەکان',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: cs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Arabic Font Dropdown (Always shown)
                  _buildFontDropdownRow(
                    label: 'فۆنتی عەرەبی (ئایەت)',
                    value: _selectedArabicFont,
                    items: _arabicFonts,
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedArabicFont = val);
                    },
                    cs: cs,
                  ),

                  // Kurdish Font Dropdown (Shown if Kurdish is active)
                  if (_showKurdish && widget.data.textKu != null && widget.data.textKu!.isNotEmpty) ...[
                    Divider(color: cs.divider, height: 20),
                    _buildFontDropdownRow(
                      label: 'فۆنتی کوردی (تەفسیر)',
                      value: _selectedKurdishFont,
                      items: _kurdishFonts,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedKurdishFont = val);
                      },
                      cs: cs,
                    ),
                  ],

                  // English Font Dropdown (Shown if English is active)
                  if (_showEnglish && widget.data.textEn != null && widget.data.textEn!.isNotEmpty) ...[
                    Divider(color: cs.divider, height: 20),
                    _buildFontDropdownRow(
                      label: 'فۆنتی ئینگلیزی (تەفسیر)',
                      value: _selectedEnglishFont,
                      items: _englishFonts,
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedEnglishFont = val);
                      },
                      cs: cs,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Share Actions ─────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSharing ? null : () => _shareImage(l),
                    icon: _isSharing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.share_rounded, size: 18, color: Colors.white),
                    label: Text(
                      _isSharing ? l.shareGeneratingImage : l.shareAsImage,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: cs.cardBorder),
                    borderRadius: BorderRadius.circular(16),
                    color: cs.card,
                  ),
                  child: IconButton(
                    onPressed: () => _copyText(l),
                    icon: Icon(Icons.copy_rounded, color: cs.primary),
                    tooltip: l.copyTextOnly,
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontDropdownRow({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required ValueChanged<String?> onChanged,
    required AppColorScheme cs,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: cs.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cs.bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.cardBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: Icon(Icons.arrow_drop_down_rounded, color: cs.primary),
              dropdownColor: cs.card,
              borderRadius: BorderRadius.circular(12),
              items: items.map((font) {
                return DropdownMenuItem<String>(
                  value: font['family'],
                  child: Text(
                    font['name']!,
                    style: TextStyle(
                      fontFamily: font['family'],
                      fontSize: 13,
                      color: cs.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
