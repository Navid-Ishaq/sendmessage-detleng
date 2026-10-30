param()
$ErrorActionPreference = 'Stop'
$source = $PSScriptRoot
$publish = 'D:\DETLENG2\sendmessage-detleng-publish'
$remote = 'https://github.com/Navid-Ishaq/sendmessage-detleng.git'
$files = @('index.html','README.md','TESTING.md','THIRD-PARTY-NOTICES.md','PUSH.ps1','CNAME','.nojekyll','.gitignore','package.json','serve.mjs','assets/styles.css','assets/app.mjs','assets/core.mjs','assets/reader-worker.js','assets/mark.svg','assets/vendor/xlsx.full.min.js','assets/vendor/SheetJS-LICENSE.txt','tests/core.test.mjs')
foreach ($file in $files) {
    if (!(Test-Path -LiteralPath (Join-Path $source $file))) { throw "Missing source file: $file" }
}
& node --test (Join-Path $source 'tests/core.test.mjs')
if ($LASTEXITCODE -ne 0) { throw 'Tests failed. Nothing pushed.' }
if (!(Test-Path -LiteralPath $publish)) {
    & git clone -- $remote $publish
    if ($LASTEXITCODE -ne 0) { throw 'Clone failed. Nothing pushed.' }
} elseif (!(Test-Path -LiteralPath (Join-Path $publish '.git'))) {
    throw 'The publish folder exists but is not a Git checkout. Nothing overwritten.'
}
Set-Location -LiteralPath $publish
$origin = & git remote get-url origin
if ($LASTEXITCODE -ne 0 -or $origin.TrimEnd('/') -ne $remote) { throw 'Unexpected origin. Stop here.' }
$dirty = & git status --porcelain
if ($LASTEXITCODE -ne 0) { throw 'Could not read Git status.' }
if ($dirty) { throw 'Publish checkout has uncommitted changes. Review them first.' }
& git checkout main
if ($LASTEXITCODE -ne 0) { throw 'Could not select main.' }
& git pull --rebase origin main
if ($LASTEXITCODE -ne 0) { throw 'Pull failed. Resolve it before continuing.' }
foreach ($file in $files) {
    $destination = Join-Path $publish $file
    New-Item -ItemType Directory -Path (Split-Path $destination -Parent) -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $source $file) -Destination $destination -Force
}
& node --test tests/core.test.mjs
if ($LASTEXITCODE -ne 0) { throw 'Publish-copy tests failed. Nothing pushed.' }
& git add -- $files
if ($LASTEXITCODE -ne 0) { throw 'Staging failed.' }
& git diff --cached --quiet
$diffCode = $LASTEXITCODE
if ($diffCode -eq 1) {
    & git commit -m 'Build Send Message with local spreadsheet personalization and manual app handoff'
    if ($LASTEXITCODE -ne 0) { throw 'Commit failed. Nothing pushed.' }
} elseif ($diffCode -ne 0) { throw 'Git diff failed.' }
& git push origin main
if ($LASTEXITCODE -ne 0) { throw 'Push failed. No force-push attempted.' }
Write-Host 'Push complete. Check GitHub Pages deployment and HTTPS before testing your own app.' -ForegroundColor Green
