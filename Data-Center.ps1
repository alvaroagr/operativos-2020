<#
.SYNOPSIS
Este script despliega un menu para realizar actividades de Data Center en Powershell.
.DESCRIPTION
Este script permite desplegar un menu para realizar cinco acciones.
- Desplegar los cinco (5) procesos que mas CPU estan consumiendo en este instante.
- Desplegar los FileSystem (o Discos) conectados a la maquina.
- Desplegar el nombre y tamaño del archivo mas grande almacenado en un FileSystem dado.
- Mostrar la cantidad de memoria libre y de espacio swap utilizado en este instante.
- Mostrar el numero de conexiones de red activas en este instante.
.EXAMPLE
Insert example here.
.EXAMPLE
.LINK
Alvaro A. Gomez Rey - http://github.com/alvaroagr
Get-Process
Get-PSDrive
-missing link for option 3-
Get-CIMInstance
Get-NetTCPConnection

#>
do
{
	Write-Host "================================================ Herramienta Powershell Data Center ================================================"
	Write-Host "1: Ingrese '1' para desplegar los cinco procesos que mas CPU esten consumiendo en este momento."
	Write-Host "2: Ingrese '2' para desplegar los filesystems o discos conectados a la maquina."
	Write-Host "3: Ingrese '3' para desplegar el nombre y el tamaño del archivo mas grande almacenado en un disco o filesystem."
	Write-Host "4: Ingrese '4' para desplegar cantidad de memoria libre y cantidad de espacio swap en uso."
	Write-Host "5: Ingrese '5' para desplegar numero de conexiones de red activas actualmente."
	Write-Host "Q: Ingrese 'Q' para salir"
	$input = Read-Host "Seleccione una opcion"
	switch($input){
		'1'{
			<# get-process | sort CPU -Descending | select @{n='Proceso';e={$_.ProcessName}},@{n='CPU en Uso';e={$_.CPU}} -First 5 | ft #>
			
			get-process | 
			sort CPU -Descending | 
			select @{n='Proceso';e={$_.ProcessName}}, @{n='CPU en Uso (s)';e={$_.CPU}} -First 5 | 
			ft
		}
		'2'{
			<# Get-PSDrive | where {$_.Provider -like "*FileSystem*" -and $_.Free -ne $null} | ft @{n="Nombre";e={$_.Name}},@{n="Tamano (B)";e={($_.Free + $_.Used)}},@{n="Espacio Libre (B)";e={$_.Free}} #>
			Get-PSDrive | 
			where {$_.Provider -like "*FileSystem*" -and $_.Free -ne $null} | 
			ft @{n="Nombre";e={$_.Name}}, @{n="Tamano (B)";e={($_.Free + $_.Used)}}, @{n="Espacio Libre (B)";e={$_.Free}}
		}
		'3'{
			Write-Host "Desplegar el nombre y el tamaño del archivo mas grande almacenado en un disco o filesystem."
		}
		'4'{
			<# Get-CIMInstance Win32_OperatingSystem | Select @{n="Memoria Libre (B)";e={$_.FreePhysicalMemory / 1KB}},@{n="Memoria Libre (%)";e={($_.FreePhysicalMemory / $_.TotalVisibleMemorySize) * 100}} | fl #>
			<# Get-CIMInstance Win32_OperatingSystem | 
			select @{n="Memoria Libre (B)";e={$_.FreePhysicalMemory}}, @{n="Memoria Libre (%)";e={($_.FreePhysicalMemory / $_.TotalVisibleMemorySize) * 100}},
			@{n="Espacio Swap Ocupado (B)";e={$_.TotalVirtualMemorySize - $_.FreeVirtualMemory}}, @{n="Espacio Swap Ocupado (%)";e={(($_.TotalVirtualMemorySize - $_.FreeVirtualMemory)/$_.TotalVirtualMemorySize) * 100}} | 
			fl #>
			
			Get-CIMInstance Win32_OperatingSystem | 
			select @{n="Memoria Libre (B)";e={$_.FreePhysicalMemory}}, @{n="Memoria Libre (%)";e={($_.FreePhysicalMemory / $_.TotalVisibleMemorySize) * 100}},
			@{n="Espacio Swap Ocupado (B)";e={$_.SizeStoredInPagingFiles}}, @{n="Espacio Swap Ocupado (%)";e={($_.SizeStoredInPagingFiles / ($_.SizeStoredInPagingFiles + $_.FreeSpaceInPagingFiles)) * 100}} | 
			fl
		}
		'5'{
			<# Get-NetTCPConnection | where {$_.State -like "*Established*"} | measure | fl @{n="Conexiones de Red Activas Actualmente";e={$_.Count}} #>
			Get-NetTCPConnection | 
			where {$_.State -like "*Established*"} | 
			measure | 
			fl @{n="Conexiones de Red Activas Actualmente";e={$_.Count}}
		}
		'q'{
			<# cls #>
			return
		}
		default{
			Write-Warning "Por favor escriba un comando valido."
		}
	}
}
until($input -eq 'q')