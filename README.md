# VoltTrack

电动自行车电耗记账 App —— 类似「小熊油耗」，但为电驴设计。记录每一次充电，自动算清百公里电耗、每公里成本、续航预测与电池健康度（SOH）。

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B) ![License](https://img.shields.io/badge/License-MIT-green) ![Version](https://img.shields.io/badge/version-v0.1-blue)

## 功能特性

- **车辆与电池档案**：车辆信息建档，电池组登记与更换管理（同一时刻只有一块「生效电池」，历史自动停用留档）
- **三种模式记账**：
  - 按度/金额：手输度数，或 金额 ÷ 单价 推算
  - 按时长（小区桩）：功率 × 时长 × 充电效率（默认 0.85）推算
  - 家用插座：按前后 SOC 差值反推，或手输估算
- **电耗分析**：基于「里程锚点窗口 + ΔSOC 校正」算法计算百公里电耗与每公里成本，fl_chart 趋势图，异常窗口红点标注
- **电池健康**：SOH 估算（仅取低电量→满充的完整充电事件）、满充续航达成率
- **续航预测**：当前 SOC × 容量 × 安全系数 ÷ 加权平均电耗
- **费用计算器**：对比「按时长档位」与「按度计费」两种充电方案，算单次差额与月度差额
- **纯本地存储**：SQLite（drift），数据不出设备

## 算法一瞥

相邻两条带里程的充电记录构成一个「窗口」，区间内骑行耗电扣除 SOC 变化对应的电池存量：

```
E_ride = Σ窗口内充入度数 − C × (SOC_B到达 − SOC_A到达)
百公里电耗 = E_ride / 距离 × 100
```

样例：48V20Ah 电池（0.96 kWh）充 0.72 度（SOC 30%→100%），骑 60 km 后剩 45%
→ E_ride = 0.72 − 0.96×0.15 = 0.576 kWh，百公里电耗 **0.96 kWh/100km**。

完整口径与边界约定见[设计文档](docs/superpowers/specs/2026-08-29-volttrack-ebike-app-design.md)。

## 构建

```bash
cd code
flutter pub get
flutter test          # 55 个测试
flutter build apk --release --split-per-abi   # arm64 包约 20MB
```

正式签名配置见 [code/README.md](code/README.md)（keystore 不入库）。

## 项目结构

```
code/lib/
├── core/models/    # 领域模型与枚举
├── core/engine/    # 纯函数计算引擎（TDD 主战场）
├── data/           # drift 表定义、Repository、Riverpod providers
├── features/       # 页面 UI（home/charging/stats/vehicle/calculator）
└── shared/         # 通用组件
docs/               # 设计文档与实现计划
```

- 技术栈：Flutter · Riverpod · drift(SQLite) · fl_chart
- 架构：纯函数计算引擎与 UI/存储解耦，数据层走 drift 响应式流

## 下载

前往 [Releases](https://github.com/sunjunior/volttrack/releases) 下载已签名的 APK（推荐 `arm64-v8a`，兼容绝大多数近年在售机型）。

## License

[MIT](LICENSE)
