# Frappe Git Export & Push Guide

This guide explains the standard workflow for exporting customizations from a Frappe application and pushing them to a Git repository.

---

## 1. Navigate to Your App Directory

```bash
cd ~/frappe/bench/apps/my_app
```

Replace `my_app` with your actual app name.

---

## 2. Check Git Status

View all modified, added, and deleted files.

```bash
git status
```

---

## 3. Export Fixtures

If your app uses fixtures (Custom Fields, Client Scripts, Property Setters, Workspaces, Print Formats, etc.), export them before committing.

```bash
cd ~/frappe/bench
bench --site your-site-name export-fixtures
```

Example:

```bash
bench --site dev_site1.local export-fixtures
```

The exported files will be stored under:

```
apps/my_app/fixtures/
```

---

## 4. Review Changes

```bash
cd apps/my_app
git status
git diff
```

---

## 5. Stage Files

```bash
git add -A
```

Or stage only specific files:

```bash
git add path/to/file.py
```

---

## 6. Commit Changes

```bash
git commit -m "Export fixtures and update customizations"
```

Example:

```bash
git commit -m "Add supplier quotation customization"
```

---

## 7. Check Your Git Remote (Optional)

```bash
git remote -v
```

This shows remote names such as `origin` or `upstream` and the associated URLs.

---

## 8. Push to Remote Repository

```bash
git push <remote-name> <branch-name>
```

Example:

```bash
git push origin dev-develop
```

or

```bash
git push upstream qa-26002
```

### First Push vs Later Pushes

- If the remote branch does not exist yet, the same command will create it on the remote:

```bash
git push origin dev-develop
```

- For later pushes to the same branch, use the same command again:

```bash
git push origin dev-develop
```

- The `-u` option is optional. It only sets the upstream tracking branch on the first push and is not required for introduction.

After pushing once, future pushes on the same branch can simply use:

```bash
git push
```

---

# Complete Workflow

```bash
cd ~/frappe/bench

# Export fixtures
bench --site your-site-name export-fixtures

# Go to app
cd apps/my_app

# Review changes
git status
git diff

# Commit
git add -A
git commit -m "Update customizations"

# Push
git push <remote-name> <branch-name>
```

---

# Common Commands

## Check Current Branch

```bash
git branch
```

## View Remote Repository

```bash
git remote -v
```

## Pull Latest Changes

```bash
git pull origin <branch-name>
```

## Push Current Branch

```bash
git push
```

---

# Notes

* **Python code (`.py`)**: Git automatically tracks changes.
* **JavaScript (`.js`)**: Git automatically tracks changes.
* **Jinja Templates (`.html`)**: Git automatically tracks changes.
* **Fixtures** (Custom Fields, Client Scripts, Property Setters, Print Formats, Workspaces): Run `bench export-fixtures`.
* **DocType changes**: Run `bench migrate`.
* Always run `git status` before committing to verify the files that will be included in your commit.
