import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

final matchingPageViewModelProvider = StateNotifierProvider(
  (ref) => MatchingPageViewModel(),
);

class MatchingTab {
  late final String tabName;
  late final Widget tabPage;

  MatchingTab({
    required this.tabName,
    required this.tabPage,
  });
}

class MatchingTabs {
  late final List<MatchingTab> tabs;

  MatchingTabs({required this.tabs});
}

class MatchingPageViewModel extends StateNotifier<MatchingTabs> {
  MatchingPageViewModel()
      : super(MatchingTabs(tabs: [
          MatchingTab(tabName: '電気使用量・料金', tabPage: Text('電気使用量・料金タブ')),
          MatchingTab(tabName: '利用明細', tabPage: Text('利用明細タブ')),
          MatchingTab(tabName: 'マッチング率', tabPage: Text('マッチング率タブ')),
        ]));
}

/// マイページ - マッチング
/// マッチング関連のタブを表示する
class MatchingPage extends StatelessWidget {
  final List<MatchingTab> tabs = [
    MatchingTab(tabName: '電気使用量・料金', tabPage: Text('電気使用量・料金タブ')),
    MatchingTab(tabName: '利用明細', tabPage: Text('利用明細タブ')),
    MatchingTab(tabName: 'マッチング率', tabPage: Text('マッチング率タブ')),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final viewModel = watch(matchingPageViewModelProvider);

        return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
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
                  children: tabs.map((tab) => tab.tabPage).toList(),
                )));
      },
    );
  }

  Widget _buildBackLeadingButton(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/images/common/leading_back.svg',
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
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFFF8C00),
          onPrimary: Color(0xFFFFFFFF),
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          print("ご契約内容の確認");
        },
      ),
    );
  }
}
