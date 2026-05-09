# 📊 Portfolio Risk Dashboard

個人投資組合風控與即時觀點儀表板（互動版 v2）。整合台股 + 美股部位，提供 Investment Memo、族群佔比、集中度警示、壓力測試、催化劑日曆等功能。

## ✨ 功能特色

- **可編輯持股表格**：股數、成本、現價、匯率、現金皆可即時修改，所有圖表/風控數字自動同步
- **新增 / 刪除股票**：支援台股與美股，可動態調整 watchlist
- **localStorage 儲存**：設定保存在瀏覽器，下次開啟自動還原
- **族群佔比圓餅圖**：個股佔資產比 + 產業/族群佔股票部位比
- **集中度警戒線**：10% / 30% 雙重警示
- **動態警報**：根據持股自動產生集中度、虧損、催化劑警報
- **壓力測試**：5 種情境（樂觀 +30% / 持平 / FOMC -15% / Capex 雜訊 -30% / 黑天鵝 -50%）
- **催化劑日曆**：30 天內法說 / 央行決策 / 重大事件
- **匯出 JSON**：可備份目前所有設定

## 📦 內含個股

### 持股（5 檔）
| 市場 | 代號 | 名稱 | 族群 |
|---|---|---|---|
| 台股 | 2327 | 國巨* | MLCC 被動元件 |
| 美股 | NVDA | Nvidia | AI GPU |
| 美股 | NET | Cloudflare | 邊緣運算/SaaS |
| 美股 | LITE | Lumentum | 光通訊/AI 光元件 |
| 美股 | SNDK | SanDisk | NAND Flash |

### Watchlist（3 檔記憶體）
| 市場 | 代號 | 名稱 | 族群 |
|---|---|---|---|
| 台股 | 2408 | 南亞科 | DRAM |
| 台股 | 2344 | 華邦電 | 利基型 NOR + DRAM |
| 台股 | 2337 | 旺宏 | NOR Flash + Mask ROM |

## 🚀 使用方式

### 本機開啟
直接用瀏覽器開啟 `portfolio_risk_dashboard.html` 即可。

```bash
# macOS
open portfolio_risk_dashboard.html

# Linux
xdg-open portfolio_risk_dashboard.html

# Windows
start portfolio_risk_dashboard.html
```

### 透過 GitHub Pages 部署（推薦，可手機隨時看）

1. 把 repo 推上 GitHub
2. 進入 repo Settings → Pages
3. Source 選 `main` branch、root 資料夾
4. 等 1–2 分鐘後即可透過 `https://<your-username>.github.io/<repo-name>/portfolio_risk_dashboard.html` 存取
5. 加進手機書籤，每天打開都是最新狀態

## 🛠️ 技術棧

- 純 HTML + CSS + JavaScript（不需編譯、不需後端）
- Chart.js 4.4.0（從 cdnjs CDN 載入）
- localStorage 持久化
- 完全離線可用（除了首次載入 Chart.js）

## 📅 資料更新原則

儀表板的「研究內容」（Bull/Bear case、催化劑、目標價）為 2026/05/10 截錄當下。建議：

- **每週**：手動更新各個股的「現價」欄位（最簡單的維護）
- **每月**：完整更新一次研究內容（重新跑一次 Investment Memo）
- **法說會後**：對應個股的 stats / bull / bear / action 同步更新

## ⚠️ 免責聲明

本儀表板為個人投資組合分析工具，整合公開市場資訊與基本面研究框架，**不構成證券買賣建議**。所有投資決策須自行判斷並承擔風險。

## 📝 變更記錄

- **v2 (2026/05/10)**：互動版上線，加入南亞科、華邦電、旺宏記憶體 watchlist；支援編輯/新增/刪除/儲存
- **v1 (2026/05/10)**：靜態版本，5 檔個股 + 風控分析
