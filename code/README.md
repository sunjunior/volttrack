# VoltTrack

VoltTrack 是两轮电动车充电记账与能耗分析应用：记录每次充电，估算电耗、成本、续航、电池健康度（SOH）与续航达成率，并内置充电方案费用对比计算器。数据全部本地化存储（SQLite），无需联网。

技术栈：Flutter 3.47.x / Dart 3.13、Riverpod 状态管理、Drift (SQLite) 本地存储、fl_chart 图表绘制。

## 功能清单

- **车辆建档**：品牌与型号必填，购入时间、初始里程（km）可选；建档后才能登记电池。
- **电池档案**：登记电池（铅酸 / 磷酸铁锂 / 三元锂，标称电压 V 与容量 Ah，可选填官方续航 km）；更换电池时旧电池自动停用（写入停用时间）并插入新电池，同一时刻只有一块当前生效电池。电池生效容量 = 容量覆盖值（仅数据层字段，无 UI 录入）或 标称电压 × 容量 / 1000。
- **充电记账**（三种模式）：
  - 按度数：直接输入 kWh，或 金额 ÷ 单价 推算；
  - 按时长：时长 × 功率推算 kWh（含充电效率 0.85），金额可选；
  - 插座：按起始/结束 SOC 差值推导 kWh（无 SOC 时可手输），金额可选。
  - 每条记录还可填写当前里程；度数来源（手动 / 金额÷单价 / 功率×时长 / SOC 差值推导）自动记录。
- **记录列表**：按时间列出全部充电记录，支持删除（需二次确认）。
- **概览页**：平均百公里电耗、每公里成本（二者均为全程距离加权均值）、预估续航、累计花费。
  - 预估续航口径：最近一次记录的充后 SOC × 生效容量 × 0.9 ÷ 百公里电耗；无充后 SOC 或无有效窗口时显示 `--`。
- **统计页**（仅基于当前生效电池，未登记电池时退化为全部记录）：
  - 电耗趋势折线图：窗口百公里电耗随里程变化，异常窗口（负耗电或 >6 kWh/100km）红点标注；
  - 电池健康度 SOH：依最近满电窗口估算——门槛为窗口起点充后 SOC ≥ 95 且充前 SOC ≤ 10，从最新窗口往回取第一个满足条件的窗口；SOH = 实际充入 kWh ÷（生效容量 × ΔSOC/100），上限 120%；
  - 续航达成率：满充窗口（起点充后 SOC ≥ 90 且终点充前 SOC ≤ 30）的平均实际续航 ÷ 官方续航，未填官方续航时显示 `--`。
- **费用计算器**：输入充入度数与两种方案单价（按时长档位 / 按度），实时对比单次花费与月度差额并高亮更省方案。
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
| theoretical_range_km | real? | 理论（官方）续航 |
| installed_at | datetime | 安装时间 |
| deactivated_at | datetime? | 停用时间 |
| active | bool | 是否当前生效 |

### charges（充电记录）

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| id | int (PK, 自增) | 主键 |
| battery_id | int (FK → batteries) | 充电所用电池 |
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
    battery_x.dart         # Battery 行类型扩展（生效容量、规格文案）
    database.dart          # 数据库初始化
    repository.dart        # 数据仓库（CRUD）
  features/
    shell.dart             # 底部导航外壳
    home/                  # 概览页
    charging/              # 充电记账（列表 + 表单 + 模式换算）
    stats/                 # 统计与图表
    calculator/            # 费用计算器
    vehicle/               # 车辆 / 电池档案
  shared/                  # 公共小部件
test/                      # 单元测试与 Widget 测试
```
