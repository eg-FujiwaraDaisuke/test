# Localization Script

各言語に対応する文言のデータを、スプレッドシートから取得するスクリプトです。

- [みんな電力ローカライズテキストシート](https://docs.google.com/spreadsheets/d/1q-Rj5CO6Da-NZAjeSJWpvuwzKWwZXEtVM65NlhBo_nk/edit?usp=sharing)


## How To Use

- [key.pem](https://drive.google.com/file/d/14xdVgWvH3xyvowOR3gHScTZI7pPsb_WD/view?usp=sharing)ファイルを実行ディレクトリに配置してください。

```
# 依存ライブラリのインストール
npm install

# patchをあてる
cp sheet_loader_index.js.patch node_modules/sheet-loader/index.js

# 実行
node .
```

## Placeholder

| シート上 | dart |
|----------|---------|
| {str}  | %s      |
| {num}  | %d      |
