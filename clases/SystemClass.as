/**
 * Clase encargada del almacenamiento de informacion en memoria del usuario
 * @author: Luis Felipe Zapata
 * @fecha: 26 de Octubre del 2013
 */
package clases
{
	import flash.display.MovieClip;
	import flash.net.SharedObject;
	import codeCraft.debug.Debug;

	public class SystemClass 
	{
		private static var _nameFile:String;
		public static var memoriaUsuario:SharedObject;
		//linea nueva
		/* Indicara cual es el mensaje del estadoActual mas avanzado para almacenarlo */
		public static var estadoActual:String = "";
		
		public static function initialize (nameFile:String):void 
		{
			try
			{
				_nameFile = nameFile;
				memoriaUsuario = SharedObject.getLocal(_nameFile);
			}
			catch(error:Error)
			{
				Debug.print("Error al cargar el objeto compartido.","SystemClass.initialize","Falla Coneccion ");
			}
		}
		
	}

}