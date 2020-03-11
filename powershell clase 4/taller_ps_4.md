# TALLER 4
## EJERCICIOS
1. Mostrar una tabla de procesos que incluya únicamente los nombres de los
   procesos, sus IDs, y si están respondiendo a Windows (la propiedad
   ``Responding`` muestra eso). Haga que la tabla tome el mínimo de espacio
   horizontal, pero no permita que la información se trunque.

2. Muestre una tabla de procesos que incluya los nombres de los procesos y sus
   IDs. También incluya columnas para uso de memoria virtual y física;
   exprese dichos valores en megabytes (MB).

3. Emplee ``Get-EventLog`` para mostrar una lista de los logs de eventos
   disponibles (revise la ayuda para encontrar el parámetro que le permitirá
   obtener dicha información). Formatee la salida como una tabla que incluya
   el nombre de despliegue del log y el período de retención. Los encabezados
   de columna deben ser NombreLog y Per-Retencion.

4. Muestre una lista de servicios, de tal manera que aparezcan agrupados los
   servicios que están iniciados y los que están detenidos. Los que están
   iniciados deben aparecer primero.

5. Mostrar una lista a cuatro columnas de todos los directorios que están en
   el raíz de la unidad ``C:``

6. Cree una lista formateada de todos los archivos ``.exe`` del directorio
   ``C:\Windows``. Debe mostrarse el nombre, la información de versión, y el
   tamaño del archivo. La propiedad de tamaño se llama ``length`` en Powershell,
   pero para mayor claridad, la columna se debe llamar **Tamaño** en su listado.

7. Importe el módulo ``NetAdapter`` (empleando el comando ``Import-Module
   NetAdapter``).
   Empleando el cmdlet ``Get-NetAdapter``, muestre una lista de adaptadores no
   virtuales (adaptadores cuya propiedad Virtual sea falsa. El valor lógico
   falso es representado por Powershell como ``$False``).

8. Importe el módulo ``DnsClient``. Empleando el cmdlet ``Get-DnsClientCache``,
   muestre una lista de los registros ``A`` y ``AAAA`` que estén en el caché.
   Sugerencia: Si el caché está vacío, visite algunos sitios web para poblarlo.

9. Genere una lista de todos los archivos ``.exe`` del directorio
   ``C:\Windows\System32`` que tengan más de 5 MB.

10. Muestre una lista de parches que sean actualizaciones de seguridad.

11. Muestre una lista de parches que hayan sido instalados por el
    usuario ``Administrador``, que sean actualizaciones. Si no tiene ninguno,
    busque parches instalados por el usuario ``System``. Note que algunos parches
    no tienen valor en el campo ``Installed By``.

12. Genere una lista de todos los procesos que estén corriendo con el nombre
    **Conhost** o **Svchost**.
    
## RESPUESTAS
1. Para mostrar una tabla de procesos que incluya únicamente los nombres de los
   procesos, sus IDs, y si están respondiendo a Windows, tomando el mínimo espacio
   horizontal necesario pero sin que se trunque la información, se utiliza esto:
   ```Powershell
   get-process | ft name,id,responding -Autosize -Wrap
   ```

2. Para mostrar una tabla de procesos que incluya los nombres, IDs, memoria virtual
   y memoria física, las ultimas dos expresadas en megabytes, se utiliza esto:
   ```Powershell
   get-process | ft name,id,@{n='VM (MB)';e={$_.VM / 1MB -as [int]}}, @{n='PM (MB)';e={$_.PM / 1MB -as [int]}}
   ```
   
3. Para mostrar una lista de los logs de eventos disponibles en forma de tabla,
   incluyendo nombre de despliegue y periodo de retención con los nombres
   "NombreLog" y "Per-Retencion" se utiliza esto:
   ```Powershell
   Get-EventLog -List | ft @{n='NombreLog';e={$_.Log}}, @{n='Per-Retencion';e={$_.MinimumRetentionDays}}
   ```
   
4. Para mostrar una lista de servicios, de tal forma que esten agrupados según
   cuales están corriendo y cuales están detenidos, saliendo los que están corriendo
   primero, se utiliza esto:
   ```Powershell
   Get-Service | sort status -Descending | ft -GroupBy status
   ```
   Entiendase que la lista esta formateada como una tabla.
    
5. Para mostrar una lista a cuatro columnas de todos los directorios que están en la raíz de la unidad ```C:```
   se utiliza esto:
   ```Powershell
   dir -path "C:\" -attributes directory | fw -col 4
   ```
    
6. Para mostrar una lista formateada de todos los archivos ```.exe``` en ```C:\Windows```, incluyendo
   nombre, version y tamaño, se utiliza esto:
   ```Powershell
   dir -path "C:\Windows\*.exe" | fl name,VersionInfo,@{n='Tamano';e={$_.Length}}
   ```
   
7. ```Powershell
   Import-Module NetAdapter
   Get-NetAdapter | where {$_.Virtual -eq $false }
   ```
   
8. ```Powershell
   Import-DnsClient
   Get-DnsClientCache -Type A,AAAA
   ```
   
9. ```Powershell
   dir C:\Windows\System32\*.exe | where {$_.Length -gt 5MB}
   ```
   
10. ```Powershell
    Get-HotFix | where {$_.Description -eq "Security Update"}
    ```
    
11. ```Powershell
    Get-HotFix | where {$_.InstalledBy -like "*System*" -and $_.Description -Like "Update"}
    ```
    
12. ```Powershell
    Get-Process | where {$_.Name -like "*Conhost*" -or $_.Name -like "*Svchost*"}
    ```
