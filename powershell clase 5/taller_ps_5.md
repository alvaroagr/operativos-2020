# TALLER 5 
## EJERCICIOS
1. ¿Cuál clase puede emplearse para consultar la dirección IP de un adaptador de red? ¿Posee dicha clase algún método para liberar un préstamo de dirección (lease) DHCP?

2. Despliegue una lista de parches empleando WMI (Microsoft se refiere a los parches con el nombre quick-fix engineering). Es diferente el listado al que produce el cmdlet Get-Hotfix?

3. Empleando WMI, muestre una lista de servicios, que incluya su status actual, su modalidad de inicio, y las cuentas que emplean para hacer login.

4. Empleando cmdlets de CIM, liste todas las clases del namespace SecurityCenter2, que tengan product como parte del nombre.

5. Empleando cmdlets de CIM, y los resultados del ejercicio anterior, muestre los nombres de las aplicaciones antispyware instaladas en el sistema. También puede consultar si hay productos antivirus instalados en el sistema.

## RESPUESTAS
1.	Se puede emplear la clase ```Win32_NetworkAdapterConfiguration``` para consultar la direccion IP de un adaptador de red. Dicha clase posee el metodo ```ReleaseDHCPLease``` para liberar un prestamo de direccion DHCP.

2.	Para desplegar una lista de parches, empleando WMI, se usa el siguiente cmdlet:
	```Powershell
	Get-WmiObject Win32_QuickFixEngineering
	```
	La lista que despliega es la misma que se obtiene usando ```Get-Hotfix```
	
3.	Para generar una lista de servicios, que incluya su status actual, su modalidad de inicio, y las cuentas que emplean para hacer login, empleado WMI, se utiliza lo siguiente:
	```Powershell
	Get-WmiObject Win32_Service | select Name, Status, StartMode, StartName | sort Name
	```
	
4.	Para listar todas las clases del namespace SecurityCenter2, usando CIM, que tengan **product** como parte del nombre, se utiliza este cmdlet:
	```Powershell
	Get-CimClass -Namespace root/SecurityCenter2 | where CimClassName -Like '*product*'
	```
	
5. Para mostrar los nombres de las aplicaciones antispyware instaladas en el sistema, usando CIM, se usa este cmdlet:
	```Powershell
	Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiSpywareProduct
	```
	Y para mostrar los nombres de las aplicaciones antivirus instaladas en el sistema, se usa este cmdlet:
	```Powershell
	Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct
	```