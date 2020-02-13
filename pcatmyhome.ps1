# Функция НЕ генерирует токен! 
# Токен создается только у Яндекса, об этом написано выше!

Function Add-YandexDNSrecord {
<# 
 # https://sawfriendship.wordpress.com/2016/02/15/yandexpdd/ 
 # https://tech.yandex.ru/pdd/doc/reference/dns-add-docpage/ 
#>
[CmdletBinding()]
param(
[string]$PddToken,
[string]$domain,
[ValidateSet("SRV","TXT","NS","MX","SOA","A","AAAA","CNAME")][string]$type,
[string]$admin_mail,
[string]$content,
[int]$priority = 10,
[int]$weight,
[ValidateRange(1,65534)][string]$port,
[string]$target,
[string]$subdomain,
[ValidateRange(900,1209600)][int]$ttl = 21600
)
if($Verbose){$VerbosePreference = "Continue"}
$PddToken =   $PddToken
$pddimpUrl = 'https://pddimp.yandex.ru'
$api = '/api2/admin/dns/add'
$URL = "$pddimpUrl"+"$api"
$Headers = @{}
$Headers.PddToken = $PddToken
$Body = @{}
$Body.domain = $domain
$Body.type = $type
$Body.admin_mail = $admin_mail
$Body.content = $content
$Body.priority = $priority
$Body.weight = $weight
$Body.port = $port
$Body.target = $target
$Body.subdomain = $subdomain
$Body.ttl = $ttl
$InvokeWebRequest = Invoke-WebRequest -URI $URL -Method POST -Headers $Headers -Body $Body
$InvokeWebRequest.Content | ConvertFrom-Json

}

# Получить все DNS записи домена

Function Get-YandexDNSrecord {
<# 
 # https://sawfriendship.wordpress.com/2016/02/15/yandexpdd/ 
 # https://tech.yandex.ru/pdd/doc/reference/dns-list-docpage/ 
#>
[CmdletBinding()]
param(
[string]$PddToken,
[string]$domain
)
if($Verbose){$VerbosePreference = "Continue"}
$PddToken =  $PddToken
$pddimpUrl = 'https://pddimp.yandex.ru'
$api = '/api2/admin/dns/list?'
$URL = "$pddimpUrl"+"$api"
$Headers = @{}
$Headers.PddToken = $PddToken
$Body = @{}
$Body.domain = $domain
$InvokeWebRequest = Invoke-WebRequest -URI $URL -Method GET -Headers $Headers -Body $Body -UseBasicParsing
$InvokeWebRequest.Content #| ConvertFrom-Json

}

Function Set-YandexDNSrecord {
<# 
 # https://sawfriendship.wordpress.com/2016/02/15/yandexpdd/ 
 # https://tech.yandex.ru/pdd/doc/reference/dns-edit-docpage/ 
#>
[CmdletBinding()]
param(
[string]$PddToken,
[string]$domain,
[int64]$record_id,
[string]$subdomain,
[ValidateRange(900,1209600)][int]$ttl = 21600,
[ValidateRange(900,86400)][int]$refresh = 10800,
[ValidateRange(90,3600)][int]$retry = 900,
[ValidateRange(90,3600)][int]$expire = 900,
[ValidateRange(90,86400)][int]$neg_cache = 10800,
[string]$admin_mail,
[string]$content,
[int]$priority = 10,
[string]$port,
[int]$weight,
[string]$target
)
if($Verbose){$VerbosePreference = "Continue"}
$PddToken =  $PddToken
$pddimpUrl = 'https://pddimp.yandex.ru'
$api = '/api2/admin/dns/edit'
$URL = "$pddimpUrl"+"$api"
$Headers = @{}
$Headers.PddToken = $PddToken
$Body = @{}
$Body.domain = $domain
$Body.record_id = $record_id
$Body.subdomain = $subdomain
$Body.ttl = $ttl
$Body.refresh = $refresh
$Body.retry = $retry
$Body.expire = $expire
$Body.neg_cache = $neg_cache
$Body.admin_mail = $admin_mail
$Body.content = $content
$Body.priority = $priority
$Body.port = $port
$Body.weight = $weight
$Body.target = $target
$InvokeWebRequest = Invoke-WebRequest -URI $URL -Method POST -Headers $Headers -Body $Body -UseBasicParsing
Write-Host $InvokeWebRequest
$InvokeWebRequest.Content | ConvertFrom-Json

}


$ip = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip
$subdomain = 'evdekipc'
$domain='xxx.com'
$pddToken_='xxxxxxxxxxxxx' # you can get yandex token from https://pddimp.yandex.ru/api2/admin/get_token?domain_name=xxx.com
$OurDnsReord

$DomainInfo = ConvertFrom-Json $(Get-YandexDNSrecord -PddToken $pddToken_  -domain $domain)

foreach($obj in $DomainInfo.records)
{
    if( $obj.fqdn -eq $subdomain+'.'+$domain){
    $OurDnsReord=$obj
    Write-Host $OurDnsReord
    }
}

#we already using free service of yandex. dont hurt their dns services :)
if($OurDnsReord.content -ne $ip)
{
    Write-Host Lets change ip address of dns record
    Write-Host $LastKnownIp "<>" $ip
    Set-YandexDNSrecord -PddToken $pddToken_  -domain $domain -record_id $OurDnsReord.record_id -subdomain $subdomain -ttl 3600 -content  $ip
}
