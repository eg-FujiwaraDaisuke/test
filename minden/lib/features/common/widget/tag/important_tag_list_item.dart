import 'package:flutter/material.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

import 'important_tags.dart';

class ImportantTagListItem extends StatefulWidget {
  final Tag tag;
  final Function onSelect;
  final bool isSelected;

  ImportantTagListItem({
    required this.tag,
    required this.onSelect,
    required this.isSelected,
  }) : super();

  @override
  _ImportantTagListItemState createState() => _ImportantTagListItemState();
}

class _ImportantTagListItemState extends State<ImportantTagListItem> {
  @override
  Widget build(BuildContext context) {
    final Color selectedColor = _getColor(widget.tag);
    return GestureDetector(
      onTap: () {
        widget.onSelect(widget.tag);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: Color(0xFFE2E2E2).withOpacity(widget.isSelected ? 0 : 1),
            width: 1,
          ),
          color: widget.isSelected ? selectedColor : Colors.white,
        ),
        child: Text(
          '#${widget.tag.tagName}',
          style: TextStyle(
            color: widget.isSelected ? Color(0xFF575292) : Color(0xFF787877),
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
      bool isExist = importantTag.tags.contains(tag);
      if (isExist) contain = importantTag;
    });
    return contain!.color;
  }
}
