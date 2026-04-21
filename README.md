# DEEPSEE 睇下仙 - 會員 App

## 如何獲取 APK（完整步驟）

### 第一步：註冊 GitHub 賬號

1. 打開瀏覽器，訪問 https://github.com
2. 點擊右上角 **Sign up**
3. 填寫郵箱、密碼、用戶名，完成註冊
4. 驗證郵箱

---

### 第二步：創建新倉庫

1. 登錄 GitHub 後，點擊右上角 **+** → **New repository**
2. 填寫：
   - Repository name：`wehood-member-app`
   - 選擇 **Public**（公開，免費使用 Actions）
   - **不要**勾選 "Add a README file"
3. 點擊 **Create repository**

---

### 第三步：上傳代碼

**方法 A：直接在網頁上傳（最簡單）**

1. 在新建的倉庫頁面，點擊 **uploading an existing file**
2. 將 `wehood_member` 文件夾內的所有文件拖入上傳區域
3. 注意：需要保持文件夾結構，建議用方法 B

**方法 B：使用 GitHub Desktop（推薦）**

1. 下載 GitHub Desktop：https://desktop.github.com
2. 安裝後登錄你的 GitHub 賬號
3. 點擊 **File** → **Add Local Repository**
4. 選擇 `wehood_member` 文件夾
5. 點擊 **Publish repository**，選擇你剛創建的倉庫名
6. 點擊 **Push origin**

---

### 第四步：等待自動編譯

1. 代碼上傳後，GitHub 會自動開始編譯
2. 在倉庫頁面點擊 **Actions** 標籤
3. 可以看到 "Build Android APK" 工作流正在運行（黃色圓圈）
4. 等待約 **5-10 分鐘**，變成綠色勾號表示成功

---

### 第五步：下載 APK

1. 點擊已完成的工作流（綠色勾號）
2. 滾動到頁面底部，找到 **Artifacts** 區域
3. 點擊 **wehood-member-release-apk** 下載
4. 解壓下載的 zip 文件，得到 `app-release.apk`

---

### 第六步：安裝到 Android 手機

1. 將 APK 文件傳輸到手機（微信、QQ、USB 均可）
2. 在手機上打開文件管理器，找到 APK 文件
3. 點擊安裝
4. 如果提示"未知來源"，進入 **設置 → 安全 → 允許安裝未知來源應用**
5. 安裝完成後，桌面會出現「睇下仙」圖標

---

## App 功能說明

| 底部導航 | 對應頁面 |
|---------|---------|
| 🏠 首頁 | 會員主頁（Banner + 快捷菜單） |
| 🛒 商品 | 商品售賣頁 |
| 📷 出席 | 掃碼出席活動 |
| 🤝 義工 | 義工記錄 |
| 👤 個人 | 個人資料 |

## 技術說明

- **框架**：Flutter 3.22
- **核心**：WebView 加載 https://demo.wehood.org/member
- **最低 Android 版本**：Android 5.0（API 21）
- **App 包名**：org.wehood.member
