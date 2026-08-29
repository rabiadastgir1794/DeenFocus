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

  @override
  void initState() {
    super.initState();
    _loadItems();
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
    if (showLoader) setState(() => _saving = true);
    try {
      await action();
    } finally {
      if (mounted && showLoader) setState(() => _saving = false);
    }
  }

  Future<void> _openEditor({TasbihItem? item}) async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: (_, animation, _, child) => ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: animation, child: child),
      ),
      pageBuilder: (_, _, _) => _KeyboardAwareDialogPadding(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: _DhikrEditorSheet(
              item: item,
              onSave: (label, translit, meaning) async {
                await _withSaving(() async {
                  final effectiveLabel = label.isNotEmpty ? label : translit;
                  if (item == null) {
                    await TasbihLocalRepository.instance.addCustomItem(
                      label: effectiveLabel,
                      transliteration: translit,
                      meaning: meaning,
                    );
                  } else {
                    await TasbihLocalRepository.instance.updateCustomItem(
                      id: item.id,
                      label: effectiveLabel,
                      transliteration: translit,
                      meaning: meaning,
                    );
                  }
                  await _loadItems();
                });
              },
            ),
          ),
        ),
      ),
    );
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
      CupertinoPageRoute<void>(
          builder: (_) => TasbihDetailScreen(item: item)),
    );
    if (!mounted) return;
    await _loadItems();
  }

  Future<void> _deleteCustom(TasbihItem item) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
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
                                fontSize: 14.sp,
                                color: colorScheme.onSurfaceVariant,
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
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemCount: _items.length,
                      onReorder: _reorder,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Container(
                          key: ValueKey(item.id),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: borderColor,
                              width: 1.1,
                            ),
                          ),
                          margin: EdgeInsets.only(bottom: 8.h),
                          child: ListTile(
                            contentPadding: EdgeInsetsDirectional.only(
                              start: 16.w,
                              end: 0,
                            ),
                            onTap: () => _openDetail(item),
                            title: Row(
                              children: [
                                if (item.isPinned)
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                      end: 6.w,
                                    ),
                                    child: Icon(
                                      Icons.push_pin_rounded,
                                      size: 14.sp,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    maxLines: 1,
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (item.totalCount > 0)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.bar_chart_rounded,
                                          size: 14.sp,
                                          color: colorScheme.primary,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '${l10n.tasbihTotalCount}: ${item.totalCount}',
                                          style: TextStyle(
                                            color: colorScheme.primary,
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
                                if (!item.isPinned)
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 12.h,
                                      ),
                                      child: Icon(
                                        Icons.drag_handle_rounded,
                                        size: 20,
                                        color: colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                PopupMenuButton<_ItemAction>(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.more_vert_rounded,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  onSelected: (action) async {
                                    switch (action) {
                                      case _ItemAction.pin:
                                        await _togglePin(item);
                                      case _ItemAction.edit:
                                        await _openEditor(item: item);
                                      case _ItemAction.delete:
                                        await _deleteCustom(item);
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    PopupMenuItem<_ItemAction>(
                                      value: _ItemAction.pin,
                                      child: Row(
                                        children: [
                                          Icon(
                                            item.isPinned
                                                ? Icons.push_pin_rounded
                                                : Icons.push_pin_outlined,
                                            size: 18,
                                            color: colorScheme.primary,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            item.isPinned ? 'Unpin' : 'Pin',
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (item.isCustom) ...[
                                      PopupMenuItem<_ItemAction>(
                                        value: _ItemAction.edit,
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.edit_outlined,
                                              size: 18,
                                            ),
                                            SizedBox(width: 10),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<_ItemAction>(
                                        value: _ItemAction.delete,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              size: 18,
                                              color: colorScheme.error,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: colorScheme.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
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

class _DhikrEditorSheet extends StatefulWidget {
  const _DhikrEditorSheet({this.item, required this.onSave});

  final TasbihItem? item;
  final void Function(String label, String translit, String meaning) onSave;

  @override
  State<_DhikrEditorSheet> createState() => _DhikrEditorSheetState();
}

class _DhikrEditorSheetState extends State<_DhikrEditorSheet> {
  late final TextEditingController _arabicCtrl;
  late final TextEditingController _translitCtrl;
  late final TextEditingController _meaningCtrl;
  late final FocusNode _arabicFocus;
  late final FocusNode _translitFocus;
  late final FocusNode _meaningFocus;

  @override
  void initState() {
    super.initState();
    _arabicCtrl = TextEditingController(text: widget.item?.label ?? '');
    _translitCtrl =
        TextEditingController(text: widget.item?.transliteration ?? '');
    _meaningCtrl = TextEditingController(text: widget.item?.meaning ?? '');
    _arabicFocus = FocusNode();
    _translitFocus = FocusNode();
    _meaningFocus = FocusNode();
  }

  @override
  void dispose() {
    _arabicCtrl.dispose();
    _translitCtrl.dispose();
    _meaningCtrl.dispose();
    _arabicFocus.dispose();
    _translitFocus.dispose();
    _meaningFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // NOTE: viewInsetsOf is intentionally NOT called here. Calling it would
    // cause this widget (and its TextFields) to rebuild every time the keyboard
    // height changes, which breaks focus and makes the keyboard flicker when
    // switching fields. Instead, only the isolated _KeyboardSpacer leaf widget
    // below subscribes to viewInsets so TextFields are never touched.
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item == null
                ? l10n.tasbihAddCustomTitle
                : l10n.tasbihEditCustomTitle,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _arabicCtrl,
            focusNode: _arabicFocus,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _translitFocus.requestFocus(),
            decoration:
                InputDecoration(hintText: l10n.tasbihArabicOrDhikrHint),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: _translitCtrl,
            focusNode: _translitFocus,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _meaningFocus.requestFocus(),
            decoration: InputDecoration(
              hintText: l10n.tasbihTransliterationOptionalHint,
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: _meaningCtrl,
            focusNode: _meaningFocus,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            decoration:
                InputDecoration(hintText: l10n.tasbihMeaningOptionalHint),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    final label = _arabicCtrl.text.trim();
                    final translit = _translitCtrl.text.trim();
                    final meaning = _meaningCtrl.text.trim();
                    if (label.isEmpty && translit.isEmpty) return;
                    Navigator.of(context).pop();
                    widget.onSave(label, translit, meaning);
                  },
                  child: Text(l10n.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Moves the dialog above the keyboard by animating bottom padding.
enum _ItemAction { pin, edit, delete }

// Isolated so only this widget rebuilds on viewInsets changes —
// the TextFields inside the dialog are never touched.
class _KeyboardAwareDialogPadding extends StatelessWidget {
  const _KeyboardAwareDialogPadding({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottom),
      child: Center(child: child),
    );
  }
}
