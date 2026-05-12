import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/view/widgets/home_rounded_icon_button.dart';
import '../data/tasbih_local_repository.dart';
import 'tasbih_detail_screen.dart';

class TasbihTabScreen extends StatefulWidget {
  const TasbihTabScreen({super.key});

  @override
  State<TasbihTabScreen> createState() => _TasbihTabScreenState();
}

class _TasbihTabScreenState extends State<TasbihTabScreen> {
  List<TasbihItem> _items = const <TasbihItem>[];
  bool _loading = true;
  bool _saving = false;

  bool _showEditor = false;
  TasbihItem? _editingItem;
  final TextEditingController _arabicController = TextEditingController();
  final TextEditingController _translitController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _arabicController.dispose();
    _translitController.dispose();
    _meaningController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final items = await TasbihLocalRepository.instance.getItems();
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _withSaving(
    Future<void> Function() action, {
    bool showLoader = true,
  }) async {
    if (showLoader) {
      setState(() => _saving = true);
    }
    try {
      await action();
    } finally {
      if (mounted && showLoader) {
        setState(() => _saving = false);
      }
    }
  }

  void _openEditor({TasbihItem? item}) {
    setState(() {
      _showEditor = true;
      _editingItem = item;
      _arabicController.text = item?.label ?? '';
      _translitController.text = item?.transliteration ?? '';
      _meaningController.text = item?.meaning ?? '';
    });
  }

  void _closeEditor() {
    setState(() {
      _showEditor = false;
      _editingItem = null;
      _arabicController.clear();
      _translitController.clear();
      _meaningController.clear();
    });
  }

  Future<void> _saveEditor() async {
    final label = _arabicController.text.trim();
    final transliteration = _translitController.text.trim();
    final meaning = _meaningController.text.trim();
    if (label.isEmpty && transliteration.isEmpty) return;

    await _withSaving(() async {
      final effectiveLabel = label.isNotEmpty ? label : transliteration;
      if (_editingItem == null) {
        await TasbihLocalRepository.instance.addCustomItem(
          label: effectiveLabel,
          transliteration: transliteration,
          meaning: meaning,
        );
      } else {
        await TasbihLocalRepository.instance.updateCustomItem(
          id: _editingItem!.id,
          label: effectiveLabel,
          transliteration: transliteration,
          meaning: meaning,
        );
      }
      await _loadItems();
    });

    if (!mounted) return;
    _closeEditor();
  }

  Future<void> _togglePin(TasbihItem item) async {
    await _withSaving(() async {
      await TasbihLocalRepository.instance.togglePin(item.id);
      await _loadItems();
    }, showLoader: false);
  }

  Future<void> _reorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    if (_items[oldIndex].isPinned) return;
    final pinnedCount = _items.where((e) => e.isPinned).length;
    if (newIndex < pinnedCount) return;
    final reordered = List<TasbihItem>.from(_items);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    setState(() => _items = reordered);
    await _withSaving(() async {
      await TasbihLocalRepository.instance.reorderItems(reordered);
      await _loadItems();
    }, showLoader: false);
  }

  Future<void> _openDetail(TasbihItem item) async {
    await Navigator.of(context).push<void>(
      CupertinoPageRoute<void>(builder: (_) => TasbihDetailScreen(item: item)),
    );
    if (!mounted) return;
    await _loadItems();
  }

  Future<void> _deleteCustom(TasbihItem item) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.tasbihDeleteDhikrTitle),
          content: Text(item.label),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.tasbihDelete),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    await _withSaving(() async {
      await TasbihLocalRepository.instance.deleteCustomItem(item.id);
      await _loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.20,
    );
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.tasbihTabTitle,
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              l10n.tasbihChooseOrAddSubtitle,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      HomeRoundedIconButton(
                        icon: Icons.add,
                        onTap: () => _openEditor(),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor, width: 1.1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.tasbihGrandTotalLabel,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${_items.length}',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showEditor) ...[
                    SizedBox(height: 8.h),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _editingItem == null
                                        ? l10n.tasbihAddCustomTitle
                                        : l10n.tasbihEditCustomTitle,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _closeEditor,
                                  icon: const Icon(Icons.close_rounded),
                                ),
                              ],
                            ),
                            TextField(
                              controller: _arabicController,
                              decoration: InputDecoration(
                                hintText: l10n.tasbihArabicOrDhikrHint,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextField(
                              controller: _translitController,
                              decoration: InputDecoration(
                                hintText:
                                    l10n.tasbihTransliterationOptionalHint,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextField(
                              controller: _meaningController,
                              decoration: InputDecoration(
                                hintText: l10n.tasbihMeaningOptionalHint,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton.tonal(
                                    onPressed: _closeEditor,
                                    child: Text(l10n.cancel),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: FilledButton(
                                    onPressed: _saveEditor,
                                    child: Text(l10n.save),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemCount: _items.length,
                      onReorder: _reorder,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor, width: 1.1),
                          ),
                          key: ValueKey(item.id),
                          margin: EdgeInsets.only(bottom: 8.h),
                          child: ListTile(
                            isThreeLine: true,
                            onTap: () => _openDetail(item),
                            title: Row(
                              children: [
                                if (item.isPinned)
                                  Padding(
                                    padding: EdgeInsets.only(right: 6.w),
                                    child: Icon(
                                      Icons.push_pin_rounded,
                                      size: 14.sp,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.transliteration.isEmpty
                                        ? l10n.tasbihNoTransliteration
                                        : item.transliteration,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (item.meaning.isNotEmpty) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      item.meaning,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                  if (item.totalCount > 0) ...[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.bar_chart_rounded,
                                          size: 14.sp,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '${l10n.tasbihTotalCount}: ${item.totalCount}',
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.push_pin_rounded,
                                    color: item.isPinned
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () => _togglePin(item),
                                ),
                                if (item.isCustom)
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () => _openEditor(item: item),
                                  ),
                                if (item.isCustom)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _deleteCustom(item),
                                  ),
                                if (!item.isPinned)
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: Icon(
                                      Icons.drag_indicator_rounded,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                const Icon(Icons.chevron_right_rounded),
                              ],
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
        ),
        if (_saving)
          ColoredBox(
            color: Colors.black.withValues(alpha: 0.15),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
