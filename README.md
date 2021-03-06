# カムログ

## サイト概要

神社の参拝記録を共有できる[サイト](https://kamulog.work/)です。登録された神社を検索して調べたり参拝した記録を投稿することができます。
また自分の投稿を一覧としてみれるので参拝記録としても使えます。<br>
他にタグや祭神などを検索ワードをスペースで区切ることで複数条件検索や絞り込み検索を行うことができ、自分にあった神社を探すことができます。
<br>
また、レスポンシブ対応しているのでスマートフォンからもご覧になることができます。

### サイトテーマ

神社を検索・魅力を共有できるサイト

### テーマを選んだ理由

昔から信じられてきた神と触れ合うことのできるところが神社という場所です。ですが神社というと堅苦しいイメージや初詣にいく所というイメージがあるため身近に感じづらい所だと思います。
そういった人たちにも神社の魅力を知ってもらい参拝してもらいたいと思いました。<br>
また意外と神社の情報がまとめられているサイトが少ないと思い、自分の行きたい条件で絞り込んだり地域で探すことができればより便利だと考えてこのサイトを作りました。

### ターゲットユーザ

- 神社に興味のある人
- 旅行の好きな人

### 主な利用シーン

- 参拝記録をつけたい時
- 神社の魅力を広めたい時
- 自分の好みの神社を探す時
- 旅行先の地域の神社を検索する時

## 設計書

- ER図は[こちら](https://app.diagrams.net/#G1uRzK2DnQTD5jFAyO-3V-AFTyq5HuPjns)
- テーブル定義書は[こちら](https://docs.google.com/spreadsheets/d/1kXijU_LJGV37g3FAqLibbZIgqlbEcTfK7SA6ixmzj8w/edit?usp=sharing)
- 詳細設計は[こちら](https://docs.google.com/spreadsheets/d/175DfXX7WNZVmQWE8exeQ8gM04tY8oUzKX_t54QA1ph8/edit#gid=2133469642)

## チャレンジ要素一覧

[こちら](https://docs.google.com/spreadsheets/d/1uoir5MDhX7go7nGcF8-9XEk_jRZC2F4Ux4tzTZvyF0o/edit?usp=sharing)からご覧ください

## 開発環境

- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JS ライブラリ：jQuery
- IDE：Cloud9
- AWS
  - EC2
  - RDS
  - Route 53

## 機能一覧
- ユーザ登録・ログイン機能(devise)
- 複数画像投稿機能(refile)
- フォロー機能(Ajax)
- ブックマーク機能(Ajax)
- 検索機能(OR検索)
- ページネーション(kaminari)
- 地図表示(geocoder)
- パンくずリスト(gretel)

## 使用素材

- 写真AC
- イラストAC
- Subtle Patterns
