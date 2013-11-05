/**
 * Clase encargada de la precarga de todo el contenido, carga en el fotograma 1 y al finalizar inicia
 * la clase en el fotograma 2
 * @author: Luis Felipe Zapata
 * @fecha: 26 de Octubre del 2013
 * @versionCodeCraft: 
 */
package clases
{

	import flash.display.MovieClip;
	import codeCraft.core.CodeCraft;


	public class PreloaderClass extends MovieClip 
	{
		
		public function PreloaderClass () 
		{
			//LLama a la funcion que inicia y carga una precarga
			CodeCraft.initialize(this,initialize);
		}
		
		public function initialize ():void
		{
			//carga la calse que se iniciara, es de recordar que al cargar la clase de esta forma
			//no reconocera mas el stage debera ser CodeCraft.getMainObject();
			var clase:MainClass = new MainClass();
		}
	}

}