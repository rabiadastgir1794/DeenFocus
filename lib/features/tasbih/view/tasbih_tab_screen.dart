import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../l10n/app_localizations.dart';
import '../data/tasbih_local_repository.dart';

class TasbihTabScreen extends StatefulWidget {
  const TasbihTabScreen({super.key});

  @override
  State<TasbihTabScreen> createState() => _TasbihTabScreenState();
}

class _TasbihTabScreenState extends State<TasbihTabScreen> {
  List<TasbihItem> _items = const <TasbihItem>[];
  TasbihItem? _selectedItem;
  bool _loading = true;
  bool _saving = false;
  int _sessionCount = 0;
  int _savedTotal = 0;

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

  Future<void> _deleteCustom(TasbihItem item) async {
    await _withSaving(() async {
      await TasbihLocalRepository.instance.deleteCustomItem(item.id);
      await _loadItems();
    });
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

  void _openDetail(TasbihItem item) {
    setState(() {
      _selectedItem = item;
      _savedTotal = item.totalCount;
      _sessionCount = 0;
    });
  }

  Future<void> _saveSession() async {
    final item = _selectedItem;
    if (item == null || _sessionCount <= 0) return;

    await _withSaving(() async {
      final total = await TasbihLocalRepository.instance.saveSession(
        tasbihId: item.id,
        sessionCount: _sessionCount,
      );
      await _loadItems();
      if (!mounted) return;
      setState(() {
        _savedTotal = total;
        _sessionCount = 0;
        _selectedItem = _items.firstWhere((e) => e.id == item.id);
      });
    }, showLoader: false);
  }

  Future<void> _resetTotal() async {
    final item = _selectedItem;
    if (item == null) return;
    await _withSaving(() async {
      await TasbihLocalRepository.instance.resetTotal(item.id);
      await _loadItems();
      if (!mounted) return;
      setState(() {
        _savedTotal = 0;
        _sessionCount = 0;
        _selectedItem = _items.firstWhere((e) => e.id == item.id);
      });
    }, showLoader: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_selectedItem != null) {
      return _TasbihDetailView(
        item: _selectedItem!,
        sessionCount: _sessionCount,
        totalCount: _savedTotal,
        saving: _saving,
        onBack: () => setState(() {
          _selectedItem = null;
          _sessionCount = 0;
        }),
        onTapCounter: () {
          if (_sessionCount >= 100) return;
          setState(() => _sessionCount += 1);
        },
        onSave: _saveSession,
        onReset: _resetTotal,
      );
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
                      IconButton(
                        onPressed: () => _openEditor(),
                        icon: const Icon(Icons.add_circle_outline_rounded),
                      ),
                    ],
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
                        return Card(
                          key: ValueKey(item.id),
                          margin: EdgeInsets.only(bottom: 8.h),
                          child: ListTile(
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
                                Expanded(child: Text(item.label)),
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
                                  ),
                                  if (item.totalCount > 0)
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
                                          item.totalCount.toString(),
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

class _TasbihDetailView extends StatelessWidget {
  const _TasbihDetailView({
    required this.item,
    required this.sessionCount,
    required this.totalCount,
    required this.saving,
    required this.onBack,
    required this.onTapCounter,
    required this.onSave,
    required this.onReset,
  });

  final TasbihItem item;
  final int sessionCount;
  final int totalCount;
  final bool saving;
  final VoidCallback onBack;
  final VoidCallback onTapCounter;
  final Future<void> Function() onSave;
  final Future<void> Function() onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final progress = (sessionCount / 100).clamp(0.0, 1.0);

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 16.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: onBack,
                        icon: const Icon(Icons.chevron_left_rounded),
                        label: Text(l10n.tasbihBack),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.transliteration.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      item.transliteration,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart_rounded,
                        size: 18.sp,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '$totalCount',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 250.w,
                    height: 250.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 250.w,
                          height: 250.w,
                          child: CircularProgressIndicator(
                            value: 1,
                            strokeWidth: 8,
                            color: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                        SizedBox(
                          width: 250.w,
                          height: 250.w,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 8,
                            color: colorScheme.primary,
                          ),
                        ),
                        Material(
                          elevation: 8,
                          shape: const CircleBorder(),
                          color: colorScheme.surface,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: onTapCounter,
                            child: SizedBox(
                              width: 195.w,
                              height: 195.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$sessionCount',
                                    style: TextStyle(
                                      fontSize: 48.sp,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    l10n.tasbihTapMe,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: onReset,
                          icon: const Icon(Icons.rotate_left_rounded),
                          label: Text(l10n.tasbihReset),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onSave,
                          icon: const Icon(Icons.save_outlined),
                          label: Text(l10n.save),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (saving)
          ColoredBox(
            color: Colors.black.withValues(alpha: 0.15),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
