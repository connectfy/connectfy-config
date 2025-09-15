# # run_docker_services_windows.ps1
# $ErrorActionPreference = 'Stop'  # səhv olanda dayan

# # Desktop path (lokal dilə görə düzgün gələcək)
# $desktop = [Environment]::GetFolderPath('Desktop')
# $path = Join-Path $desktop 'Connectfy'

# if (-not (Test-Path $path)) {
#     Write-Error "Path not found: $path`nYoxla ki 'Connectfy' qovluğu həqiqətən burada olsun: $desktop"
#     exit 1
# }

# function Countdown($seconds) {
#     Write-Host "`nCountdown started: $seconds seconds remaining."
#     for ($i = $seconds; $i -gt 0; $i--) {
#         Write-Host -NoNewline "Time left: $i seconds...`r"
#         Start-Sleep -Seconds 1
#     }
#     Write-Host "`nCountdown complete.`n"
# }

# Write-Host "`nStarting Docker Desktop... (Make sure Docker Desktop is already running)"
# Write-Host "===================================================================="
# Countdown 10

# Write-Host "Stopping all running Docker containers..."
# $containers = docker ps -q
# if ($containers) {
#     docker stop $containers
#     Write-Host "Stopped running containers."
# } else {
#     Write-Host "No running containers found."
# }
# Write-Host "===================================================================="
# Countdown 5

# # Example: start client (modify other services similarly)
# $CONFIG_PATH = Join-Path $path 'connectfy-config'
# if (-not (Test-Path $CONFIG_PATH)) {
#     Write-Error "Client folder not found: $CONFIG_PATH`nSkript dayandırıldı."
#     exit 1
# }

# $AUTH_PATH = Join-Path $path 'connectfy-auth'
# if (-not (Test-Path $AUTH_PATH)) {
#     Write-Error "Client folder not found: $AUTH_PATH`nSkript dayandırıldı."
#     exit 1
# }

# $ACCOUNT_PATH = Join-Path $path 'connectfy-account'
# if (-not (Test-Path $ACCOUNT_PATH)) {
#     Write-Error "Client folder not found: $ACCOUNT_PATH`nSkript dayandırıldı."
#     exit 1
# }

# $NOTIFICATIONS_PATH = Join-Path $path 'connectfy-notifications'
# if (-not (Test-Path $NOTIFICATIONS_PATH)) {
#     Write-Error "Client folder not found: $NOTIFICATIONS_PATH`nSkript dayandırıldı."
#     exit 1
# }

# $RELATIONSHIPS_PATH = Join-Path $path 'connectfy-relationships'
# if (-not (Test-Path $RELATIONSHIPS_PATH)) {
#     Write-Error "Client folder not found: $RELATIONSHIPS_PATH`nSkript dayandırıldı."
#     exit 1
# }

# $MESSENGER_PATH = Join-Path $path 'connectfy-messenger'
# if (-not (Test-Path $MESSENGER_PATH)) {
#     Write-Error "Client folder not found: $MESSENGER_PATH`nSkript dayandırıldı."
#     exit 1
# }

# $API_GATEWAY_PATH = Join-Path $path 'connectfy-api-gateway'
# if (-not (Test-Path $API_GATEWAY_PATH)) {
#     Write-Error "Client folder not found: $API_GATEWAY_PATH`nSkript dayandırıldı."
#     exit 1
# }

# $CLIENT_PATH = Join-Path $path 'connectfy-client'
# if (-not (Test-Path $CLIENT_PATH)) {
#     Write-Error "Client folder not found: $CLIENT_PATH`nSkript dayandırıldı."
#     exit 1
# }

# # CONFIG(KAFKA) SERVICE
# Write-Host "Starting connectfy-config(kafka)..."
# Set-Location $AUTH_PATH
# docker compose -f kafka-compose.yml up -d

# # AUTH SERVICE
# Write-Host "Starting connectfy-auth..."
# Set-Location $AUTH_PATH
# docker compose -f docker-compose.dev.yml up -d --build

