// Package imports:
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/core/env/config.dart';
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/core/provider/package_info_provider.dart';

/// みんな電力Webページのドメイン
const String mindenDomain = 'https://portal.minden.co.jp';

/// FirebaseDynamicLinksインスタンスを返す（ProviderScopeでoverride利用）
final dynamicLinksProvider =
    Provider<FirebaseDynamicLinks>((ref) => throw UnimplementedError());

/// アプリを起動するときのDynamicLinks情報を返す
/// DynamicLinks経由の起動でない場合、nullを返す
final pendingDynamicLink = FutureProvider<PendingDynamicLinkData?>(
    (ref) => ref.watch(dynamicLinksProvider).getInitialLink());

/// アプリを起動するときのDynamicLinks情報をStream型で返す
/// DynamicLinks経由の起動でない場合、nullを返す
final pendingDynamicLinkStream = StreamProvider<PendingDynamicLinkData?>(
    (ref) => ref.watch(dynamicLinksProvider).onLink);

/// 任意のpathを開くための、DynamicLinkを生成して返す
final createDynamicLink = FutureProvider.family<Uri, String>((
  ref,
  path,
) {
  final dynamicLinks = ref.watch(dynamicLinksProvider);
  final packageInfo = ref.watch(packageInfoProvider);
  // 環境によって利用するFirebaseプロジェクトが異なるため、uriPrefixも異なる
  final uriPrefix = Config.getDynamicLinksDomainByEnvironment();

  final params = DynamicLinkParameters(
    uriPrefix: uriPrefix,
    link: Uri.parse('$mindenDomain/$path'),
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
    logD('Create DynamicLinks. Preview: ${linkData.previewLink}');
    return linkData.shortUrl;
  });
});
