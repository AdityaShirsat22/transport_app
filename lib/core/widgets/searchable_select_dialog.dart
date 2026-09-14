import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'responsive_layout.dart';

class SearchableSelectItem<T> {
  final T value;
  final String title;
  final String? subtitle;

  const SearchableSelectItem({
    required this.value,
    required this.title,
    this.subtitle,
  });
}

class SearchableSelectField<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final String? selectedDisplay;
  final List<SearchableSelectItem<T>> items;
  final void Function(T selectedValue) onSelected;
  final bool isRequired;
  final String? Function(String?)? validator;

  const SearchableSelectField({
    super.key,
    required this.label,
    this.hint,
    required this.value,
    required this.selectedDisplay,
    required this.items,
    required this.onSelected,
    this.isRequired = false,
    this.validator,
  });

  void _showSelection(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheetCtx) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
            child: SizedBox(
              height: MediaQuery.of(sheetCtx).size.height * 0.75,
              child: _SearchSelectContent<T>(
                title: label,
                items: items,
                selectedValue: value,
                onSelected: (val) {
                  onSelected(val);
                  Navigator.of(sheetCtx).pop();
                },
              ),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (dialogCtx) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480, maxHeight: 540),
              child: _SearchSelectContent<T>(
                title: label,
                items: items,
                selectedValue: value,
                onSelected: (val) {
                  onSelected(val);
                  Navigator.of(dialogCtx).pop();
                },
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _showSelection(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDisplay ?? hint ?? 'Select $label...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: selectedDisplay != null
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchSelectContent<T> extends StatefulWidget {
  final String title;
  final List<SearchableSelectItem<T>> items;
  final T? selectedValue;
  final void Function(T) onSelected;

  const _SearchSelectContent({
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  State<_SearchSelectContent<T>> createState() => _SearchSelectContentState<T>();
}

class _SearchSelectContentState<T> extends State<_SearchSelectContent<T>> {
  late List<SearchableSelectItem<T>> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filtered = widget.items;
      } else {
        _filtered = widget.items
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()) ||
                (item.subtitle?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select ${widget.title}',
                style: AppTextStyles.headingSmall,
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            autofocus: false,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search, size: 18),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: AppColors.surfaceMuted,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text(
                      'No matching items found',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filtered.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _filtered[index];
                      final isSelected = item.value == widget.selectedValue;
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        title: Text(
                          item.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? AppColors.accent : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: item.subtitle != null
                            ? Text(item.subtitle!, style: AppTextStyles.bodySmall)
                            : null,
                        trailing: isSelected
                            ? const Icon(Icons.check, color: AppColors.accent, size: 18)
                            : null,
                        onTap: () => widget.onSelected(item.value),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
