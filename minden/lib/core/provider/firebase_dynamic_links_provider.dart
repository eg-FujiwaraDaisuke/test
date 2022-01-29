// Package imports:
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FirebaseDynamicLinksインスタンスを返す（ProviderScopeでoverride利用）
final dynamicLinksProvider =
    Provider<FirebaseDynamicLinks>((ref) => throw UnimplementedError());

/// アプリを起動するときのDynamicLinks情報を返す
/// DynamicLinks経由の起動でない場合、nullを返す
final pendingDynamicLinkData = FutureProvider<PendingDynamicLinkData?>(
    (ref) => ref.watch(dynamicLinksProvider).getInitialLink());
