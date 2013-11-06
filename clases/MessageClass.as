/**
 * Clase encargada de la carga de los mensajes
 * @author: Luis Felipe Zapata
 * @fecha: 26 de Octubre del 2013
 */
package clases 
{
	import flash.display.MovieClip;
	
	import codeCraft.core.CodeCraft;
	import codeCraft.core.Presentation;
	// oe esta es mi linea
	public class MessageClass
	{
		
		//refencia de las clases utilizadas
		private var _movieClip:MovieClipClass;
		private var _navigation:NavigationClass;
		private var _animation:AnimationClass;
		private var _escene:EsceneClass;
		
		public var presentation:MovieClip;
		public var positionAudio:int = 0;
		/* Almacenara los textos que se deben ver en los mensajes de los botones del menu cuando esten sobre ellos */
		public var textoBotonesMenu:Array = new Array(
			"Listen",
			"Read",
			"Observe",
			"Exercises",
			"Pronounce",
			"Vocabulary",
			"Video"
		);
		
		
		public function setVar(movieClipClass, navigationClass, animationClass, esceneClass):void
		{
			_movieClip = movieClipClass;
			_navigation = navigationClass;
			_animation = animationClass;
			_escene = esceneClass;
		}
		
		public function load (message:String):void{
			switch(message)
			{
				//presentacion principal
				case 'presentation':
					presentation = new MovieClip();
					positionAudio = 0;
					break;
			}
			loadMessage();
		}
		
		public function loadMessage ():void
		{
			//CodeCraft.addChild(presentation,_movieClip.windowMessage.content);
			//Presentation.load(_movieClip.windowMessage.buttonPrev,_movieClip.windowMessage.buttonNext,_movieClip.windowMessage.pagination,presentation,null,false);
			//Presentation.loadSound(AudioClass.audioArray[positionAudio]);
		}
		
		public function removeMessage ():void
		{
			//Presentation.remove();
			//_movieClip.windowMessage.pagination.text = "";
			//CodeCraft.removeChild(presentation,_movieClip.windowMessage.content);
			//presentation = null;
		}
		
		public function loadFrame (frame:*):void
		{
			//presentation.gotoAndStop(frame);
			//Presentation.reload();
		}
		
		/****************************************************************************************
		*
		* Elementos del juego de observar
		*
		****************************************************************************************/
		
		public var escenaObservar:Array = new Array(
			[
				"am","are","is","is"	
			],
			[
				"Singular","Plural"
			]
		);
		
		/****************************************************************************************
		*
		* Elementos del juego de computador
		*
		****************************************************************************************/
		
		public var escenaComputador:Array = new Array(
			[
				["What is your name?","How are you?","Are you American?","Is she Mexican?"],
				["My name is Lin.","Fine, thank you.","Yes, I am American.","No, she is not Mexican."]
			],
			[
				["You","are","America"],
				["My","name","is","Martha"],
				["What","is","your","name?"],
				["Hello!","I","am","Steve"],
				["She","is","Chinese"]
			],
			[
				["is","are","are","is","are"],
				["is","am","are","is","are"]
			],
			[
				["I", "I", "I", "I", "he", "you", "I"]
			]
			
		);
		
		
		/****************************************************************************************
		*
		* Elementos del juego de diccionario
		*
		****************************************************************************************/
		
		public var escenaDiccionario:Array = new Array(
			[
				"She is Chinese",
				"I am Colombian",
				"You are Italian",
				"He is America",				
				"Bruno is French",
				"Rafael is Mexicain"
			],
			[
				"A bag",
				"A cartridge",
				"Two calculators",
				"Three markers"
			],
			[
				"One",
				"Two",
				"Three",
				"Four",
				"Five"
			],
			[
				"Six",
				"Seven",
				"Eight",
				"Nine",
				"Ten"
			]
		);
		
	}
}