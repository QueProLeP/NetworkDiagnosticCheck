Write-Host "Basic Network Diagnostic 'n"

#Ping Google DNS server
Write-Host "Pinging Google DNS on (8.8.8.8)..."
Test-Connection -ComputerName 8.8.8.8 -Count.exe 4

#Check DNS Resolution Using nslookup
Write-Host "'nTesting DNS resolution (nslookup www.google.com)"
nslookup.exe www.google.com

#find local network info
Write-Host "`nGathering local network information..."
$ipconfig = Get-NetIPConfiguration | Where-Object {$_.IPv4Address}
foreach ($config in $ipconfig) {
    Write-Host "Interface: $($config.InterfaceAlias)"
    Write-Host "IPv4 Address: $($config.IPv4Address.IPAddress)"
    Write-Host "Subnet Mask: $($config.IPv4Address.PrefixLength)"
    Write-Host "Default Gateway: $($config.IPv4DefaultGateway.NextHop)`n"
}

#Ping Default Gateway
Write-Host "Pinging default gateway..."
foreach ($config in $ipconfig) {
    $gateway = $config.IPv4DefaultGateway.NextHop
    if ($gateway) {
        Test-Connection -ComputerName $gateway -Count 4
    }
    else {
        Write-Host "No default gateway found for interface $($config.InterfaceAlias)"
    }
}

#verifies network setup - can my device talk to the router, can it resolve domain names, can i ping google dns?
