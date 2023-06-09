import 'package:flutter/material.dart';
import 'package:minden/core/util/color_code_util.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/gen/fonts.gen.dart';

class TagListItem extends StatefulWidget {
  const TagListItem({
    required this.tag,
    required this.onSelect,
    required this.isSelected,
  }) : super();
  final Tag? tag;
  final Function onSelect;
  final bool isSelected;

  @override
  _TagListItemState createState() => _TagListItemState();
}

class _TagListItemState extends State<TagListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelect(widget.tag);
      },
      child: _buildItem(),
    );
  }

  Widget _buildItem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE2E2E2).withOpacity(widget.isSelected ? 0 : 1),
        ),
        color: widget.isSelected ? _getColor(widget.tag) : Colors.white,
      ),
      child: Text(
        '#${widget.tag?.tagName ?? ''}',
        style: TextStyle(
          color: widget.isSelected
              ? const Color(0xFF575292)
              : const Color(0xFF787877),
          fontSize: 14,
          fontFamily: FontFamily.notoSansJP,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Color _getColor(Tag? tag) {
    return getColorFromCode(tag?.colorCode ?? '1');
  }
}
