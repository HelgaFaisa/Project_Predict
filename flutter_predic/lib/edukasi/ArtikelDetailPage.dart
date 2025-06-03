// screens/education_detail_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:intl/intl.dart'; 

import '../model/edukasiartikel.dart'; 
import '../api/edukasi_api.dart';   

// Import CardContainer jika akan digunakan untuk bagian tertentu
import '../home_page.dart'; 

class EducationDetailScreen extends StatefulWidget {
  final EducationArticle? article; 
  final String? articleId;
  final String? articleSlug;

  const EducationDetailScreen({
    Key? key,
    this.article,
    this.articleId,
    this.articleSlug,
  }) : super(key: key);

  @override
  State<EducationDetailScreen> createState() => _EducationDetailScreenState();
}

class _EducationDetailScreenState extends State<EducationDetailScreen> {
  EducationArticle? _currentArticle; 
  bool isLoading = false;
  String? errorMessage;
  final ScrollController _scrollController = ScrollController();
  bool _showTitleInAppBar = false; 

  @override
  void initState() {
    super.initState();
    _initializeArticle();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showTitle = _scrollController.hasClients &&
        _scrollController.offset > (_currentArticle?.imageUrl != null && _currentArticle!.imageUrl!.isNotEmpty ? 220 : 50); 
    
    if (showTitle != _showTitleInAppBar) {
      if (mounted) {
        setState(() {
          _showTitleInAppBar = showTitle;
        });
      }
    }
  }

  Future<void> _initializeArticle() async {
    if (widget.article != null) {
      if (mounted) {
        setState(() {
          _currentArticle = widget.article;
        });
      }
      return;
    }

    if (widget.articleId != null || widget.articleSlug != null) {
      await _loadArticle();
    } else {
      if (mounted) {
        setState(() {
          errorMessage = 'Artikel tidak ditemukan.';
          isLoading = false; // Pastikan loading dihentikan
        });
      }
    }
  }

  Future<void> _loadArticle() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      ApiResponse<EducationArticle> response;
      
      if (widget.articleSlug != null) {
        response = await EducationService.getArticleBySlug(widget.articleSlug!);
      } else if (widget.articleId != null) {
        response = await EducationService.getArticleById(widget.articleId!);
      } else {
        throw Exception('No article identifier provided after initial check');
      }

