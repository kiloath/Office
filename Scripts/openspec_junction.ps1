$RootPath = Resolve-Path (Join-Path $PSScriptRoot '..')
$LinkPath = Join-Path $RootPath 'Book\docs\openspec'
$LinkName = Split-Path $LinkPath -Leaf
$ParentPath = Split-Path $LinkPath -Parent
$TargetPath = Join-Path $RootPath 'openspec'

# 這個專案不一定有跑過 openspec init，沒有來源目錄時視為正常情況，直接略過。
if (-not (Test-Path -LiteralPath $TargetPath -PathType Container)) {
    Write-Host "找不到 openspec 目錄，略過 junction: $TargetPath"
    return
}

# 破損的 junction 用 Test-Path 會回 False，改從父目錄列舉才看得到。
$Existing = if (Test-Path -LiteralPath $ParentPath -PathType Container) {
    Get-ChildItem -LiteralPath $ParentPath -Force | Where-Object Name -eq $LinkName
}

if ($Existing) {
    if (-not ($Existing.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        Write-Host "已存在非連結的項目，不動它: $LinkPath"
        return
    }

    $CurrentTarget = @($Existing.Target)[0]
    if ($CurrentTarget -and ($CurrentTarget.TrimEnd('\') -eq $TargetPath.TrimEnd('\'))) {
        Write-Host "Junction 已存在，略過: $LinkPath"
        return
    }

    Write-Host "移除指向舊目標的 junction: $LinkPath"
    Remove-Item -LiteralPath $LinkPath -Force -Recurse -Confirm:$false
}
else {
    if (-not (Test-Path -LiteralPath $ParentPath -PathType Container)) {
        New-Item -ItemType Directory -Path $ParentPath | Out-Null
    }
}

New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null
Write-Host "已建立 Junction: $LinkPath -> $TargetPath"
