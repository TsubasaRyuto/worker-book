# WorkerBook README（ボツサービス）
========================

## 必須環境
* Ruby2.3.1 ※プロジェクトの進行中にバージョンを上げる可能性あり
* Gem 2.5.1
* MySQL >=5.6.x
* PhantomJS 最新版
* JS=>CoffeeScript、CSS=>SCSS、テンプレート=>ERB

## gitの運用ルール
リポジトリ共有式のPull Request方式を採用します。
http://blog.qnyp.com/2013/05/28/pull-request-for-github-beginners/
開発統合リポジトリは**develop**

かんたんにいうと、以下の手順です。

1. 各自作業テーマごとに作業ブランチを切って開発。
2. 開発がおわったら、developを最新化して差分があれば作業ブランチにマージして再度テスト
3. テストがとおったらリモートブランチにpush
4. developに対してpull request

## コーディングに関しての留意事項
本プロジェクトでは[Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide) をベースに調整した規約を摘要

### rubocop
コーディングチェックにはrubocopを採用する。

```
  bundle exec rubocop
```
で規約違反部分が検知

```
  bundle exec rubocop -a
```
で、規約違反を自動修正する。

## テストについて
* テストコードはRspecで記述する
* 画面系のテストはcapybaraを使用する
* fixtureにはFactoryGirlを使用する
* 各モデルのfactoryにはバリデーションを通る最低限のカラムをモデルと同名で定義する

## 環境構築手順（テストパス）
1. MySQLサーバをインストール
2. /usr/local/etc/my.cnfに後述の設定を追加（ファイルが存在していなければ新規作成）してMySQLを再起動（＊2）
3. databaseとユーザーを作る（＊1のコマンド）
4. bitbucketからclone ( git clone git@bitbucket.org:loboinc/worker-book.git)
5. bundle install --path vendor/bundle
6. config/database.yml.sampleをコピペしてdatabase.ymlを作成
7. config/secrets.yml.sampleをコピペしてsecrets.ymlを作成
8. bundle exec rake db:migrate
9. bin/rspec

*1 my.cnf追記内容
```
  [mysqld]
  innodb_ft_min_token_size = 1
```

*2 database作成コマンド
  create database mynavicms_development character set utf8 collate utf8_general_ci;
  create database mynavicms_test character set utf8 collate utf8_general_ci;
  create user 'mynavi'@'localhost' identified by 'mynavi';
  grant all on mynavicms_development.* to mynavi;
  grant all on mynavicms_test.* to mynavi;
