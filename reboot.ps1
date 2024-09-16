# もし管理者権限で実行されていなかったら 権限を要求
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 終了させたいプロセスのパス
$pathsToTerminate = @(
    "C:\Program Files\Virtual Desktop Streamer\",
    "C:\Program Files\Virtual Desktop\"
)

# 現在実行中のプロセスを取得
Get-Process | ForEach-Object {
    $processPath = $_.Path

    # プロセスのパスが指定されたパスのいずれかに含まれているか確認
    if ($processPath -and ($pathsToTerminate | Where-Object { $processPath.StartsWith($_) })) {
        Write-Host "Terminating process: $($_.Name) (PID: $($_.Id))"
        Stop-Process -Id $_.Id -Force  # プロセスを強制終了
    }
}

# VirtualDesktop.Streamer.exe を起動
Start-Process -FilePath "C:\Program Files\Virtual Desktop Streamer\VirtualDesktop.Streamer.exe" -Verb RunAs
