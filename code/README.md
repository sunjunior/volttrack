# VoltTrack

VoltTrack 是两轮电动车充电记账与能耗分析应用：记录每次充电，估算电耗、成本、续航、电池健康度（SOH）与续航达成率，并内置充电方案费用对比计算器。数据全部本地化存储（SQLite），无需联网。

技术栈：Flutter 3.47.x / Dart 3.13、Riverpod 状态管理、Drift (SQLite) 本地存储、fl_chart 图表绘制。

## 功能清单

- **车辆与电池档案**：维护车辆信息（品牌/型号/里程/SOC），登记多组电池（铅酸 / 磷酸铁锂 / 三元锂），自动换算电池容量（`voltage × capacity / 1000`），支持容量与理论续航覆盖。
- **充电记账**（三种模式）：
  - 按度数（kWh）记账；
  - 按充电时长记账，实时预览推算度数；
  - 家充插座匀速计费。
  - 每个记录记录充电来源（手动输入 / 金额÷单价 / 功率×时长 / 按 SOC 差值推导）、金额、起始/结束 SOC、当前里程与备注。
- **概览页**：汇总最近一次充电、累计度数/花费、总里程与当前 SOC。
- **统计页**：历史充电趋势与能耗、成本分析，估算单公里电耗与综合续航，计算电池 SOH 与续航达成率。
- **费用计算器**：输入度数与两种充电单价，对比两套方案总花费并高亮更省方案。
- **本地存储**：SQLite（Drift），所有数据仅保存在本机。

## 运行与测试

```bash
## 依赖安装
flutter pub get

## 静态分析（要求 0 issues）
flutter analyze

## 全量测试
flutter test

## 构建调试 APK
flutter build apk --debug
# 产物：build/app/outputs/flutter-apk/app-debug.apk

## 运行（需连接设备/模拟器）
flutter run
```

## 数据表结构

数据库由 Drift 定义在 `lib/data/tables.dart`（`AppDatabase`，schema v1），共三张表：

### vehicles（车辆）

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| id | int (PK, 自增) | 主键 |
| brand | text | 品牌 |
| model | text | 型号 |
| purchase_date | datetime? | 购车日期 |
| initial_mileage_km | real | 初始里程 |
| initial_soc_pct | int? | 初始 SOC |
| note | text? | 备注 |

### batteries（电池）

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| id | int (PK, 自增) | 主键 |
| vehicle_id | int (FK → vehicles) | 所属车辆 |
| name | text | 电池名称 |
| type | text (enum) | `leadAcid` / `lifepo4` / `ternaryLithium` |
| voltage_v | real | 标称电压 |
| capacity_ah | real | 标称容量 |
| override_capacity_kwh | real? | 容量覆盖值 |
| theoretical_range_km | real? | 理论续航 |
| installed_at | datetime | 安装时间 |
| deactivated_at | datetime? | 停用时间 |
| active | bool | 是否当前使用 |

### charges（充电记录）

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| id | int (PK, 自增) | 主键 |
| battery_id | int (FK → batteries) | 充电所用电瓶 |
| occurred_at | datetime | 充电发生时间 |
| mode | text (enum) | `byKwh` / `byTime` / `homeOutlet` |
| energy_kwh | real | 充入电量（度） |
| energy_source | text (enum) | `manual` / `amountOverUnitPrice` / `powerTimesHours` / `socDerived` |
| money_yuan | real? | 花费金额 |
| hours | real? | 充电时长 |
| charger_power_w | real? | 充电器功率 |
| price_desc | text? | 价格说明 |
| soc_before_pct | int? | 充电前 SOC |
| soc_after_pct | int? | 充电后 SOC |
| mileage_km | real? | 当前里程 |
| note | text? | 备注 |

## 目录结构

```
lib/
  app.dart                 # 应用入口与主题
  main.dart                # main 函数
  core/
    engine/                # 领域计算：电耗、续航、SOH、达成率、费用对比
    models/                # Vehicle / Battery / ChargeRecord 及枚举
  data/
    tables.dart            # Drift 表定义（vehicles / batteries / charges）
    database.dart          # 数据库初始化
    repository.dart        # 数据仓库（CRUD）
  features/
    shell.dart             # 底部导航外壳
    home/                  # 概览页
    charging/              # 充电记账（表单 + 模式换算）
    stats/                 # 统计与图表
    calculator/            # 费用计算器
    vehicle/               # 车辆 / 电池档案
  shared/                  # 公共小部件
test/                      # 单元测试与 Widget 测试（39 个用例）
```