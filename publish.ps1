# ฝากหน้าคั่นกัน /u/1 ขึ้น GitHub Pages (ฟรี) — รันครั้งเดียวหลังมีบัญชี GitHub ใหม่
# วิธีรัน:  cd D:\Project\CaseMgr-live\launcher ; powershell -ExecutionPolicy Bypass -File .\publish.ps1
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
# ใช้บัญชี GitHub ที่ล็อกอินอยู่ ถ้าบัญชีนั้นสร้าง repo ไม่ได้ → ล็อกอินบัญชีใหม่
gh auth status 2>$null | Out-Null
if ($LASTEXITCODE -ne 0 -or $args -contains '-new') { gh auth login --web --git-protocol https }
$u = (gh api user --jq .login).Trim()
Write-Host "บัญชี GitHub: $u"
if (-not (Test-Path .git)) { git init -q -b main }
git add -A; git commit -q -m "launcher" 2>$null
git remote remove origin 2>$null
gh repo view "$u/casemgr" 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
  gh repo create "$u/casemgr" --public --description "CaseMgr launcher"
  if ($LASTEXITCODE -ne 0) { Write-Host "สร้าง repo ไม่ได้ (บัญชีนี้ถูกระงับ/กำลังลบ) → ล็อกอินบัญชีใหม่: รันซ้ำแบบ .\publish.ps1 -new" -ForegroundColor Yellow; exit 1 }
}
git remote add origin "https://github.com/$u/casemgr.git"
git push -u -f origin main
gh api -X POST "repos/$u/casemgr/pages" -f "source[branch]=main" -f "source[path]=/" 2>$null | Out-Null
$url = "https://$($u.ToLower()).github.io/casemgr/"
Set-Clipboard -Value $url
Write-Host ""
Write-Host "✅ หน้าคั่น: $url  (คัดลอกไว้ในคลิปบอร์ดแล้ว — รอ 1–2 นาทีให้ GitHub สร้างหน้า)"
Write-Host "➡ วาง URL นี้ที่แท็บ 'ตั้งค่า' คอลัมน์ S แถว 'หน้าคั่นกัน /u/1 (URL · ว่าง = ปิด)'  (หรือบอก Claude ให้ใส่ให้)"
