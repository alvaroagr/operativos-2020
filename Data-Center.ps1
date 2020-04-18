<#
.SYNOPSIS
Este script despliega un menu para realizar actividades de Data Center en Powershell.
.DESCRIPTION
Este script permite realizar cinco acciones de Data Center en PowerShell.
1. Desplegar los cinco (5) procesos que mas CPU estan consumiendo en este instante.
2. Desplegar los FileSystem (o Discos) conectados a la maquina.
3. Desplegar el nombre y tamaño del archivo mas grande almacenado en un FileSystem dado.
4. Mostrar la cantidad de memoria libre y de espacio swap utilizado en este instante.
5. Mostrar el numero de conexiones de red activas en este instante.
.EXAMPLE
Insert example here.
Here's an example
.LINK
Alvaro A. Gomez Rey - http://github.com/alvaroagr
Get-Process
Get-PSDrive
Get-ChildItem
Get-CIMInstance
Get-NetTCPConnection
#>
[CmdletBinding()]
param()
process {
	$input = 'q'
	Write-Host 
		"|------------------------------------------------------------------------------------------------------|"
        "| DATA CENTER TOOLS (PowerShell)                                                                       |"
		"|     V1.0                                                                                             |"
		"|     Made by Alvaro A. Gomez Rey                                                                      |"
		"|------------------------------------------------------------------------------------------------------|"
    do{
		Write-Host 
		    "1: Ingrese '1' para desplegar los cinco (5) procesos que mas CPU estan consumiendo en este instante."
            "2: Ingrese '2' para desplegar los FileSystems (o discos) conectados a la maquina."
            "3: Ingrese '3' para mostrar el nombre y el tamano del archivo mas grande almacenado en un"
			"   FileSystem de su eleccion."
            "4: Ingrese '4' para mostrar la cantidad de memoria libre y la cantidad de espacio swap en uso."
            "5: Ingrese '5' para mostrar el numero de conexiones de red activas en este instante."
            "Q: Ingrese 'Q' o utilice ^C para salir de la aplicacion."
		$input = Read-Host "Seleccione una funcionalidad"
		switch($input){
		'1'{
			get-process | <# Obtenemos todos los procesos #>
			sort CPU -Descending | <# Los ordenamos de mayor a menor uso de CPU #>
			select @{n='Proceso';e={$_.ProcessName}}, @{n='CPU en Uso (s)';e={$_.CPU}} -First 5 | 
			<# Seleccionamos los 5 con mayor uso de CPU, y seleccionamos nombre y uso de CPU #>
			ft <# Formateamos el output como tabla #>
		}
		'2'{
			Get-PSDrive | <# Obtenemos todos los discos en la sesion actual #>
			where {$_.Provider -like "*FileSystem*" -and $_.Free -ne $null} | 
			<# Solo nos interesan aquellos discos que son FileSystems y tienen capacidad de almacenamiento. #>
			ft @{n="Nombre";e={$_.Name}},
			   @{n="Direccion";e={$_.Root}},
			   @{n="Tamano (B)";e={($_.Free + $_.Used)}},
			   @{n="Espacio Libre (B)";e={$_.Free}} 
			   <# Retorna tabla con Nombre, Direccion, Tamaño(Bytes) y Espacio Libre (Bytes) de cada FileSystem #>
		}
		'3'{
			#missing code
			
			
			
			
			Write-Host
			<# $route = Read-Host "Ingrese el FileSystem del que desee obtener el archivo mas grande." #>
			dir c:\users\alvaro\Videos -Attributes Archive -Recurse | 
			sort Length -Descending | 
			select @{n="Nombre";e={$_.Name}},
			       @{n="Tamano (B)";e={$_.Length}},
				   @{n="Ruta/Trayectoria";e={$_.FullName}} -First 5 | 
			ft
		}
		'4'{
			Get-CIMInstance Win32_OperatingSystem | 
			select @{n="Memoria Fisica Libre (B)";e={$_.FreePhysicalMemory}}, 
			       @{n="Memoria Fisica Libre (%)";e={($_.FreePhysicalMemory / $_.TotalVisibleMemorySize) * 100}},
			       @{n="Memoria Virtual Libre (B)";e={$_.FreeVirtualMemory}},
				   @{n="Memoria Virtual Libre (%)";e={($_.FreeVirtualMemory / $_.TotalVirtualMemorySize) * 100}},
			       @{n="Espacio Swap Ocupado (B)";e={$_.SizeStoredInPagingFiles}},
				   @{n="Espacio Swap Ocupado (%)";e={($_.SizeStoredInPagingFiles / `
				    ($_.SizeStoredInPagingFiles + $_.FreeSpaceInPagingFiles)) * 100}} | 
			<# #>
			fl
		}
		'5'{
			Get-NetTCPConnection | <# Obtenemos las conexiones de red #>
			where {$_.State -like "*Established*"} | <# Filtramos los que estan en estado "ESTABLISHED" #>
			measure | <# Medimos la cantidad #>
			fl @{n="Conexiones de Red Activas Actualmente";e={$_.Count}} <# Retornamos el numero de conexiones #>
		}
		'q'{
			return
		}
		default{
			Write-Warning "Por favor escriba un comando valido."
		}
	}
	}
	until($input -eq 'q')
}
end {
}