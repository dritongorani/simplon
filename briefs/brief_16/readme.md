### Brief 16 ###

#### 1) Le code que j'ai deployé sur mon script dont me permet de supprimer tout les ressources dans ma groupe de ressource. 

```
$resources = az resource list --resource-group PERSO_DRITON | ConvertFrom-Json

foreach ($resource in $resources) {
    az resource delete --resource-group PERSO_DRITON --ids $resource.id --verbose
}

Write-Output "####################################Le script a été bien executé.##########################################"
```

***
2) #### J'ai creé un pipeline en choisisant AZURE CLI Script et j'ai deposé mon script sur devops. 
3) J'ai configuré mon pipeline en choissant bien mon script et le directory. 
![Screenshot from 2023-01-18 15-35-36.png](:/7bc24858688b4901b875b251e8d46784)

***
4) J'ai activé l'option du schedule set pour que mon releasse s'execute tout les jours du lundi au vendredi à 23h00. Tout mes ressources seront supprimé sauf que mon groupe de ressource. 

![Screenshot from 2023-01-18 15-37-08.png](:/bf133f1a408d463a87850d3e0796f5ff)





