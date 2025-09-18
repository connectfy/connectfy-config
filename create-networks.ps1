# create-networks.ps1
$networks = @(
  'connectfy_kafka_network',
  'connectfy-api-gateway-network',
  'connectfy-auth-network',
  'connectfy-messenger-network',
  'connectfy-relationships-network',
  'connectfy-account-network',
  'connectfy-notifications-network'
)

foreach ($n in $networks) {
  if (-not (docker network ls --format '{{.Name}}' | Select-String -Pattern "^$n$")) {
    docker network create $n
    Write-Host "Created network: $n"
  } else {
    Write-Host "Already exists: $n"
  }
}
