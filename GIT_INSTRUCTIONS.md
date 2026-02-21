# How to Push Your Code to GitHub

It looks like **Git is not installed** (or not in your PATH) on your computer. You need Git to push code to GitHub.

## Step 1: Install Git
1.  **Download Git for Windows**: [Click Here](https://git-scm.com/download/win)
2.  **Run the Installer**:
    *   Click "Next" through all the steps (Default settings are fine).
    *   Wait for it to finish.
3.  **Restart your Terminal**:
    *   Close your current PowerShell/Command Prompt window.
    *   Open a new one.
    *   Type `git --version` to check if it works.

## Step 2: Create a Repo on GitHub
1.  Go to [GitHub.com](https://github.com) and sign in.
2.  Click the **+** icon (top right) -> **New repository**.
3.  Name it (e.g., `shineshelf`).
4.  Click **Create repository**.
5.  Copy the URL (it looks like `https://github.com/yourname/shineshelf.git`).

## Step 3: command to Push
Once Git is working, run these commands in your `dbms` folder:

```bash
git init
git add .
git commit -m "Initial commit of ShineShelf"
git branch -M main
git remote add origin <PASTE_YOUR_GITHUB_URL_HERE>
git push -u origin main
```
