import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/tadabur_story.dart';
import '../../services/tadabur_service.dart';

class TadabourPage extends StatefulWidget {
  const TadabourPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar dengan search
          SliverAppBar(
            expandedHeight: 140.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Tadabur'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withValues(alpha: 0.8),
                      Theme.of(context).primaryColor.withValues(alpha: 0.4),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: _handleSearch,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).tadabur_searchPlaceholder,
                    prefixIcon: const Icon(Icons.search),
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
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
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
                        const Icon(Icons.error_outline, size: 64),
                        const SizedBox(height: 16),
                        Text(AppLocalizations.of(context).tadabur_loadError),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _storiesFuture =
                                  TadabourService.getAllStories();
                            });
                          },
                          child: Text(AppLocalizations.of(context).tadabur_retryBtn),
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
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha:0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isSearching
                              ? AppLocalizations.of(context).tadabur_searchEmpty
                              : AppLocalizations.of(context).tadabur_emptyStories,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Show guide card first
                      if (index == 0 && _showGuide) {
                        return _buildGuideCard();
                      }

                      final storyIndex = _showGuide ? index - 1 : index;
                      if (storyIndex >= displayedStories.length) {
                        return const SizedBox.shrink();
                      }

                      final story = displayedStories[storyIndex];
                      return _buildStoryCard(context, story);
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
    );
  }

  Widget _buildGuideCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).tadabur_guideTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
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
                  AppLocalizations.of(context).tadabur_step1Title,
                  AppLocalizations.of(context).tadabur_step1Desc,
                ),
                const SizedBox(height: 12),
                _buildGuideStep(
                  context,
                  '2',
                  AppLocalizations.of(context).tadabur_step2Title,
                  AppLocalizations.of(context).tadabur_step2Desc,
                ),
                const SizedBox(height: 12),
                _buildGuideStep(
                  context,
                  '3',
                  AppLocalizations.of(context).tadabur_step3Title,
                  AppLocalizations.of(context).tadabur_step3Desc,
                ),
                const SizedBox(height: 12),
                _buildGuideStep(
                  context,
                  '4',
                  AppLocalizations.of(context).tadabur_step4Title,
                  AppLocalizations.of(context).tadabur_step4Desc,
                ),
                const SizedBox(height: 12),
                _buildGuideStep(
                  context,
                  '5',
                  AppLocalizations.of(context).tadabur_step5Title,
                  AppLocalizations.of(context).tadabur_step5Desc,
                ),
                const SizedBox(height: 12),
                _buildGuideStep(
                  context,
                  '6',
                  AppLocalizations.of(context).tadabur_step6Title,
                  AppLocalizations.of(context).tadabur_step6Desc,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).tadabur_closing,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context).tadabur_closingDesc,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context).tadabur_closingQuote,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: 0.7),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.5,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoryCard(BuildContext context, TadabourStory story) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TadabourDetailPage(story: story),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Surah & Ayat
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  AppLocalizations.of(context).tadabur_surahAyah(story.surah, story.ayat),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Judul
              Text(
                story.judul,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              // Deskripsi
              Text(
                story.deskripsi,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Read more button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TadabourDetailPage(story: story),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context).tadabur_readMore),
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

  const TadabourDetailPage({
    Key? key,
    required this.story,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tadabur'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Surah & Ayat badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha:0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppLocalizations.of(context).tadabur_surahAyah(story.surah, story.ayat),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Judul
            Text(
              story.judul,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Deskripsi
            Text(
              story.deskripsi,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha:0.7),
                  ),
            ),
            const SizedBox(height: 24),

            // Divider
            Divider(
              height: 32,
              color: Theme.of(context).dividerColor,
            ),

            // Cerita heading
            Text(
              AppLocalizations.of(context).tadabur_storyHeading,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Cerita content
            Text(
              story.cerita,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: 24),

            // Divider
            Divider(
              height: 32,
              color: Theme.of(context).dividerColor,
            ),

            // Pelajaran heading
            Text(
              AppLocalizations.of(context).tadabur_lessonHeading,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Pelajaran content
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 4,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                story.pelajaran,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                    ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
