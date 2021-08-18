# Localization Script

各言語に対応する文言のデータを、スプレッドシートから取得するスクリプトです。

- [みんな電力ローカライズテキストシート](https://docs.google.com/spreadsheets/d/1q-Rj5CO6Da-NZAjeSJWpvuwzKWwZXEtVM65NlhBo_nk/edit?usp=sharing)


## How To Use

- [credentials.json](https://drive.google.com/file/d/1Im_Ua7uY2Ug3yoKgEsEf0Cv0YK8mYg7j/view?usp=sharing)ファイルを実行ディレクトリに配置してください。

```
# 依存ライブラリのインストール
npm install

# tokenを作成
npx google-auth-token-generator

? Which one do you use?
  GoogleDrive
  Gmail
  GoogleCalendar
  Youtube
❯ GoogleSheets

----

? Select Permissions (see: https://developers.google.com/sheets/api/guides/authorizing?authuser=1)
❯◉ https://www.googleapis.com/auth/spreadsheets.readonly
 ◯ https://www.googleapis.com/auth/spreadsheets
 ◯ https://www.googleapis.com/auth/drive.readonly
 ◯ https://www.googleapis.com/auth/drive.file
 ◯ https://www.googleapis.com/auth/drive

oauth URLに遷移してcodeを貼り付けて下さい

Authorize this app by visiting this url: <https://accounts.google.com/o/oauth2/v2/xxxxxx このURLに遷移してOAuth認可を得る>
? Enter the code from that page here: <ここにはりつけ>

# 実行
node .
```

## Placeholder

| シート上 | dart |
|----------|---------|
| {str}  | %s      |
| {num}  | %d      |
