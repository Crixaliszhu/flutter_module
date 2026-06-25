# flutter_module

`FlutterHybridDemo` 中的 Flutter Module。对标 `easy_job_module`，但只保留演示混合架构必要的最少代码。

## 创建命令（仅供参考）

```sh
flutter create --template=module --org com.example flutter_module
```

本仓库已经包含了所需的 `pubspec.yaml` 与 `lib/`，第一次拉下来后只需：

```sh
cd flutter_module
flutter pub get
```

之后宿主就可以通过 `include_flutter.groovy` 把它当 Gradle 子工程引入。

## 目录说明

- `lib/main.dart` 入口，处理 Dart entrypoint args 与 `nativeParams` 路由协议。
- `lib/app/entry_args.dart` `EntryArgs` 数据模型，对齐原生侧 `FlutterArgsUtils.createEntryArgs`。
- `lib/routing/router.dart` 路由表与 `_onGenerateRoute`。
- `lib/pigeon/generated/` Pigeon 生成的强类型桥接代码。
- `lib/pigeon/` 基于生成代码的轻量封装与事件桥接。
- `lib/pages/` 演示页面。
- `pigeons/demo_bridge.dart` Pigeon 协议定义。
