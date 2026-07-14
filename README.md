# 職業系統 Prototype

這是一份用來討論職業系統核心流程與 UI 資訊層級的互動 Prototype。

## 快速入口

- [開啟互動 Demo](https://hank-jc.github.io/career-system-prototype/)
- [閱讀設計 Review 文件](./職業系統設計Review版.md)

## 目前涵蓋範圍

- Upgrades 頁中的「職業」分頁
- 三條職業線與五階共用職業階級
- 職業升階預覽
- 被動技能槽與三選一
- 切換職業與切換前預覽
- 全職業共用的職業精通

目前技能名稱、數值與美術皆為流程佔位，不代表正式內容定案。

## 畫面預覽

![職業主頁](./demo-screenshots/01-main.png)

## 重新產生 Demo 截圖

在 Windows PowerShell 執行：

```powershell
.\capture-demo.ps1
```

腳本會將五個關鍵流程畫面輸出至 `demo-screenshots/`，尺寸為 1080×1920。

## 使用說明

本 repo 僅供 Prototype 展示與設計討論，目前未提供開放原始碼授權。
