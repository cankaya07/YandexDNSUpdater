#source code : https://www.powershellgallery.com/packages/YandexPdd/1.0/Content/YandexPdd.psm1

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
$InvokeWebRequest = Invoke-WebRequest -URI $URL -Method POST -Headers $Headers -Body $Body
$InvokeWebRequest.Content | ConvertFrom-Json

}


$ip = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip
$subdomain = 'evdekipc'
$domain='example.com'
$pddToken_='xxxxxxxxxxxxx' # you can get yandex token from https://pddimp.yandex.ru/api2/admin/get_token?domain_name=cankaya.net.tr

 
Set-YandexDNSrecord -PddToken $pddToken_  -domain $domain -record_id 50393335 -subdomain $subdomain -ttl 3600 -content  $ip
 
 