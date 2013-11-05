/**
 * Clase encargada de la carga de las escenas y todos los contenidos, la clase fue creada para poder
 * darle uso a la funcion que almacena la posicion actual en la que se quedo el aprendiz para volver
 * a cargarla de nuevo
 * @author: Luis Felipe Zapata
 * @fecha: 26 de Octubre del 2013
 */
package clases
{

	import flash.display.MovieClip;
	import codeCraft.core.CodeCraft;
	import codeCraft.utils.Arrays;
	import codeCraft.debug.Debug;
	import codeCraft.media.Audio;


	public class EsceneClass extends MovieClip 
	{
		
		//refencia de las clases utilizadas
		private var _movieClip:MovieClipClass;
		private var _navigation:NavigationClass;
		private var _animation:AnimationClass;
		private var _message:MessageClass;
		
		/* Indica el tipo de accion que se esta realizando, si el agregar una escena o si se esta eliminando */
		public var accionEscena:String = "agregar";
		/* Indicara las escenas disponibles en esta actividad */
		public var escenasMultimedia:Array = new Array(
			"inicio",
			"audio",
			"lectura",
			"observar1",
			"observar2",
			"computador1",
			"computador2",
			"computador3",
			"computador4",
			"computador5",
			"pronunciacion",
			"diccionario",
			"video"
		);
		
		/* Almacenar las escenas a cargar con los botones del menu en el orden que se van a mostrar que es el mismo que el de la instancia de los botnes */
		public var escenasCargarMultimedia:Array = new Array(
			"audio",
			"lectura",
			"observar1",
			"computador1",
			"pronunciacion",
			"diccionario",
			"video"
		);
		
		public function setVar(movieClipClass, navigationClass, animationClass, messageClass):void
		{
			_movieClip = movieClipClass;
			_navigation = navigationClass;
			_animation = animationClass;
			_message = messageClass;
		}
		
		/**
		* Se encarga de cargar las escenas que se van a a trabajar
		*/
		public function cargarEscena ():void
		{
			accionEscena = "agregar";
			//se identifica cual es el estado mas avanado
			var estado1:int = Arrays.indexOf(escenasMultimedia,_navigation.escenaActual);
			var estado2:int = Arrays.indexOf(escenasMultimedia,SystemClass.estadoActual);
			if (estado1 > estado2)
			{
				//se indica la seccion actual escribiendola en la memoria
				SystemClass.memoriaUsuario.data.escenaActual = _navigation.escenaActual;
				SystemClass.memoriaUsuario.flush();
				SystemClass.estadoActual = _navigation.escenaActual;
			}
			cargarHastaEscena(SystemClass.estadoActual);
			
			switch(_navigation.escenaActual)
			{
				case "inicio":
					_navigation.iniciarEscenaInicio();
				break;
				case "observar1":
					_movieClip.cargarEscenario();
					_movieClip.cargarMenu();
					_movieClip.cargarJuego();
					_navigation.iniciarObservar1();
				break;
				default:
					_movieClip.cargarEscenario();
					_movieClip.cargarMenu();
					_movieClip.cargarInstrucciones();				
				break;
			}
			
		}
		
		/**
		* Se encarga de limpiar el escenario actual y de llamar a la funcion para cargar el nuevo escenario
		* @para escenaCambiar Indica el escenario que se va a cambiar
		*/
		public function cambioEscena (escenaCambiar:String):void 
		{
			accionEscena = "eliminar";
			//se eliminan las escenas que tiene los juegos cargados externamente
			_navigation.eliminarPronunciacion();
			_navigation.eliminarDiccionario();
			_navigation.eliminarComputador();
			_navigation.eliminarObservar();
			//elimina elementos generales
			_navigation.eliminarListenerBotonesMenu();
			_navigation.eliminarListenerBotonSonido();
			_navigation.eliminarListenerOcultarPopUp();
			_navigation.eliminarListenerInstrucciones();
			_movieClip.eliminarControlGrabacion();
			_movieClip.eliminarMediaPlayer();
			_animation.juegoOut();
			_animation.instruccionesOut();
			
			Audio.playAudio(null,0);

			_navigation.escenaActual = escenaCambiar;
			_animation.restaurarEscuela();
		}
		
		/**
		* Indica hasta que escena se realiza la carga de los listener y la activaci�n de los botones
		*/
		private function cargarHastaEscena (escena:String = "inicio"):void 
		{
			//se verifica que no este tratando de cargar la escenas del computador
			if(escena.substr(0,escena.length - 1) == "computador")
			{
				escena = "computador1";
			}
			if(escena.substr(0,escena.length - 1) == "observar")
			{
				escena = "observar1";
			}
			var posicionEscena:int = Arrays.indexOf(escenasCargarMultimedia,escena) + 1;
			//se llena el array de valores true desde 0 hasta la posicion que entregue el escenario 
			//actual, el primer parametro es el valor a llenar desde 0 hasta el escenario actual,
			//el segundo el tama�o del array que es igual a la cantidad de botones del menu
			//el tecero el valor inicial 0 y luego el valor hasta donde se llenara y por ultimo el valor
			//que se llenara en los demas botones para desactivarlo
			_movieClip.estadoBotonesMenu = Arrays.fill(true,_movieClip.botonesMenu.length,0,posicionEscena,false);
		}
		
	}

}