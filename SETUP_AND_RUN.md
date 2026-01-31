# ShineShelf - Setup & Run Guide

**Current Status:**
- Backend: ✅ Running on `localhost:3000` (Node.js + PostgreSQL)
- Database: ✅ created (`Shineshelf`)
- Frontend Code: ✅ Ready in `shineshelf/` folder
- Flutter SDK: ❌ Missing (You need to install this)

---

## Step 1: Install Flutter SDK
1.  **Download Flutter**:
    [Click here to download Flutter for Windows](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip)
2.  **Extract**:
    - Unzip the file to a simple path like `C:\src\flutter`.
    - **Do not** put it in "Program Files".
3.  **Update Path**:
    - Search for "Edit environment variables for your account" in Windows Search.
    - Under "User variables", find `Path` and click **Edit**.
    - Click **New** and add the full path to `flutter\bin` (e.g., `C:\src\flutter\bin`).
    - Click OK.

## Step 2: Install Android Studio (Required for Emulator)
1.  Download and Install [Android Studio](https://developer.android.com/studio).
2.  Open it and go to **Device Manager**.
3.  Create a "Virtual Device" (Emulator) and start it.

## Step 3: Run the ShineShelf App
1.  **Open a new Terminal** (Command Prompt or PowerShell).
2.  Navigate to the app folder:
    ```cmd
    cd "C:\Users\PARAS NATH KUMAR\Documents\dbms\shineshelf"
    ```
3.  Install dependencies:
    ```cmd
    flutter pub get
    ```
4.  Run the app:
    ```cmd
    flutter run
    ```

## Important Note
**Keep the Backend Running!**
The black window running `node index.js` must stay open. If you closed it, start it again:
```cmd
cd "C:\Users\PARAS NATH KUMAR\Documents\dbms\backend"
node index.js
```
