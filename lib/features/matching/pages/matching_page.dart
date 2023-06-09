import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/matching/pages/matching_ratio_tab.dart';
import 'package:minden/features/matching/viewmodel/matching_page_view_model.dart';
import 'package:minden/gen/assets.gen.dart';

final matchingPageViewModelProvider =
    StateNotifierProvider<MatchingPageViewModel, MatchingPageState>(
        (ref) => MatchingPageViewModel());

class MatchingTabData {
  MatchingTabData({
    required this.tabName,
    required this.tabPage,
  });

  late final String tabName;
  late final WidgetBuilder tabPage;
}

/// マイページ - マッチング
/// マッチング関連のタブを表示する
class MatchingPage extends StatelessWidget {
  static const String routeName = '/my_page/matching';

  final List<MatchingTabData> tabs = [
    MatchingTabData(tabName: '電気使用量・料金', tabPage: (_) => Text('電気使用量・料金タブ')),
    MatchingTabData(tabName: '利用明細', tabPage: (_) => Text('利用明細タブ')),
    MatchingTabData(tabName: 'マッチング率', tabPage: (_) => MatchingRatioTab()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: _buildBackLeadingButton(context),
          actions: [_buildActionConfirmContract(context)],
          bottom: TabBar(
            isScrollable: false,
            tabs: tabs
                .map((tab) => Text(
                      tab.tabName,
                      textAlign: TextAlign.center,
                    ))
                .toList(),
          ),
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          children: tabs.map((tab) => tab.tabPage(context)).toList(),
        ),
      ),
    );
  }

  Widget _buildBackLeadingButton(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        Assets.images.common.leadingBack,
        width: 44,
        height: 44,
      ),
      onPressed: () => Navigator.pop(context),
      color: Colors.black,
    );
  }

  Widget _buildActionConfirmContract(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      // 影を付けたくないため、ElevatedButtonではなくTextButtonを使用
      child: TextButton(
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFFF8C00),
          onPrimary: Color(0xFFFFFFFF),
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          logD('ご契約内容の確認');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: const Text(
            'ご契約内容の確認',
            style: TextStyle(
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
