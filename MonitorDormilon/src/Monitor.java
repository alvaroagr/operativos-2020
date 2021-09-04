//	Realizado por: Alvaro Andres Gomez Rey
//				   Steven Bernal Tovar

import java.util.Queue;
import java.util.Random;
import java.util.concurrent.Semaphore;

public class Monitor extends Thread {

	/**
	 * Cola donde esperan los estudiantes.<br>
	 * Si solo pueden haber n estudiantes esperando en el corredor, la capacidad maxima de la cola debe ser de n+1.
	 */
	private Queue<Estudiante> cola;
	
	private Random aleatorio;
	
	/**
	 * Semaforo para acceder a modificar la cola.
	 */
	private Semaphore sCola;
	
	/**
	 * Semaforo para informar al monitor que un estudiante espera ser atendido.
	 */
	private Semaphore sEstudiante; // Los estudiantes lo usan para decirme que ya se fueron.
	
	/**
	 * Semaforo para informar al estudiante que la monitoria termino.
	 */
	private Semaphore sMonitor; // Usado por todos los estudiantes.
	
	
	/**
	 * Constructor del monitor
	 * @param cola Quueue donde se ubican los estudiantes. Si pueden haber n estudiantes en el corredor, su capacidad maxima sera de n + 1.
	 * @param sCola Semaforo para obtener permiso para modificar la cola.
	 * @param sEstudiante Semaforo para informar al monitor que el estudiante espera ser atendido.
	 * @param sMonitor Semaforo para informar al estudiante que la monitoria termino.
	 * @param seed Semilla para la generacion de numeros aleatorios.
	 */
	public Monitor(Queue<Estudiante> cola, Semaphore sCola, Semaphore sEstudiante,
			Semaphore sMonitor, long seed) {
		super();
		this.cola = cola;
		this.aleatorio = new Random(seed);
		this.sCola = sCola;
		this.sEstudiante = sEstudiante;
		this.sMonitor = sMonitor;
	}


	public void run() {
		while(true) {
			try {
				if(cola.size() == 0) {																	// Si la cola esta vacia.
					System.out.println("[MO] No hay nadie, voy a dormir.");								//   • Dormir.
				}
				sEstudiante.acquire();																	// Esperar a que un estudiante este listo para ser atendido.
				System.out.println("[MO] Que entre el siguiente estudiante. Empieza la monitoria.");
				sleep(Math.abs((aleatorio.nextInt() % 1000)));											// Realizar la monitoria. Esta dura una cantidad aleatoria de tiempo.
				sCola.acquire();																		// Mirar si se puede modificar la cola. Si hay alguien mas haciendolo, esperar.	
				cola.poll();																			// Sacar al estudiante atendido de la cola.
				sCola.release();																		// Indicar que otros pueden acceder a leer/modificar la cola.
				sMonitor.release(); 																	// Informar al estudiante atendido que termino la monitoria.
			} catch (InterruptedException e) {
			}
			
		}
		
	}
	
	
}
