# README

## 概要
google spreadsheetのデータを読み込んで、レシピサイトっぽい手順書を表示するwebアプリ

## 環境
* rails 6.1 rc1
* docker

## 開発環境の起動
* google spreadsheet apiにアクセスできるapi keyを取得して`.env` ファイルに記述します。

```aidl
GOOGLE_API_KEY=YOURAPIKEY
```

下記のコマンドで開発環境を起動します。

```
docker-compose build
docker-compose up -d
docker-compose exec web bundle install
docker-compose exec web rails db:create
```

下記にアクセスしてください。

http://localhost:3000


## 使い方
こちらを参照してください。

https://iprotocol.herokuapp.com/?google_spreadsheet_id=1lx_9I5JfktHGw2WTvjpPGGWLSmP0lfJcOWZstHmlPS4

