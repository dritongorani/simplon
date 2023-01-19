





$resources = az resource list --resource-group PERSO_DRITON | ConvertFrom-Json

foreach ($resource in $resources) {
    az resource delete --resource-group PERSO_DRITON --ids $resource.id --verbose
}

Write-Output "####################################Le script a été bien executé.##########################################"

