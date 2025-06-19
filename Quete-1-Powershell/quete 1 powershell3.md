# Equivalence des commandes bash / Powershell

cp -->      Copy-Item

rm -->      Remove-Item

cd -->      Set-Location

mkdir -->    New-Item

man -->     help

history --> Get-History

alias-->    Get-Alias

cat -->     Get-Content






# cp

PS C:\Users\b> Get-Command -Name cp

CommandType     Name                                               Version    Source                                                                                     
-----------     ----                                               -------    ------                                                                                     
**Alias           cp -> Copy-Item**                                                                                                                                          

# rm


PS C:\Users\b> Get-Command -Name rm

CommandType     Name                                               Version    Source                                                                                     
-----------     ----                                               -------    ------                                                                                     
**Alias           rm -> Remove-Item**                                                                                                                                        


# cd

PS C:\Users\b> Get-Command -Name cd

CommandType     Name                                               Version    Source                                                                                     
-----------     ----                                               -------    ------                                                                                     
**Alias           cd -> Set-Location**                                                                                                                                       

# mkdir

 PS C:\Users\b> Get-Command mkdir

CommandType     Name                                               Version    Source                                                                                                          
-----------     ----                                               -------    ------                                                                                                          
Function        mkdir                                                                                                                                                                         



PS C:\Users\b> Get-Help mkdir

NOM
    New-Item
    
SYNTAXE
    New-Item [-Path] <string[]>  [<CommonParameters>]
    
    New-Item [[-Path] <string[]>]  [<CommonParameters>]
    
                                                                                                                                                

# man

PS C:\Users\b> Get-Command -Name man

CommandType     Name                                               Version    Source                                                                                     
-----------     ----                                               -------    ------                                                                                     
**Alias           man -> help**                                                                                                                                              

# history

PS C:\Users\b> Get-Command -Name history

CommandType     Name                                               Version    Source                                                                                     
-----------     ----                                               -------    ------                                                                                     
**Alias           history -> Get-History**  

# alias

 Get-Help Get-Command -online
 
**recherche --> alias --> Get-Alias**

# cat

PS C:\Users\b> Get-Command -Name cat

CommandType     Name                                               Version    Source                                                                                     
-----------     ----                                               -------    ------                                                                                     
**Alias           cat -> Get-Content**                                                                                                                                       
                                                                                                                               
