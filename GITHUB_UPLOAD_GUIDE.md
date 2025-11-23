# GitHub Repository Upload Guide

## Step-by-Step Instructions to Upload SRAM-PUF Project to GitHub

---

## Prerequisites

1. **Git installed** on your system
   - Download from: https://git-scm.com/downloads
   - Verify installation: Open CMD and type `git --version`

2. **GitHub account**
   - Create account at: https://github.com/signup

---

## Step 1: Create GitHub Repository

1. Go to https://github.com
2. Click the **"+"** icon in top-right corner
3. Select **"New repository"**
4. Fill in repository details:
   - **Repository name:** `sram-puf-system`
   - **Description:** `SRAM-based Physical Unclonable Function (PUF) system for FPGA - Hardware security and cryptographic key generation`
   - **Visibility:** Choose Public or Private
   - **DO NOT** initialize with README (we already have one)
5. Click **"Create repository"**

---

## Step 2: Initialize Local Git Repository

Open Command Prompt (CMD) in your project directory:

```cmd
cd C:\Users\Melroy Quadros\puf
```

Initialize Git repository:

```cmd
git init
```

Expected output:
```
Initialized empty Git repository in C:/Users/Melroy Quadros/puf/.git/
```

---

## Step 3: Configure Git (First Time Only)

Set your name and email:

```cmd
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## Step 4: Add Files to Repository

Add all project files:

```cmd
git add .
```

Check what will be committed:

```cmd
git status
```

You should see files in green (staged for commit).

---

## Step 5: Create Initial Commit

```cmd
git commit -m "Initial commit: Complete SRAM-PUF system implementation"
```

Expected output:
```
[master (root-commit) xxxxxxx] Initial commit: Complete SRAM-PUF system implementation
 XX files changed, XXXX insertions(+)
 create mode 100644 README.md
 create mode 100644 rtl/sram_puf_core.v
 ...
```

---

## Step 6: Connect to GitHub Repository

Replace `YOUR_USERNAME` with your GitHub username:

```cmd
git remote add origin https://github.com/YOUR_USERNAME/sram-puf-system.git
```

Verify remote:

```cmd
git remote -v
```

Expected output:
```
origin  https://github.com/YOUR_USERNAME/sram-puf-system.git (fetch)
origin  https://github.com/YOUR_USERNAME/sram-puf-system.git (push)
```

---

## Step 7: Push to GitHub

Push your code to GitHub:

```cmd
git branch -M main
git push -u origin main
```

You may be prompted to login:
- Enter your GitHub username
- Enter your Personal Access Token (PAT) as password
  - If you don't have a PAT, create one at: https://github.com/settings/tokens

Expected output:
```
Enumerating objects: XX, done.
Counting objects: 100% (XX/XX), done.
Delta compression using up to X threads
Compressing objects: 100% (XX/XX), done.
Writing objects: 100% (XX/XX), XXX.XX KiB | XXX.XX MiB/s, done.
Total XX (delta X), reused 0 (delta 0), pack-reused 0
To https://github.com/YOUR_USERNAME/sram-puf-system.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

---

## Step 8: Verify Upload

1. Go to your GitHub repository: `https://github.com/YOUR_USERNAME/sram-puf-system`
2. You should see all your files uploaded
3. README.md will be displayed on the main page

---

## Files Included in Repository

### Core RTL Files
- `rtl/sram_puf_core.v` - SRAM PUF core implementation
- `rtl/sram_puf_controller.v` - Top-level controller
- `rtl/fuzzy_extractor.v` - Error correction and helper data
- `rtl/key_gen.v` - Key generation module
- `rtl/sha256_core.v` - SHA-256 hash implementation
- `rtl/hamming_codec.v` - Hamming error correction
- `rtl/bch_codec.v` - BCH error correction
- `rtl/sram_puf_params.vh` - System parameters

### Testbench
- `tb/tb_sram_puf_top.v` - Complete system testbench

### Vivado Project Files
- `vivado/create_project.tcl` - Project creation script
- `vivado/constraints.xdc` - Timing constraints

### Scripts
- `run_vivado.bat` - Windows launch script
- `run_vivado.sh` - Linux launch script
- `run_simulation_auto.bat` - Automated simulation script

### Documentation
- `README.md` - Main project documentation
- `HOW_TO_RUN.md` - Quick start guide
- `QUICK_START.md` - Quick reference
- `USAGE_GUIDE.md` - Detailed usage instructions
- `VERIFICATION_RESULTS.md` - Test results
- `SIMULATION_CONSOLE_OUTPUT.md` - Simulation output
- `FIX_SUMMARY.md` - Bug fixes and improvements
- `IMPLEMENTATION_COMPLETE.md` - Implementation notes

---

## Future Updates

To update your repository after making changes:

```cmd
# Check what changed
git status

# Add changed files
git add .

# Commit changes
git commit -m "Description of changes"

# Push to GitHub
git push
```

---

## Common Issues and Solutions

### Issue 1: Authentication Failed

**Solution:** Use Personal Access Token (PAT) instead of password
1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes: `repo` (full control)
4. Copy the token
5. Use token as password when pushing

### Issue 2: Large Files Warning

**Solution:** Files over 100MB need Git LFS
```cmd
git lfs install
git lfs track "*.bit"
git add .gitattributes
git commit -m "Add Git LFS"
```

### Issue 3: Permission Denied

**Solution:** Check repository URL and access rights
```cmd
git remote set-url origin https://github.com/YOUR_USERNAME/sram-puf-system.git
```

---

## Repository Structure on GitHub

```
sram-puf-system/
├── .gitignore
├── README.md
├── GITHUB_UPLOAD_GUIDE.md
├── HOW_TO_RUN.md
├── QUICK_START.md
├── USAGE_GUIDE.md
├── VERIFICATION_RESULTS.md
├── SIMULATION_CONSOLE_OUTPUT.md
├── FIX_SUMMARY.md
├── rtl/
│   ├── sram_puf_core.v
│   ├── sram_puf_controller.v
│   ├── fuzzy_extractor.v
│   ├── key_gen.v
│   ├── sha256_core.v
│   ├── hamming_codec.v
│   ├── bch_codec.v
│   └── sram_puf_params.vh
├── tb/
│   └── tb_sram_puf_top.v
├── vivado/
│   ├── create_project.tcl
│   └── constraints.xdc
├── run_vivado.bat
├── run_vivado.sh
└── run_simulation_auto.bat
```

---

## Next Steps After Upload

1. **Add Topics** to your repository:
   - Click "Settings" → "Topics"
   - Add: `fpga`, `verilog`, `puf`, `hardware-security`, `xilinx`, `vivado`, `cryptography`

2. **Create Releases**:
   - Go to "Releases" → "Create a new release"
   - Tag: `v1.0.0`
   - Title: "Initial Release - Production Ready"
   - Description: Include test results and features

3. **Add License**:
   - Click "Add file" → "Create new file"
   - Name: `LICENSE`
   - Choose MIT License template

4. **Enable GitHub Pages** (optional):
   - Settings → Pages
   - Source: Deploy from branch `main`
   - Folder: `/docs` or `/ (root)`

---

## Sharing Your Repository

Share your repository URL:
```
https://github.com/YOUR_USERNAME/sram-puf-system
```

Clone command for others:
```cmd
git clone https://github.com/YOUR_USERNAME/sram-puf-system.git
```

---

## Success Indicators

✅ All files visible on GitHub  
✅ README.md displays correctly  
✅ Green commit history  
✅ Repository is accessible  
✅ Clone URL works  

---

**Congratulations! Your SRAM-PUF system is now on GitHub!** 🎉
