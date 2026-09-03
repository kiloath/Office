<#
.SYNOPSIS
匯出 Fortinet 防火牆的 root CA 憑證。

.DESCRIPTION
匯出 PEM 格式的 .crt 檔（for linux / 容器信任庫）到目前目錄，檔名為憑證 CN（即 FortiGate 序號）。
#>
#Requires -Version 7.0

Get-ChildItem Cert:\CurrentUser\Root |
    Where-Object { $_.Subject -match 'O=Fortinet' -and $_.Subject -match 'OU=Certificate Authority' } |
    ForEach-Object {
        $cn = $_.GetNameInfo('SimpleName', $false)
        Set-Content -Path "$cn.crt" -Value ($_.ExportCertificatePem() + "`n") -NoNewline
    }
