# 安全开发原则

本项目遵循“银行级资金保护”理念：

- 所有外部调用前更新状态（Checks-Effects-Interactions）
- 关键操作需权限控制（AccessControl）
- 支持紧急暂停（Pausable）
- 前端强制地址格式校验（42字符，0x开头）

> “代码即责任，非代码即法律。”
