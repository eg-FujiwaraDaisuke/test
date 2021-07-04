import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  title: const Text('test'),
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
}