      if(!mounted) return;
      setState(() {
        isLoading = false;
        if (response.success && response.data != null) {
          _currentArticle = response.data;
          errorMessage = null;
        } else {
          errorMessage = response.message ?? "Gagal memuat detail artikel.";
        }
      });
    } catch (e) {
      if(!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(date); // Format lebih lengkap
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], 
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (errorMessage != null)
            SliverFillRemaining(
              child: _buildErrorWidget(),
            )
          else if (_currentArticle != null)
            _buildContent(_currentArticle!) 
          else
             SliverFillRemaining( 
              child: Center(child: Text("Artikel tidak tersedia.", style: GoogleFonts.poppins())),
            )
        ],
      ),
      floatingActionButton: _currentArticle != null ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildSliverAppBar() {
    bool hasImage = _currentArticle?.imageUrl != null && _currentArticle!.imageUrl!.isNotEmpty;
    // Dapatkan tinggi status bar untuk padding yang benar
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      expandedHeight: hasImage ? 250.0 : (kToolbarHeight + statusBarHeight + 40), // Sesuaikan tinggi jika tidak ada gambar
      floating: false,
      pinned: true,
      backgroundColor: Colors.blue.shade700, 
      foregroundColor: Colors.white,       
      elevation: 2.0, 
      title: AnimatedOpacity(
        opacity: _showTitleInAppBar ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Text(
          _currentArticle?.title ?? 'Detail Artikel',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _currentArticle!.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(color: Colors.blue[100], child: const Center(child: CircularProgressIndicator()));
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.blue[100],
                      child: Center(child: Icon(Icons.broken_image_outlined, size: 50, color: Colors.blue[300])),
                    ),
                  ),
                  Container( 
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)], // Gradient lebih kuat
                        stops: const [0.4, 1.0] // Stop gradient disesuaikan
                      ),
                    ),
                  ),
                ],
              )
            : Container( 
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade700, Colors.blue.shade500],
                  ),
                ),
                // --- INI PERBAIKAN PADDING YANG SEBELUMNYA ERROR ---
                padding: EdgeInsets.only(
                  top: statusBarHeight + kToolbarHeight / 2, // Posisi vertikal lebih baik
                  left: 20, 
                  right: 20,
                  bottom: 16 
                ), 
                alignment: Alignment.center, 
                // --- AKHIR PERBAIKAN PADDING ---
                child: Text( 
                    _currentArticle?.title ?? 'Detail Artikel',
                    style: GoogleFonts.poppins(
                        color: Colors.white, 
                        fontSize: 20, // Font size disesuaikan
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(1.0, 1.0),
                          ),
                        ]
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3, 
                    overflow: TextOverflow.ellipsis,
                  ),
              ),
      ),
      actions: [
        if (_currentArticle != null) 
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareArticle(_currentArticle!),
            tooltip: 'Bagikan Artikel',
          ),
      ],
    );
  }

  Widget _buildContent(EducationArticle article) { 
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20), // Padding atas dan samping disesuaikan
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Text(
            article.title,
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.35),
          ),
          const SizedBox(height: 16),
          _buildArticleMeta(article),
          const SizedBox(height: 24),
          if (article.summary != null && article.summary!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[100]?.withOpacity(0.4), 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200.withOpacity(0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.lightbulb_outline_rounded, color: Colors.blue.shade800, size: 22),
                    const SizedBox(width: 10),
                    Text('Ringkasan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.blue.shade800, fontSize: 16)),
                  ]),
                  const SizedBox(height: 10),
                  Text(article.summary!, style: GoogleFonts.poppins(height: 1.6, fontSize: 15, color: Colors.black87.withOpacity(0.9))),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (article.content != null && article.content!.isNotEmpty) ...[
            Text('Artikel Lengkap', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16), // Jarak lebih
            _buildContentText(article.content!),
          ] else ...[
            // Menggunakan CardContainer jika konten kosong
            CardContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.article_outlined, size: 50, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Konten artikel tidak tersedia.', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16)),
              ]),
            ),
          ],
          const SizedBox(height: 80), 
        ]),
      ),
    );
  }

  Widget _buildArticleMeta(EducationArticle article) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:12.0, vertical: 12), // Padding disesuaikan
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.07), blurRadius: 8, offset: Offset(0,3))
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (article.category != null && article.category!.isNotEmpty)
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder_open_outlined, size: 18, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      article.category!,
                      style: GoogleFonts.poppins(color: Colors.blue.shade700, fontWeight: FontWeight.w500, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          if (article.publishedAt != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  _formatDate(article.publishedAt!), // Menggunakan _formatDate yang sudah diperbarui
                  style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 12),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildContentText(String content) {
    final paragraphs = content.split(RegExp(r'\n\s*\n|\r\n\s*\r\n')); 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((paragraph) {
        if (paragraph.trim().isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            paragraph.trim().replaceAll(RegExp(r'\s+\n|\n\s+'), '\n'), 
            style: GoogleFonts.poppins(height: 1.7, fontSize: 16, color: Colors.black87.withOpacity(0.9)),
            textAlign: TextAlign.justify,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: CardContainer( // Menggunakan CardContainer
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 50, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text('Terjadi Kesalahan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 8),
              Text(errorMessage ?? 'Tidak dapat memuat artikel ini.', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 15)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadArticle, 
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: Text('Coba Lagi', style: GoogleFonts.poppins(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _scrollToTop(),
      icon: const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white),
      label: Text('Ke Atas', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      backgroundColor: Colors.blue.shade600, 
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _shareArticle(EducationArticle article) { 
    final shareText = '''
${article.title}

Baca selengkapnya di aplikasi DiabetaCare!
${article.summary != null && article.summary!.isNotEmpty ? '\nRingkasan: ${article.summary}' : ''}
'''; 
    
    Clipboard.setData(ClipboardData(text: shareText));
    
    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text('Tautan artikel berhasil disalin!', style: GoogleFonts.poppins())),
          ]),
          backgroundColor: Colors.green.shade600, // Warna disesuaikan
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 70), // Margin agar tidak tertutup FAB
        ),
      );
    }
  }
}