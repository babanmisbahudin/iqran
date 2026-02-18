import 'package:flutter/material.dart';
import '../../models/tadabur_story.dart';
import '../../services/tadabur_service.dart';
import '../../widgets/animated_list_item.dart';
import '../../widgets/animated_card_wrapper.dart';

class TadabourPage extends StatefulWidget {
  final double fontSize;
  final double latinFontSize;

  const TadabourPage({
    Key? key,
    this.fontSize = 28.0,
    this.latinFontSize = 16.0,
  }) : super(key: key);

  @override
  State<TadabourPage> createState() => _TadabourPageState();
}

class _TadabourPageState extends State<TadabourPage> {
  late Future<List<TadabourStory>> _storiesFuture;
  final TextEditingController _searchController = TextEditingController();
  List<TadabourStory> _filteredStories = [];
  bool _isSearching = false;
  bool _showGuide = true;

  @override
  void initState() {
    super.initState();
    _storiesFuture = TadabourService.getAllStories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredStories = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    TadabourService.searchStories(query).then((results) {
      setState(() {
        _filteredStories = results;
      });
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _storiesFuture = TadabourService.getAllStories();
    });
    await _storiesFuture;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          slivers: [
          // Modern App Bar with search
          SliverAppBar(
            expandedHeight: 160.0,
            floating: true,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withValues(alpha: 0.8),
                      primaryColor.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: _handleSearch,
                  decoration: InputDecoration(
                    hintText: 'Cari cerita...',
                    prefixIcon: Icon(Icons.search, color: primaryColor),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _handleSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.black26
                        : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Stories list
          FutureBuilder<List<TadabourStory>>(
            future: _storiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: primaryColor),
                        const SizedBox(height: 16),
                        const Text('Gagal memuat cerita'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          onPressed: () {
                            setState(() {
                              _storiesFuture =
                                  TadabourService.getAllStories();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              final allStories = snapshot.data ?? [];
              final displayedStories =
                  _isSearching ? _filteredStories : allStories;

              if (displayedStories.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isSearching ? Icons.search_off : Icons.menu_book,
                          size: 64,
                          color: primaryColor.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isSearching
                              ? 'Hasil tidak ditemukan'
                              : 'Belum ada cerita',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Show guide card first
                      if (index == 0 && _showGuide) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: AnimatedCardWrapper(
                            entranceDelay: const Duration(milliseconds: 100),
                            child: _buildGuideCard(),
                          ),
                        );
                      }

                      final storyIndex = _showGuide ? index - 1 : index;
                      if (storyIndex >= displayedStories.length) {
                        return const SizedBox.shrink();
                      }

                      final story = displayedStories[storyIndex];
                      return AnimatedListItem(
                        index: storyIndex,
                        delayMultiplier: const Duration(milliseconds: 50),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: _buildStoryCard(context, story),
                        ),
                      );
                    },
                    childCount:
                        displayedStories.length + (_showGuide ? 1 : 0),
                  ),
                ),
              );
            },
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildGuideCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? Colors.grey[900] : Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(
                  color: primaryColor.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tadabur Guide',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _showGuide = false;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuideStep(
                  context,
                  '1',
                  'Langkah 1: Baca',
                  'Baca ayat-ayat Al-Qur\'an dengan seksama',
                ),
                const SizedBox(height: 16),
                _buildGuideStep(
                  context,
                  '2',
                  'Langkah 2: Pahami',
                  'Cari tahu arti kata-kata yang sulit',
                ),
                const SizedBox(height: 16),
                _buildGuideStep(
                  context,
                  '3',
                  'Langkah 3: Renungkan',
                  'Pikirkan pesan dan pelajaran yang terkandung',
                ),
                const SizedBox(height: 16),
                _buildGuideStep(
                  context,
                  '4',
                  'Langkah 4: Hubungkan',
                  'Kaitkan ayat dengan kehidupan Anda',
                ),
                const SizedBox(height: 16),
                _buildGuideStep(
                  context,
                  '5',
                  'Langkah 5: Hafal',
                  'Ingat ajaran-ajaran kunci',
                ),
                const SizedBox(height: 16),
                _buildGuideStep(
                  context,
                  '6',
                  'Langkah 6: Bagikan',
                  'Bagikan apa yang telah Anda pelajari dengan orang lain',
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lanjutkan Perjalananmu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Setiap ayat memiliki kebijaksanaan yang menunggu untuk ditemukan',
                        style: TextStyle(
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Sebaik-baiknya kalian adalah yang mempelajari Al-Qur\'an dan mengajarkannya',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: 0.7),
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep(BuildContext context, String number, String title, String description) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.latinFontSize,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.6,
                      fontSize: widget.latinFontSize - 1,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoryCard(BuildContext context, TadabourStory story) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? Colors.grey[900] : Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TadabourDetailPage(
                story: story,
                fontSize: widget.fontSize,
                latinFontSize: widget.latinFontSize,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Surah & Ayat badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Surah ${story.surah}:${story.ayat}',
                  style: TextStyle(
                    fontSize: widget.latinFontSize,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Judul (Title)
              Text(
                story.judul,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.fontSize - 2,
                    ),
              ),
              const SizedBox(height: 8),

              // Deskripsi (Description)
              Text(
                story.deskripsi,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: widget.latinFontSize,
                      height: 1.5,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 14),

              // Read more button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.arrow_forward_ios, size: 14),
                  label: Text(
                    'Baca Selengkapnya',
                    style: TextStyle(fontSize: widget.latinFontSize),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TadabourDetailPage(
                          story: story,
                          fontSize: widget.fontSize,
                          latinFontSize: widget.latinFontSize,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Detail page untuk satu cerita
class TadabourDetailPage extends StatelessWidget {
  final TadabourStory story;
  final double fontSize;
  final double latinFontSize;

  const TadabourDetailPage({
    Key? key,
    required this.story,
    this.fontSize = 28.0,
    this.latinFontSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tadabur'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Surah & Ayat badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    'Surah ${story.surah}:${story.ayat}',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: latinFontSize,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Judul (Title)
                Text(
                  story.judul,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                ),
                const SizedBox(height: 16),

                // Deskripsi (Description)
                Text(
                  story.deskripsi,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontSize: latinFontSize,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withValues(alpha: 0.75),
                        height: 1.6,
                      ),
                ),
                const SizedBox(height: 28),

                // Divider
                Divider(
                  height: 32,
                  thickness: 2,
                  color: primaryColor.withValues(alpha: 0.1),
                ),

                // Cerita heading
                Text(
                  'Cerita',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: latinFontSize + 2,
                        color: primaryColor,
                      ),
                ),
                const SizedBox(height: 14),

                // Cerita content
                Text(
                  story.cerita,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.8,
                        fontSize: latinFontSize,
                      ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 28),

                // Divider
                Divider(
                  height: 32,
                  thickness: 2,
                  color: primaryColor.withValues(alpha: 0.1),
                ),

                // Pelajaran heading
                Text(
                  'Pelajaran',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: latinFontSize + 2,
                        color: primaryColor,
                      ),
                ),
                const SizedBox(height: 14),

                // Pelajaran content
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.08),
                    border: Border(
                      left: BorderSide(
                        color: primaryColor,
                        width: 5,
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    story.pelajaran,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.8,
                          fontSize: latinFontSize,
                        ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
