# create-networks.ps1
$networks = @(
  'kafka_network',
  'api-gateway-network',
  'auth-network',
  'messenger-network',
  'relationships-network',
  'account-network',
  'notifications-network'
)

foreach ($n in $networks) {
  if (-not (docker network ls --format '{{.Name}}' | Select-String -Pattern "^$n$")) {
    docker network create $n
    Write-Host "Created network: $n"
  } else {
    Write-Host "Already exists: $n"
  }
}
