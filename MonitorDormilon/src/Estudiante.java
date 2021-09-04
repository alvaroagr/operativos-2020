//	Realizado por: Alvaro Andres Gomez Rey
//				   Steven Bernal Tovar

import java.util.Queue;
import java.util.Random;
import java.util.concurrent.Semaphore;

public class Estudiante extends Thread{
	
	/**
	 * Identificador del estudiante.
	 */
	private int id;
	
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
	private Semaphore sEstudiante;
	
	/**
	 * Semaforo para informar al estudiante que la monitoria termino.
	 */
	private Semaphore sMonitor;
	
	/**
	 * Constructor del estudiante
	 * @param id Identificador del estudiante en consola.
	 * @param cola Quueue donde se ubican los estudiantes. Si pueden haber n estudiantes en el corredor, su capacidad maxima sera de n + 1.
	 * @param sCola Semaforo para obtener permiso para modificar la cola.
	 * @param sEstudiante Semaforo para informar al monitor que el estudiante espera ser atendido.
	 * @param sMonitor Semaforo para informar al estudiante que la monitoria termino.
	 * @param seed Semilla para la generacion de numeros aleatorios.
	 */
	public Estudiante(int id, Queue<Estudiante> cola, Semaphore sCola, Semaphore sEstudiante,
			Semaphore sMonitor, long seed) {
		super();
		this.id = id;
		this.cola = cola;
		this.aleatorio = new Random(seed);
		this.sCola = sCola;
		this.sEstudiante = sEstudiante;
		this.sMonitor = sMonitor;
	}


	public void run() {
		while(true) {
			try {
				System.out.println("[E"+id+"] Necesito ayuda. Voy a buscar al monitor.");
				sCola.acquire();																									// El estudiante mira si puede leer/modificar la cola. Si hay alguien mas haciendolo, espera.	
				if(cola.size() == 4) { 																								// Si la cola esta llena:
					sCola.release();																								//   • El estudiante indica que otros pueden acceder a leer/modificar la cola.
					System.out.println("[E"+id+"] No hay cupo. Voy a programar en sala");
				} else {																											// de lo contrario:
					if(cola.size() == 0) { 																							//   • Si no hay nadie (y el monitor esta dormido):
						System.out.println("[E"+id+"] Despierte señor monitor, que necesito ayuda.");								//     - Ingreso a donde el monitor y lo despierto.
					} else { 																										//   • de lo contrario:
						System.out.println("[E"+id+"] Entro a cola. Hay "+ (cola.size()) +" silla(s) ocupadas en el corredor.");	//     - Ingreso al corredor. Indico cuantas sillas ocupadas hay.
					}
					cola.add(this);																									//   • El estudiante se registra en la cola.
					sCola.release();																								//   • El estudiante indica que otros pueden acceder a leer/modificar la cola.
					sEstudiante.release();																							//   • El estudiante indica al monitor que esta listo para que lo atiendan.
					sMonitor.acquire(); 																							//   • El estudiante espera a que termine la monitoria.
					System.out.println("[E"+id+"] Termine. Voy a programar en sala.");
				}
				sleep(Math.abs((aleatorio.nextInt() % 1000)));																		// El estudiante programa en sala por una duracion aleatoria de tiempo.
			} catch (Exception e) {
			}
			
		}
		
		
	}
	
	

}