# # ACCOUNT SERVICE
# Write-Host "Starting connectfy-account..."
# Set-Location $ACCOUNT_PATH
# docker compose -f docker-compose.dev.yml up -d --build

# # NOTIFICATIONS SERVICE
# Write-Host "Starting connectfy-notifications..."
# Set-Location $NOTIFICATIONS_PATH
# docker compose -f docker-compose.dev.yml up -d --build

# # RELATIONSHIPS SERVICE
# Write-Host "Starting connectfy-relationships..."
# Set-Location $RELATIONSHIPS_PATH
# docker compose -f docker-compose.dev.yml up -d --build

# # MESSENGER SERVICE
# Write-Host "Starting connectfy-messenger..."
# Set-Location $MESSENGER_PATH
# docker compose -f docker-compose.dev.yml up -d --build

# # API GATEWAY SERVICE
# Write-Host "Starting connectfy-api-gateway..."
# Set-Location $API_GATEWAY_PATH
# docker compose -f docker-compose.dev.yml up -d --build

# # CLIENT SERVICE
# Write-Host "Starting connectfy-client..."
# Set-Location $CLIENT_PATH
# docker compose -f docker-compose.dev.yml up -d --build

# Write-Host "`nAll tasks completed successfully! All services that existed were started.`n"

# =========================
# run_docker_services_windows_tabs.ps1
# =========================

$ErrorActionPreference = 'Stop'  # səhv olanda dayan

# Desktop path (lokal dilə görə düzgün gələcək)
$desktop = 'C:\Users\mehed\Desktop'
$basePath = Join-Path $desktop 'Connectfy'

if (-not (Test-Path $basePath)) {
    Write-Error "Path not found: $basePath`nYoxla ki 'Connectfy' qovluğu həqiqətən burada olsun: $desktop"
    exit 1
}

# =========================
# Countdown function
# =========================
function Countdown($seconds) {
    Write-Host "`nCountdown started: $seconds seconds remaining."
    for ($i = $seconds; $i -gt 0; $i--) {
        Write-Host -NoNewline "Time left: $i seconds...`r"
        Start-Sleep -Seconds 1
    }
    Write-Host "`nCountdown complete.`n"
}

# =========================
# Function to start docker-compose in a new tab
# =========================
function Start-DockerInNewTab($path, $composeFile, $serviceName) {
    if (-not (Test-Path $path)) {
        Write-Error "$serviceName folder not found: $path`nSkript dayandırıldı."
        return
    }

    $script = @"
Set-Location '$path'
Write-Host 'Starting $serviceName...'
docker compose -f $composeFile up -d --build
Write-Host '$serviceName started. Press Enter to close this tab...'
Read-Host
"@

    Start-Process powershell -ArgumentList "-NoExit", "-Command", $script
}

# =========================
# Ensure Docker Desktop is running
# =========================
Write-Host "`nStarting Docker Desktop... (Make sure Docker Desktop is already running)"
Write-Host "===================================================================="
Countdown 10

# Stop all running containers
Write-Host "Stopping all running Docker containers..."
$containers = docker ps -q
if ($containers) {
    docker stop $containers
    Write-Host "Stopped running containers."
} else {
    Write-Host "No running containers found."
}
Write-Host "===================================================================="
Countdown 5

# =========================
# Paths for all services
# =========================
$services = @{
    "connectfy-config"         = "kafka-compose.yml"
    "connectfy-auth"           = "docker-compose.dev.yml"
    "connectfy-account"        = "docker-compose.dev.yml"
    "connectfy-notifications"  = "docker-compose.dev.yml"
    "connectfy-relationships"  = "docker-compose.dev.yml"
    "connectfy-messenger"      = "docker-compose.dev.yml"
    "connectfy-api-gateway"    = "docker-compose.dev.yml"
    "connectfy-client"         = "docker-compose.dev.yml"
}

# =========================
# Start all services in separate tabs
# =========================
foreach ($service in $services.Keys) {
    $path = Join-Path $basePath $service
    $composeFile = $services[$service]
    Start-DockerInNewTab $path $composeFile $service
}

Write-Host "`nAll tasks have been started in separate PowerShell tabs!`n"
