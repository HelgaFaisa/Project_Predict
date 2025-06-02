// screens/education_list_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // DITAMBAHKAN
import 'package:intl/intl.dart'; // DITAMBAHKAN untuk format tanggal yang lebih baik
import 'ArtikelDetailPage.dart';
import '../model/edukasiartikel.dart'; // Sesuaikan path jika perlu
import '../api/edukasi_api.dart';   // Sesuaikan path jika perlu

// Import untuk CardContainer dan EnhancedProfileHeader
// Sesuaikan path jika file homepage.dart atau widget terpisah
import '../home_page.dart'; // Asumsi CardContainer & EnhancedProfileHeader ada di sini atau diimport olehnya

class EducationListScreen extends StatefulWidget {
  // DITAMBAHKAN: userName jika ingin menampilkan header profil
  final String userName; 
  const EducationListScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<EducationListScreen> createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  List<EducationArticle> articles = [];
  List<String> categories = []; // Ini akan berisi nama kategori dari API
  bool isLoading = true;
  bool isLoadingMore = false;
  String? selectedCategory; // Ini akan menyimpan nama kategori yang dipilih
  String searchQuery = '';
  int currentPage = 1;
  bool hasMoreData = true;
  String? errorMessage;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Hapus listener dengan benar
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) { // Trigger lebih awal
      if (hasMoreData && !isLoadingMore) {
        _loadMoreArticles();
      }
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      currentPage = 1; // Reset halaman
      hasMoreData = true; // Asumsikan ada data lebih
      articles.clear(); // Bersihkan artikel lama
    });

    try {
      final categoriesResponse = await EducationService.getCategories();
      if (mounted && categoriesResponse.success && categoriesResponse.data != null) {
        setState(() {
          categories = List<String>.from(categoriesResponse.data!);
        });
      } else if (mounted && !categoriesResponse.success) {
        // Handle error ambil kategori jika perlu, atau biarkan saja
        print("Gagal memuat kategori: ${categoriesResponse.message}");
      }
      await _loadArticles(refresh: true); // refresh true akan membersihkan articles
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Terjadi kesalahan: $e";
        });
      }
    }
  }

  Future<void> _loadArticles({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        currentPage = 1;
        hasMoreData = true;
        // articles.clear(); // Sudah dilakukan di _loadInitialData atau sebelum panggil ini
      });
    }
    // Jika sedang loading atau tidak ada data lagi, jangan lakukan apa-apa
    if (isLoading && !refresh || isLoadingMore && !refresh) return;

    if(refresh) setState(() => isLoading = true);


    final response = await EducationService.getArticles(
      page: currentPage,
      perPage: 10,
      category: selectedCategory, // Kirim nama kategori, bukan objek
      search: searchQuery.isNotEmpty ? searchQuery : null,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
      isLoadingMore = false;

      if (response.success && response.data != null) {
        if (refresh) {
          articles = response.data!;
        } else {
          articles.addAll(response.data!);
        }

        if (response.pagination != null) {
          hasMoreData = response.pagination!.currentPage < response.pagination!.lastPage;
        } else {
          // Fallback jika info pagination tidak ada, anggap tidak ada data lagi jika return < perPage
          hasMoreData = response.data!.length >= 10;
        }
        errorMessage = null;
      } else {
        errorMessage = response.message ?? "Gagal memuat artikel.";
        // Jika refresh dan error, list artikel sudah dibersihkan
        // Jika load more dan error, hasMoreData mungkin perlu di-set false agar tidak coba lagi
        if (!refresh) hasMoreData = false; 
      }
    });
  }

  Future<void> _loadMoreArticles() async {
    if (isLoadingMore || !hasMoreData) return;
    setState(() => isLoadingMore = true);
    currentPage++;
    await _loadArticles();
  }

  void _onSearchChanged(String value) {
    setState(() => searchQuery = value);
    _debounceSearch();
  }

  Timer? _debounceTimer;
  void _debounceSearch() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () { // Durasi debounce
      _loadArticles(refresh: true);
    });
  }

  void _onCategorySelected(String? category) {
    // Jika kategori yang dipilih adalah "Semua", set selectedCategory menjadi null
    final newCategory = (category == 'Semua' || category == null) ? null : category;
    if (selectedCategory == newCategory) return; // Tidak ada perubahan

    setState(() {
      selectedCategory = newCategory;
    });
    _loadArticles(refresh: true);
  }

  Future<void> _refreshData() async {
    _searchController.clear(); // Bersihkan search query saat refresh manual
    setState(() {
      searchQuery = '';
      selectedCategory = null; // Reset kategori juga
    });
    await _loadInitialData();
  }

  // Format tanggal yang lebih baik
  String _formatDate(DateTime? date) {
    if (date == null) return 'Tanggal tidak tersedia';
    // Pastikan intl sudah diinisialisasi di main.dart
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Latar belakang konsisten
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Profil
          EnhancedProfileHeader(
            userName: widget.userName,
            onAvatarTap: () {
              // Navigasi ke halaman profil
            },
          ),
          // Judul Halaman
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'Artikel Edukasi',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh_rounded, color: Colors.blue.shade700, size: 28),
                  onPressed: _refreshData,
                  tooltip: 'Muat Ulang Artikel',
                )
              ],
            ),
          ),
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.white, // Latar belakang putih untuk bagian filter
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: GoogleFonts.poppins(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Cari artikel...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.blue[50]?.withOpacity(0.5), // Warna field pencarian
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Dibuat lebih kotak
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
                if (categories.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip('Semua', selectedCategory == null),
                        ...categories.map((category) =>
                            _buildCategoryChip(category, selectedCategory == category)),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
          // Content Section
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.poppins( // Menggunakan GoogleFonts
            color: isSelected ? Colors.white : Colors.blue.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          _onCategorySelected(selected ? label : null);
        },
        selectedColor: Colors.blue.shade600, // Warna saat terpilih
        backgroundColor: Colors.blue.shade50, // Warna default
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.blue.shade600 : Colors.blue.shade200,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading && articles.isEmpty) { // Tampilkan loading hanya jika artikel kosong
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null && articles.isEmpty) { // Tampilkan error hanya jika artikel kosong
      return _buildErrorWidget();
    }

    if (articles.isEmpty && !isLoading) { // Tampilkan empty state jika artikel kosong dan tidak loading
      return _buildEmptyWidget();
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: Colors.blue.shade700,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20), // Padding disesuaikan
        itemCount: articles.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == articles.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return _buildArticleCard(articles[index]);
        },
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CardContainer( // Menggunakan CardContainer
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 50, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text('Terjadi Kesalahan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(errorMessage ?? 'Tidak dapat memuat data. Silakan coba lagi.', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.grey[600])),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _refreshData, // Diubah ke _refreshData agar filter juga direset
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Coba Lagi', style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CardContainer( // Menggunakan CardContainer
            child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_outlined, size: 50, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text('Tidak Ada Artikel', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                searchQuery.isNotEmpty
                    ? 'Tidak ada artikel yang cocok dengan pencarian "$searchQuery".'
                    : (selectedCategory != null ? 'Tidak ada artikel dalam kategori "$selectedCategory".' : 'Belum ada artikel yang tersedia.'),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
              if (searchQuery.isNotEmpty || selectedCategory != null) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    _onCategorySelected(null); // Ini akan memanggil _loadArticles(refresh: true)
                  },
                  icon: const Icon(Icons.clear_all_rounded),
                  label: Text('Reset Filter', style: GoogleFonts.poppins()),
                   style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black87),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(EducationArticle article) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CardContainer( // Menggunakan CardContainer
        padding: EdgeInsets.zero, // Padding diatur manual di dalam
        child: InkWell(
          onTap: () => _navigateToDetail(article),
          borderRadius: BorderRadius.circular(24), // Samakan dengan CardContainer
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  child: Image.network(
                    article.imageUrl!,
                    height: 180, // Tinggi gambar disesuaikan
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(height: 180, color: Colors.grey[200], child: const Center(child: CircularProgressIndicator()));
                    },
                    errorBuilder: (context, error, stackTrace) => Container(height: 180, color: Colors.grey[200], child: Center(child: Icon(Icons.broken_image_outlined, size: 50, color: Colors.grey[400]))),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (article.category != null && article.category!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blue.shade200)),
                            child: Text(article.category!, style: GoogleFonts.poppins(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.w500)),
                          ),
                        const Spacer(),
                        if (article.publishedAt != null)
                          Text(_formatDate(article.publishedAt!), style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title,
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (article.summary != null && article.summary!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        article.summary!,
                        style: GoogleFonts.poppins(color: Colors.grey[700], height: 1.4, fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Baca Selengkapnya', style: GoogleFonts.poppins(color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue.shade700),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Di dalam class _EducationListScreenState
void _navigateToDetail(EducationArticle article) {
  Navigator.pushNamed(
    context,
    '/education-detail',
    arguments: article, // Mengirim objek artikel sebagai argumen
  );
}
}