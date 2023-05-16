.PHONY: setup
setup:
	flutter clean
	flutter pub get

flutter_gen:
	flutter clean
	flutter pub get
	# font i18n 生成コマンド
	flutter packages run build_runner build --delete-conflicting-outputs
	# flutter_launcher_icons生成コマンド
	flutter pub run flutter_launcher_icons

build_ios:
	flutter clean
	flutter pub get
	#Xcodeを開く
	open ios/Runner.xcworkspace
	flutter build ios --flavor prod

build_aab:
	flutter clean
	flutter pub get
	#AndroidのBundleを生成する
	flutter build appbundle --flavor prod