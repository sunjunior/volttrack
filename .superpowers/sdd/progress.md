# VoltTrack MVP 子代理驱动进度账本

（恢复地图：只认本账本与 git log。原账本于 2026-08-30 被修复子代理误删，本文件为依据会话记录重建。）

## 分支与基线
- 分支：feature/volttrack-mvp（自 c8cc012 起）
- main 基线：3e88506（计划+规格）
- 任务 0-14 全部完成并通过任务级审查（每个任务 RED→GREEN + 审查 + 必要修复）

## 任务完成记录（提交区间，审查结论）
- 任务 0 脚手架：8616387 ✅
- 任务 1 领域模型：b477f2c ✅（minor: EOF 换行）
- 任务 2 度数推算：62e7acf ✅（minor: 守卫边界/EOF）
- 任务 3 里程窗口：12ac571 + fix 98855bc ✅（unusual 测试缺口已补，变异验证）
- 任务 4 聚合统计：74e88d4 + fix ef58613 ✅（加权口径/窗口注入/窗外记录测试补齐，变异验证）
- 任务 5 SOH/达成率：e29734c ✅（minor: null 分支覆盖）
- 任务 6 计算器纯函数：d923892 ✅（costByKwh 为命名参数——下游必须命名调用；minor: cheapestOption 空表）
- 任务 7 drift 数据层：d908ffc ✅（适配：BatteryRow→Battery、AsyncValue.guard→try/catch；minor: activeBattery 无排序、deleteCharge 无测试）
- 任务 8 应用骨架：a075205 ✅（简报缺 shell import 已收敛；minor: FAB 入口缺失→任务13补）
- 任务 9 首页概览：c3b5893 ✅（drift Timer：测试体内 await db.close()；minor: _Overview 死字段）
- 任务 10 记账表单：916ed53 + fix 78e241d ✅（幻影电池/校验耦合已修：无电池/无来源拒存）
- 任务 11 统计页：01b4ced ✅（shell_test 同步 LineChart+override；minor: _SohCard「最近」实取最早）
- 任务 12 车辆档案：daa5983 ✅（minor: 无事务/vehicleId 硬编码/helper 重复）
- 任务 13 计算器页：033e5ee ✅（FAB 已补）
- 任务 14 集成收尾：0ea9beb ✅（39/39、analyze 0、APK debug 构建成功 160MB；sqlite3 hook 需预热缓存）

## 最终宽范围审查（3e88506..0ea9beb）
结论：**需要修复后合并**
- 关键：M2 记录日志缺失（列表/删除）、M1 车辆建档缺失+vehicleId:1
- 重要：续航预测恒空、按时长/插座无金额、换电池未按 batteryId 过滤窗口、SOH 满充门槛、首页空态判据、容量公式 5 处重复+core 模型死代码
- 次要 triage：EOF 换行（批量补）、事务包裹（随关键修复）、helper 重复、_SohCard 文案、死字段、cheapestOption 空表（不可达，跳过）、activeBattery 排序（跳过）、byKwh 金额残留（跳过）、intl 未使用、「最近百公里电耗」命名不实、README 漂移、widget_test 占位

## 修复批次 A（功能缺口）——已完成
df82d1f A1 记录列表+删除 / b117766 A2 车辆建档+vehicleId 真实化 / 127d6c9 A3 续航预测接线 / 223bbef A4 可选金额 / 2a5079f A5 按电池过滤 / 3598a59 A6 SOH 门槛 / c20261f A7 首页空态判据
52/52 测试，analyze 0。
⚠️ 事故：修复子代理误删 .superpowers（未跟踪产物丢失，账本已重建；代码/提交不受影响）

## 待办
- 修复批次 B（收敛与清理）：容量公式收敛为 Battery extension、停旧+插新包事务、EOF 换行批量、_SohCard 取最近、死字段删除、intl 移除、首页卡命名、README 校正、删除占位冒烟测试
- 批次 B 后：复审修复提交（0ea9beb..HEAD）
- 然后：finishing-a-development-branch（合并/PR/清理选项交用户）
