import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../data/islamic_library_repository.dart';
import '../model/library_hadith.dart';
import 'hadith_reader_screen.dart';
import 'library_category_tile.dart';

class HadithCollectionsScreen extends StatefulWidget {
  const HadithCollectionsScreen({super.key});

  @override
  State<HadithCollectionsScreen> createState() =>
      _HadithCollectionsScreenState();
}

class _HadithCollectionsScreenState extends State<HadithCollectionsScreen> {
  bool _loading = true;
  List<HadithCollection> _collections = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final collections =
        await IslamicLibraryRepository.instance.loadHadithCollections();
    if (!mounted) return;
    setState(() {
      _collections = collections;
      _loading = false;
    });
  }

  void _openCollection(HadithCollection collection) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HadithReaderScreen(collection: collection),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softCardColor =
        isDark ? colorScheme.surfaceContainerHighest : AppColors.surfaceLight;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.libraryModuleHadith,
        subtitle: l10n.libraryModuleHadithSub,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              itemCount: _collections.length,
              separatorBuilder: (_, _) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final collection = _collections[index];
                return LibraryCategoryTile(
                  title: hadithCollectionTitle(l10n, collection.id),
                  subtitle: l10n.libraryHadithCount(collection.itemCount),
                  icon: Icons.auto_stories_outlined,
                  backgroundColor: softCardColor,
                  onTap: () => _openCollection(collection),
                );
              },
            ),
    );
  }
}

String hadithCollectionTitle(AppLocalizations l10n, String collectionId) {
  switch (collectionId) {
    case 'bukhari':
      return l10n.libraryHadithCollectionBukhari;
    case 'muslim':
      return l10n.libraryHadithCollectionMuslim;
    case 'riyad_us_saliheen':
      return l10n.libraryHadithCollectionRiyad;
    case 'nawawi_40':
      return l10n.libraryHadithCollectionNawawi;
    case 'hisnul_muslim':
      return l10n.libraryHadithCollectionHisnul;
    default:
      return collectionId;
  }
}
