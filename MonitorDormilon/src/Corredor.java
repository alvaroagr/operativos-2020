//	Realizado por: Alvaro Andres Gomez Rey
//				   Steven Bernal Tovar

import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.Semaphore;

public class Corredor {
	
	public static void main(String[] args) {

		// Numero de estudiantes
		int n;
		// Semilla
		long seed;
		
		// Revisar que se recibe el numero de estudiantes y la semilla como parametro
		if (args.length != 2) {
			System.out.println("Sintaxis: Corredor numero_estudiantes semilla_aleatoria");
			System.exit(1);
		}
		
		n = Integer.parseInt(args[0]);
		seed = Long.parseLong(args[1]); 
		
		// Instanciar la cola
		Queue<Estudiante> queue;
		
		// Instanciar los semaforos requeridos
		Semaphore sCola;
		Semaphore sEstudiante; // Se usa para despertar al monitor
		Semaphore sMonitor; // Se usa para indicar que termino la monitoria
		
		// Instanciar arreglo de n estudiantes y al monitor
		Estudiante[] estudiantes = new Estudiante[n];
		Monitor m;
		
		// Todos los semaforos son binarios.
		sCola = new Semaphore(1,true);
		sEstudiante = new Semaphore(1,true);
		sMonitor = new Semaphore(1,true);
		
		queue = new LinkedList<Estudiante>();
		
		m = new Monitor(queue,sCola,sEstudiante, sMonitor,seed);
		for(int i=0; i<n; i++) {
			estudiantes[i] = new Estudiante(i, queue, sCola, sEstudiante, sMonitor, seed);
		}

		sEstudiante.drainPermits();		// Cuando se inicializa el programa no hay 
		sMonitor.drainPermits();		// estudiantes para que el monitor atienda,
										// y no hay monitorias terminadas.

		// Iniciar los n+1 hilos
		m.start();
		for(int i=0; i<n; i++) {
			estudiantes[i].start();
		}
//		e1.start();
//		e2.start();
//		e3.start();
//		e4.start();
//		e5.start();
//		e6.start();
		
	}

}
