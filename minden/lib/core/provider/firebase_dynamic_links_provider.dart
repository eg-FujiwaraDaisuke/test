// Package imports:
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/core/provider/package_info_provider.dart';

/// FirebaseDynamicLinksインスタンスを返す（ProviderScopeでoverride利用）
final dynamicLinksProvider =
    Provider<FirebaseDynamicLinks>((ref) => throw UnimplementedError());

/// アプリを起動するときのDynamicLinks情報を返す
/// DynamicLinks経由の起動でない場合、nullを返す
final pendingDynamicLinkData = FutureProvider<PendingDynamicLinkData?>(
    (ref) => ref.watch(dynamicLinksProvider).getInitialLink());

/// 任意のpathを開くための、DynamicLinkを生成して返す
final createDynamicLink = FutureProvider.family<Uri, String>((
  ref,
  path,
) {
  final dynamicLinks = ref.watch(dynamicLinksProvider);
  final packageInfo = ref.watch(packageInfoProvider);

  const uriPrefix = 'https://stgminden.page.link';

  final params = DynamicLinkParameters(
    // TODO: 環境別に設定する（Firebaseプロジェクトが単一の場合は不要）
    uriPrefix: uriPrefix,
    // TODO: 開きたいページのurlを設定する。Webページのドメイン + pathとするのがよさそう
    link: Uri.parse('$uriPrefix/$path'),
    androidParameters: AndroidParameters(
      packageName: packageInfo.packageName,
      minimumVersion: 3,
    ),
    iosParameters: IOSParameters(
      bundleId: packageInfo.packageName,
      minimumVersion: '3',
    ),
  );

  return dynamicLinks.buildShortLink(params).then((linkData) {
    return linkData.shortUrl;
  });
});
