import 'package:flutter/material.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';

import 'important_tags.dart';

class TagListItem extends StatefulWidget {
  TagListItem({
    required this.tag,
    required this.onSelect,
    required this.isSelected,
  }) : super();
  final Tag tag;
  final Function onSelect;
  final bool isSelected;

  @override
  _TagListItemState createState() => _TagListItemState();
}

class _TagListItemState extends State<TagListItem> {
  @override
  Widget build(BuildContext context) {
    final selectedColor = _getColor(widget.tag);
    return GestureDetector(
      onTap: () {
        widget.onSelect(widget.tag);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color:
                const Color(0xFFE2E2E2).withOpacity(widget.isSelected ? 0 : 1),
          ),
          color: widget.isSelected ? selectedColor : Colors.white,
        ),
        child: Text(
          '#${widget.tag.tagName}',
          style: TextStyle(
            color: widget.isSelected
                ? const Color(0xFF575292)
                : const Color(0xFF787877),
            fontSize: 14,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Color _getColor(Tag tag) {
    ImportantTag? contain;
    importantTags.forEach((importantTag) {
      final isExist = importantTag.tags.contains(tag);
      if (isExist) contain = importantTag;
    });
    return contain?.color ?? const Color(0xFFFFC2BE);
  }
}
