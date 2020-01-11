# Architecture-Sample01

## bundle install

```
$ bundle install
```

## podの利用方法
bundle経由でpodを利用する
```
$ bundle exec pod --version
```

`bundle exec pod update`は`Podfile.lock`を無視してしまうので`bundle exec pod install`で行うこと

## pod install

```
$ bundle exec pod install
```

## R.swift

⌘B でプロジェクトをビルドし、「$SRCROOT(通常はプロジェクトのルートフォルダ)」に「R.generated.swift」が生成されたら、プロジェクトにドラッグ&ドロップします。
※[Copy items if needed]チェックをOFF！
