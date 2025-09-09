import 'package:flutter/material.dart';
import 'package:flutter_mysale/features/main_app/utils/helpers.dart';

abstract class FilterItem {
  String getTitle();
}

class FilterBar<T extends FilterItem> extends StatelessWidget {
  final String? title;
  final List<T> filters;
  final void Function(T, int)? onTap;

  const FilterBar({super.key, this.title, required this.filters, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_createTitle(), _createListView(context)],
    );
  }

  Widget _createTitle() {
    if (title != null && title!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
        child: Text(
          title ?? '',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _createListView(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          T item = filters[index];
          return _createChip(context, item.getTitle(), () {
            onTap?.call(item, index);
          });
        },
        separatorBuilder: (ctx, index) {
          return const SizedBox(width: 8);
        },
        itemCount: filters.length,
      ),
    );
  }

  Widget _createChip(BuildContext context, String title, VoidCallback? onTap) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: InputChip(
        label: Text(title),
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        onPressed: onTap,
        onDeleted: onTap,
        deleteIcon: const Icon(Icons.close, size: 16),
        deleteIconColor: Colors.black,
        backgroundColor: '#EFF5FF'.toColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: "#CCA68B".toColor() ?? Colors.transparent),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      ),
    );
  }
}
