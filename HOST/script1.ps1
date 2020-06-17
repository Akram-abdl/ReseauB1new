$nom = wmic DESKTOPMONITOR get systemName
$nom = $nom[2]
$ip = wmic NICCONFIG get IPAddress
$ip = $ip[8]
$os = wmic OS get SystemDirectory 
$os = $os[2]
$version_os = wmic OS get Version 
$version_os = $version_os[2]
$heure = wmic OS get LastBootUpTime
$heure = $heure[2]
$ajour = wmic OS get status
$ajour = $ajour[2]

function Volume {
    $os = Get-WmiObject Win32_logicaldisk
    foreach ($element in $os) {
        $stockage_utilise = [math]::Round($element.Size / 1000000000, 2)
        $stockage_libre = [math]::Round($element.FreeSpace / 1000000000, 2)
        Write-Output "Le stockage utilise de la machine est $stockage_utilise Go"
        Write-Output "Le stockage libre de la machine est $stockage_libre"
    }
}

function Ram {
    $os = Get-WmiObject Win32_OperatingSystem
    $RAM_utilise = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1000000, 2)
    $RAM_libre = [math]::Round((Get-WmiObject win32_operatingsystem).FreePhysicalMemory / 1000000, 2)
    Write-Output "La RAM utilise de la machine est $RAM_utilise Mo"
    Write-Output "La RAM libre de la machine est $RAM_libre Mo"
}

$utilisateur = Get-localuser

function Ping_Moyenne {
    $ping = Test-Connection -count 10 8.8.8.8
    $moyenne = ($ping | Measure-Object ResponseTime -average -maximum)
    $calcul = [math]::Round($moyenne.average, 2)
    Write-Output "Le temps moyenne vers 8.8.8.8 est $calcul"
}

echo "Le nom de la machine est $nom"
echo "L'adresse IP sur la machine est $ip"
echo "L'OS de la machine est $os"
echo "La version de l'OS de la machine est $version_os"
echo "L'heure d'allumage est $heure"
echo "L'os à jour $ajour" 
$(Volume)
$(RAM)
echo "Tous les utilisateurs sont $utilisateur"
$(Ping_Moyenne)