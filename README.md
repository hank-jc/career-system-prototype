# 職業系統 Prototype

這是一份用來確認職業系統規則、玩家流程與 UI 資訊層級的互動 Prototype。

## 快速入口

- [開啟互動 Demo](https://hank-jc.github.io/career-system-prototype/)
- [完整職業系統規格](./職業系統規格.md)
- [遊戲設計 Review 摘要](./職業系統設計Review版.md)
- [UI／UX Review](./職業系統UIUX%20Review版.md)
- [美術定版畫面需求](./職業系統美術定版UIUX說明.md)

## 文件優先順序

`職業系統規格.md` 是唯一完整規格。Demo 與其他文件分別服務流程、設計 Review 與美術交付；內容不同時以完整規格為準。

## 目前系統摘要

- 職業位於 Upgrades 第一個頁籤。
- Lv.2 預覽、Lv.5 首次選擇；第一優先 A/B 比較提前預覽與直接開放。
- 三條職業線共用四階職業進度。
- 主頁固定顯示五個被動槽；第一至四階各開一槽，第五槽本版鎖定。
- 每槽三個候選；解鎖次數全職業共用，各職業配置獨立保存。
- 職業免費切換。
- 職業不影響裝備掉落、武器限制、戰鬥外觀或近戰／遠程判定。

技能名稱、數值與 Prototype 圖示皆為流程佔位，不代表正式內容。

## 重新產生 Demo 截圖

在 Windows PowerShell 執行：

```powershell
.\capture-demo.ps1
```

腳本輸出 1080×1920 的流程截圖，並支援 `preview`、`pick`、`main`、`passive`、`evolve`、`switch` 等場景。

## 使用說明

本 repo 供 Prototype 展示、規格整理與設計 Review，目前未提供開放原始碼授權。
