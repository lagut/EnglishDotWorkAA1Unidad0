/**
 * @author: Luis Felipe Zapata
 * @fecha: 26 de Octubre del 2013
 */
package clases
{
	import codeCraft.core.CodeCraft;
	import codeCraft.debug.Debug;
	import codeCraft.media.Audio;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.SharedObject;
	

	public class MainClass extends MovieClip 
	{

		private var _movieClip:MovieClipClass;
		private var _navigation:NavigationClass;
		private var _animation:AnimationClass;
		private var _message:MessageClass;
		private var _escene:EsceneClass;

		public function MainClass () 
		{
			
			//descomentar estas lineas si no se carga por medio de la clase PreloadClass
			/*
			this.addEventListener(Event.ADDED_TO_STAGE, stageLoaded);
			}
			public function stageLoaded (event:Event):void{
			this.removeEventListener (Event.ADDED_TO_STAGE, stageLoaded);
			CodeCraft.initialize (this);
			*/
			Debug.initialize ();
			SystemClass.initialize("AA1Unidad0");
			initializeClass ();
		}
		//se inicia la clase por separado por si se aplica una funcion antes de iniciar todo
		public function initializeClass ():void 
		{
			_movieClip = new MovieClipClass();
			_navigation = new NavigationClass();
			_animation = new AnimationClass();
			_message = new MessageClass();
			_escene = new EsceneClass();
			
			_movieClip.setVar (_navigation, _animation, _message, _escene);
			_navigation.setVar (_animation, _movieClip, _message, _escene);
			_animation.setVar (_movieClip, _navigation, _message, _escene);
			_message.setVar (_movieClip, _navigation, _animation, _escene);
			_escene.setVar (_movieClip, _navigation, _animation, _message);
			
			//Iniciamos los valores de las variables de audio
			AudioClass.inciarAudios();
			initializePresentation ();
		}
		//se inicia los demas contenidos
		public function initializePresentation ():void 
		{
			//esta linea es temporar para asi poder realizar pruebas de multimedia y grabacion de memoria 
			SystemClass.memoriaUsuario.data.escenaActual = "computador4";
			//SystemClass.memoriaUsuario.data.nombre = "gato";
			//se lee el archivo de memoria almacenada para verificar cargar el nuevo valor
			if(SystemClass.memoriaUsuario.data.escenaActual == undefined)
			{
				SystemClass.estadoActual = "inicio";
				SystemClass.memoriaUsuario.data.escenaActual = "inicio";
				SystemClass.memoriaUsuario.flush();
			}
			else 
			{
				SystemClass.estadoActual = SystemClass.memoriaUsuario.data.escenaActual;
			}
			_navigation.escenaActual = SystemClass.estadoActual;
			_escene.cargarEscena();
			//se inicia el audio del fondo
			Audio.playAudio(AudioClass.audioArray[2],1,true);
		}
	}
}