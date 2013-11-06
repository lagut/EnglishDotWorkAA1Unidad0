
/**
 * Clase encargada de la navegacion por botones del la presentacio
 * @author: Luis Felipe Zapata
 * @fecha: 26 de Octubre del 2013
 */
package clases 
{
	
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import codeCraft.core.CodeCraft;
	import codeCraft.core.Presentation;
	import codeCraft.display.Button;
	import codeCraft.display.Menu;
	import codeCraft.events.Events;
	import codeCraft.media.Audio;
	import codeCraft.text.CheckInput;
	import codeCraft.text.Texts;
	import codeCraft.utils.Arrays;
	import codeCraft.utils.Collision;
	import codeCraft.utils.Magnet;
	import codeCraft.utils.Timers;
	
	public class NavigationClass 
	{
		//refencia de las clases utilizadas
		private var _movieClip:MovieClipClass;
		private var _animation:AnimationClass;
		private var _message:MessageClass;
		private var _escene:EsceneClass;
		
		/**/
		public var exhibitionX:Number = 0;
		public var exhibitionY:Number = 0;
		/* Indicara la poscion actual de la presentacion a cargar */
		public var escenaActual:String = "inicio";
		/* indica la cantidad de elemenos cargados  de la escena 1*/
		public var positionIntro:Number = 0;
		
		
		/* Almacenara las funciones que se volvera para cuando termine de ejecutarse las instrucciones de cada escena */
		public var funcionesIniciarEscena:Array = new Array(
			iniciarEscenaInicioAnimacion,
			iniciarEscenaAudio,
			iniciarEscenaLectura,
			iniciarObservar1,
			iniciarObservar2,			
			iniciarComputador1,//carga la escena pero se basa en la posicion de estado actual para indicar cual cargar
			iniciarComputador2,
			iniciarComputador3,
			iniciarComputador4,
			iniciarComputador5,
			iniciarPronunciacion,
			iniciarDiccionario,
			iniciarEscenaVideo
		);
		
		public function setVar (animationClass, movieClipClass, messageClass, esceneClass):void 
		{
			_animation = animationClass;
			_movieClip = movieClipClass;
			_message = messageClass;
			_escene = esceneClass;
		}
		
		
		
		/****************************************************************************************
		*
		* Manejo de las instrucciones
		*
		****************************************************************************************/
		
		
		
		public function listenerInstrucciones():void
		{			
			Events.listener(_movieClip.ventanaInstrucciones.ventana.botonCerrar,MouseEvent.CLICK, cerrarVentanaInstrucciones,true,true);
			//se activa el foco para que cualquier tipo de introduccion o presion de teclas se diriga al stage
			CodeCraft.focoActive();
			Events.listener(CodeCraft.getMainObject().stage,KeyboardEvent.KEY_DOWN, cerrarVentanaInstruccionesTeclado);
		}
		
		/**
		* Cierra la ventana de mensajes de las instrucciones, elimina listener y  inici las animaciones para ocultar la ventana
		*/
		public function eliminarListenerInstrucciones ():void 
		{
			//se verifica que la ventana del mensaje de instrucciones no se haya eliminado
			if (_movieClip.ventanaInstrucciones != null)
			{
				Events.removeListener(_movieClip.ventanaInstrucciones.ventana.botonCerrar,MouseEvent.CLICK, cerrarVentanaInstrucciones,true);
				Events.removeListener(CodeCraft.getMainObject().stage,KeyboardEvent.KEY_DOWN, cerrarVentanaInstruccionesTeclado);
				Audio.playAudio(null,0);
				_animation.detenerBotonEscala();
				_animation.instruccionesOut();
			}
		}
		
		public function instruccionesAudioCompleto ():void 
		{
			_movieClip.menuOpciones.botonSonido.gotoAndStop("silencio");
			//se cambia el volumen del canal para evitar que se tenga que realizar dos veces clic para que pueda reproducir
			Audio.setVolumenPresentation(0);
			_animation.animarBotonEscala();
		}
		
		/**
		* Inicia el proceso de cerrado y elminacion de la ventana de mensajes de instrucciones
		* @param event Object del MouseEvent
		*/
		private function cerrarVentanaInstrucciones (event:MouseEvent):void 
		{
			eliminarListenerInstrucciones();
		}
		
		/**
		* Inicia el proceso de cerrado y elminacion de la ventana de mensajes de instrucciones pero con el teclado
		* verifica si la tecla que se presiona es la flecha derecha para continuar o la tecla enter
		* @param event Object del KeyboardEvent
		*/
		private function cerrarVentanaInstruccionesTeclado(event:KeyboardEvent):void 
		{
			//13 es la tecla enter, y 39 la flecha derecha
			if(event.keyCode == 13 || event.keyCode == 39)
			{
				eliminarListenerInstrucciones();
			}
		}
		
		
		
		
		/****************************************************************************************
		*
		* Manejo de los mensajes emergentes del menu
		*
		****************************************************************************************/
		
		
		
		
		/**
		 * Carga los dos listener que detectan cuando se sale del boton o se mueve el mouse dentro de el
		 * @param boton Hace refencia al boton en el que se encuentra actualmente el mouse en el menu
		 */
		public function listenerOcultarPopUp ():void 
		{
			Events.listener(_movieClip.botonesMenu,MouseEvent.MOUSE_OUT, quitarPopUp,false,false);
			Events.listener(_movieClip.botonesMenu,MouseEvent.MOUSE_OVER, mostrarPopUp,false,false);
			Events.listener(_movieClip.botonesMenu,MouseEvent.MOUSE_MOVE, moverPopUp,false,false);
			//desactivamos el modo boton de las opciones que no se pueden utilizar
			Button.button(_movieClip.botonesMenu,_movieClip.estadoBotonesMenu);
		}
		
		/**
		 * elimina el lister del boton y llama a la funcion encargada de eliminar el popUp
		 * @param event Object del MouseEvent
		 */
		public function eliminarListenerOcultarPopUp ():void 
		{
			Events.removeListener(_movieClip.botonesMenu,MouseEvent.MOUSE_OUT, quitarPopUp,false);
			Events.removeListener(_movieClip.botonesMenu,MouseEvent.MOUSE_OVER, mostrarPopUp,false);
			Events.removeListener(_movieClip.botonesMenu,MouseEvent.MOUSE_MOVE, moverPopUp,false);
			_movieClip.eliminarPopUp();
		}
		
		/**
		 * Detecta cuando el mouse se meuve para asi mover el popUp al lado del mouse hasta detectar que se
		 * salio del boton y proceder a eliminarlo
		 * @param event Object del MouseEvent
		 */
		private function moverPopUp (event:MouseEvent):void
		{
			//se verifica si ya existe el elemento antes de moverlo
			if(_movieClip.popUpBotonesMenu != null)
			{
				_movieClip.popUpBotonesMenu.x = CodeCraft.getMainObject().mouseX;
				_movieClip.popUpBotonesMenu.y = CodeCraft.getMainObject().mouseY;
			}
		}
		
		/**
		 * indica que se salio del boton y elimina el popUp
		 * @param event Object del MouseEvent
		 */
		private function quitarPopUp (event:MouseEvent):void 
		{
			_movieClip.eliminarPopUp();
		}
		
		/**
		 * indica que se esta sobre el boton y carga el popUp
		 * @param event Object del MouseEvent
		 */
		private function mostrarPopUp (event:MouseEvent):void 
		{
			_movieClip.cargarPopUp(event.currentTarget);
		}
		
		

		/****************************************************************************************
		*
		* Listener de los botones del menu
		*
		****************************************************************************************/
		
		
		
		/**
		* Carga el listener para el boton de sonido  despues de activar la animacion de la escala
		* para poder eliminar la animacion y restaurar el boton a su estado original
		*/
		public function listenerBotonSonido ():void 
		{
			Events.listener(_movieClip.menuOpciones.botonSonido,MouseEvent.CLICK,reiniciarSonidoInstrucciones,false,false);
		}
		
		/**
		* Elimina el listener que tiene el boton de sonido, que le fue asignado en las instrucciones
		*/
		public function eliminarListenerBotonSonido ():void
		{
			//se restaura el boton y el volumen del canal de audio de la presentacion y elimina el listener
			Audio.setVolumenPresentation(1);
			_animation.detenerBotonEscala();
			_movieClip.menuOpciones.botonSonido.gotoAndStop("normal");
			Events.removeListener(_movieClip.menuOpciones.botonSonido,MouseEvent.CLICK,reiniciarSonidoInstrucciones,false);
		}
		
		/**
		* Se encarga de eliminar el listener del boton de sonido y tambien de eliminar la animacion
		* que hace el efecto de escala, y tambien reiniciar el audio de las instrucciones, acccion que realiza la libreria
		*/
		private function reiniciarSonidoInstrucciones (event:MouseEvent):void 
		{
			Events.removeListener(_movieClip.menuOpciones.botonSonido,MouseEvent.CLICK,reiniciarSonidoInstrucciones,false);
			_animation.detenerBotonEscala();
			//se vuelve a cargar el listener por si se reproduce el audio de nuevo realice la animacion
			Audio.playComplete(0,detenerBotonSonido);
		}
		
		private function detenerBotonSonido ():void 
		{
			_movieClip.menuOpciones.botonSonido.gotoAndStop("silencio");
			//se cambia el volumen del canal para evitar que se tenga que realizar dos veces clic para que pueda reproducir
			Audio.setVolumenPresentation(0);
		}
	
		/**
		* Carga los listner que hacen el cambio de las escenas
		*/
		public function listenerBotonesMenu():void 
		{
			//no se activa el modo boton para solo activarlo a los elementos que este permitidos su uso
			Events.listener(_movieClip.botonesMenu,MouseEvent.CLICK, botonMenuPresionado,true,true);
			//desactivamos el modo boton de las opciones que no se pueden utilizar
			Button.button(_movieClip.botonesMenu,_movieClip.estadoBotonesMenu,true);
		}
		
		/**
		* Elimina los listener del menu que hacen el cambio de escena
		*/
		public function eliminarListenerBotonesMenu ():void 
		{
			Events.removeListener(_movieClip.botonesMenu,MouseEvent.CLICK, botonMenuPresionado,true);
		}
			
		/**
		* eealiza el cambio de escena, si el boton que se presiona es la escena actual no lo carga
		* @param event Object del MouseEvent
		*/
		private function botonMenuPresionado (event:MouseEvent):void
		{
			_animation.detenerAnimacionEscalaBotonesMenu();
			//Se busca la posicion del boton del array y se le agrega un 1 para poder hacer el cambio de escena
			//ya que el array dela escena tiene un valor de mas al array de los botones de la escena
			var posicionEscena:int = Arrays.indexOf(_movieClip.botonesMenu,event.currentTarget);
			//se usa apra indicar si se debe cargar o no se debe cargar por ser una escena actual
			var cargar:Boolean = true;
			var nombreEscena:String = escenaActual;
			if(escenaActual.substr(0,escenaActual.length - 1) == "computador")
			{
				nombreEscena = "computador1";
			}
			if(escenaActual.substr(0,escenaActual.length - 1) == "observar")
			{
				nombreEscena = "observar1";
			}
			if(_escene.escenasCargarMultimedia[posicionEscena] == nombreEscena)
			{
				cargar = false;
			}
			
			if(cargar && _movieClip.estadoBotonesMenu[posicionEscena])
			{
				_escene.cambioEscena(_escene.escenasCargarMultimedia[posicionEscena]);
			}
		}
		
		
		
		
		/****************************************************************************************
		*
		* Seccion de la escena incial
		*
		****************************************************************************************/
		
		
		
		public var Escena1:MovieClip;
		public var inicialEscena:int=1;
		
		public function iniciarEscenaInicio ():void
		{
			_movieClip.configurarEscenainicio();
			
		};
		
		public function animarEscenas(escena:int):void{
			switch(escena){
				case 1:
					TweenMax.to(Escena1,1.2,{scaleX:7,scaleY:7,x:-3062,y:-3031});
					break;
				case 2:
					TweenMax.to(Escena1,1.2,{scaleX:2.9,scaleY:2.9,x:-1277,y:-880});
					break;
				case 3:
					TweenMax.to(Escena1,4.2,{scaleX:2.9,scaleY:2.9,x:-1569,y:-880});
					break;
				case 4:
					TweenMax.to(Escena1,1.2,{scaleX:7,scaleY:7,x:-4380,y:-3100});
					break;
				case 5:
					TweenMax.to(Escena1,1.2,{scaleX:2.9,scaleY:2.9,x:-1256,y:-919});
					break;
				case 6:
					TweenMax.to(Escena1,1.2,{scaleX:7,scaleY:7,x:-4380,y:-3040});
					break;
				case 7:
					TweenMax.to(Escena1,3.8,{scaleX:7,scaleY:7,x:-3800,y:-2900});
					break;
				case 8:
					TweenMax.to(Escena1,3,{scaleX:1,scaleY:1,x:0,y:0});
					trace("final de la animacion");
					audioEscenaAudioCompleto();
					break;
				
			}
		}
		
		public function nextEscena():void{
			inicialEscena++;
			animarEscenas(inicialEscena);
		}
		
		public function detectar(e:Event):void{
			//Eventos Animacion Gestos Escenas
			if(Escena1.escena.currentFrame == 240){
				Escena1.escena.yoko.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.yoko.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.yoko.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
			}
			
			if(Escena1.escena.currentFrame == 291){
				Escena1.escena.carola.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.gotoAndPlay(2);
				Escena1.escena.carola.pelo.gotoAndPlay(2);		
				
				
			}
			if(Escena1.escena.currentFrame == 439){
				Escena1.escena.yoko.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.yoko.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.yoko.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 543){
				Escena1.escena.carola.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.gotoAndPlay(2);
				Escena1.escena.carola.pelo.gotoAndPlay(2);
				
			}
			if(Escena1.escena.currentFrame == 625){
				Escena1.escena.yoko.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.yoko.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.yoko.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 704){
				Escena1.escena.carola.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.gotoAndPlay(2);
				Escena1.escena.carola.pelo.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 794){
				Escena1.escena.yoko.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.yoko.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.yoko.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1031){
				Escena1.escena.kevin.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.kevin.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.kevin.boca.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1081){
				Escena1.escena.carola.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.gotoAndPlay(2);
				Escena1.escena.carola.pelo.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1031){
				Escena1.escena.kevin.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.kevin.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.kevin.boca.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1188){
				Escena1.escena.kevin.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.kevin.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.kevin.boca.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1225){
				Escena1.escena.angelo.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.angelo.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.angelo.boca.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1327){
				Escena1.escena.carola.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.gotoAndPlay(2);
				Escena1.escena.carola.pelo.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1365){
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.gotoAndPlay(2);
				Escena1.escena.carola.pelo.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1393){
				Escena1.escena.carola.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.carola.cabeza.gotoAndPlay(2);
				Escena1.escena.carola.pelo.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1415){
				Escena1.escena.kevin.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.kevin.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.kevin.boca.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1454){
				Escena1.escena.angelo.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.angelo.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.angelo.boca.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1574){
				Escena1.escena.yoko.cabeza.cabeza.boca.gotoAndPlay(2);
				Escena1.escena.yoko.cabeza.cabeza.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.yoko.cabeza.cabeza.ojos.ojo2.gotoAndPlay(2);
			}
			if(Escena1.escena.currentFrame == 1643){
				Escena1.escena.kevin.ojos.ojo1.gotoAndPlay(2);
				Escena1.escena.kevin.ojos.ojo2.gotoAndPlay(2);
				Escena1.escena.kevin.boca.gotoAndPlay(2);
			}
			
			//Eventos Animacion Movimiento de camara.
			if(Escena1.escena.currentFrame==60){
				animarEscenas(inicialEscena);
			}
			if(Escena1.escena.currentFrame==101){
				inicialEscena++;
				animarEscenas(inicialEscena);
			}
			if(Escena1.escena.currentFrame==291){
				inicialEscena++;
				animarEscenas(inicialEscena);
			}
			if(Escena1.escena.currentFrame==385){
				inicialEscena++;
				animarEscenas(inicialEscena);
			}
			if(Escena1.escena.currentFrame==776){
				inicialEscena++;
				animarEscenas(inicialEscena);
			}
			if(Escena1.escena.currentFrame==989){
				inicialEscena++;
				animarEscenas(inicialEscena);
			}
			if(Escena1.escena.currentFrame==1661){
				inicialEscena++;
				animarEscenas(inicialEscena);
			}
			if(Escena1.escena.currentFrame==1780){
				inicialEscena++;
				animarEscenas(inicialEscena);//Escena1.escena.stop();
				
				Escena1.escena.removeEventListener(Event.ENTER_FRAME,detectar);
			}
		}
		
		

		public function iniciarEscenaInicioAnimacion():void 
		{
			_animation.animacionInicioIn();
		}

		public function listenerVentanaInicio ():void 
		{
			Events.listener(_movieClip.ventanaInicio.ventana.botonNext,MouseEvent.CLICK, eliminarListenerVentanaInicio, true, true);
			Events.listener(CodeCraft.getMainObject().stage, KeyboardEvent.KEY_DOWN, eliminarListenerVentanaInicioTeclado)
		}
		
		private function eliminarListenerVentanaInicio (event:MouseEvent):void 
		{
			Events.removeListener(CodeCraft.getMainObject().stage, KeyboardEvent.KEY_DOWN, eliminarListenerVentanaInicioTeclado)
			Events.removeListener(_movieClip.ventanaInicio.ventana.botonNext,MouseEvent.CLICK, eliminarListenerVentanaInicio, true);
			_animation.ventanaInicioOut();
		}
		private function eliminarListenerVentanaInicioTeclado (event:KeyboardEvent):void 
		{
			Events.removeListener(CodeCraft.getMainObject().stage, KeyboardEvent.KEY_DOWN, eliminarListenerVentanaInicioTeclado)
			Events.removeListener(_movieClip.ventanaInicio.ventana.botonNext,MouseEvent.CLICK, eliminarListenerVentanaInicio, true);
			_animation.ventanaInicioOut();
		}
		
		public function listenerEscenaInicio():void{
			CodeCraft.getMainObject().addEventListener(MouseEvent.MOUSE_DOWN, exhibitionDow);
			CodeCraft.getMainObject().addEventListener(MouseEvent.MOUSE_UP, exhibitionUp);
			_movieClip.escenaInicio.module1.doubleClickEnabled = true;
			_movieClip.escenaInicio.module1.buttonMode = true;
			_movieClip.escenaInicio.module1.mouseChildren = false;
			Events.listener(_movieClip.escenaInicio.module1,MouseEvent.DOUBLE_CLICK, eliminarEscenaInicio,false,false);
		}
		
		public function eliminarEscenaInicio(event:MouseEvent):void
		{
			CodeCraft.getMainObject().removeEventListener(MouseEvent.MOUSE_DOWN, exhibitionDow);
			CodeCraft.getMainObject().removeEventListener(MouseEvent.MOUSE_UP, exhibitionUp);
			Events.removeListener(_movieClip.escenaInicio.module1,MouseEvent.DOUBLE_CLICK, eliminarEscenaInicio);
			_animation.animacionDetenerAlumbarEscenaInicio();
			_movieClip.eliminarEscenaInicio();
			//se silencia el canal de audio 0
			Audio.playAudio(null,0);
			_movieClip.estadoBotonesMenu[1] = true;
			escenaActual = "audio";
			_escene.cargarEscena();
			
		}
		
		private function exhibitionDow (event:MouseEvent):void 
		{
			_movieClip.escenaInicio.startDrag();
			_movieClip.escenaInicio.addEventListener(Event.ENTER_FRAME, detectLimit);
			CodeCraft.getMainObject().addEventListener(Event.MOUSE_LEAVE, mouseLeave);
		}
		
		private function exhibitionUp (event:MouseEvent):void 
		{
			stopExhibition();
		}
		
		//Limit draggind the exhibition in the stage
		private function detectLimit (event:Event):void 
		{
			if(_movieClip.escenaInicio.x < -500 || _movieClip.escenaInicio.x > 1579 || _movieClip.escenaInicio.y < -179  || _movieClip.escenaInicio.y > 953) 
				{
				_movieClip.escenaInicio.x = exhibitionX;
				_movieClip.escenaInicio.y = exhibitionY;
				stopExhibition();
			}
			else
				{
				exhibitionX = _movieClip.escenaInicio.x;
				exhibitionY = _movieClip.escenaInicio.y;
			}
		}
		
		//Detects if the mouse out stage dragging exhibition
		private function mouseLeave(event:Event):void
		{
			CodeCraft.getMainObject().removeEventListener(Event.MOUSE_LEAVE, mouseLeave);
			stopExhibition();
		}
		
		private function stopExhibition():void 
		{
			_movieClip.escenaInicio.stopDrag();
			if(_movieClip.escenaInicio.hasEventListener(Event.ENTER_FRAME))
			{
				_movieClip.escenaInicio.removeEventListener(Event.ENTER_FRAME, detectLimit);
			}
		}
		
		
		
		
		/****************************************************************************************
		*
		* Seccion de la escena de audio
		*
		****************************************************************************************/
		
		
		
		
		/**
		* cuando el audio que suena en la escena de audio termine de reproducir y pasen 2 segundos
		* se ejecuta esta funcion que hara el cambio de escena
		*/
		public function audioEscenaAudioCompleto ():void 
		{
			trace("ingresar a escena de audio");
			_movieClip.estadoBotonesMenu[1] = true;
			Menu.mainMenuReload(_movieClip.estadoBotonesMenu);
			//se carga la animacion de los botones del menu activos 
			_animation.animacionEscalaBotonesMenu();
			//los listener para activar las carga de las escenas y detener la animacion de escala
			listenerBotonesMenu();
			//se habilita el reproductor mp3 y se silencia el canal de audio 0
			Audio.playAudio(null,0);
			_movieClip.cargarMediaPlayer(_movieClip.menuPrincipal.botonSonido);
		}

		/**
		* Activa las animaciones de la escena incluyendo la reproduccion del audio
		*/
		public function iniciarEscenaAudio ():void 
		{
			eliminarListenerBotonSonido();
			//Audio.playAudio(AudioClass.audioEscenas[escenaActual],0);
			//Audio.playComplete(0,audioEscenaAudioCompleto);
			
			Escena1 = _movieClip.escenario;
			Escena1.escena.play();
			Escena1.escena.addEventListener(Event.ENTER_FRAME,detectar);
		}
		
		
		
		/****************************************************************************************
		*
		* Seccion de la escena de lectura
		*
		****************************************************************************************/
		
		
		
		
		/* Almacena valores boolean para indica si ya se contestaron todas la preguntas del juego de lectura */
		public var arrayJuegoLecturaSelecciones:Array;
			
		
		/**
		* Activa las animaciones de la escena incluyendo la reproduccion del audio
		*/
		public function iniciarEscenaLectura ():void 
		{
			eliminarListenerBotonSonido();
			_movieClip.cargarJuego();
			_movieClip.configurarJuegoLectura();
			listenerJuegoLectura();
			Presentation.load(_movieClip.rutaJuego.botonBack,_movieClip.rutaJuego.botonNext,null,_movieClip.rutaJuego.texto);
			Timers.timer(2,cargarReproductorLectura);
			Audio.playAudio(null,0);
			CodeCraft.property(_movieClip.rutaJuego.compare,{alpha:0.2});
			arrayJuegoLecturaSelecciones = Arrays.fill(null,_movieClip.botonesJuegoLectura[0].length);
		}
		
		private function cargarReproductorLectura ():void 
		{
			_movieClip.cargarMediaPlayer(null,[[],[296,538]]);
		}
		
		private function listenerJuegoLectura():void 
		{
			Events.listener(_movieClip.botonesJuegoLectura[0],MouseEvent.CLICK, seleccionarJuegoLectura,true,true);
			Events.listener(_movieClip.botonesJuegoLectura[1],MouseEvent.CLICK, seleccionarJuegoLectura,true,true);
		}
		
		public function eliminarListenerJuegoLectura ():void 
		{
			Events.removeListener(_movieClip.botonesJuegoLectura[0],MouseEvent.CLICK, seleccionarJuegoLectura,true);
			Events.removeListener(_movieClip.botonesJuegoLectura[1],MouseEvent.CLICK, seleccionarJuegoLectura,true);
			Events.removeListener(_movieClip.rutaJuego.compare,MouseEvent.CLICK, compararJuegoLectura,true);
		}
		
		private function seleccionarJuegoLectura (event:MouseEvent):void 
		{
			//la primera busca el boton en la posicion del array para decir si es un boton de si o de no
			var posicion:int = Arrays.indexOf(_movieClip.botonesJuegoLectura,event.currentTarget,'multi');
			//busca el boton en la posicion del array del si o del no la pocicion esacta del elemento
			var posicionBoton:int = Arrays.indexOf(_movieClip.botonesJuegoLectura[posicion],event.currentTarget,'normal');
			//se verifica el fotograma donse se encuentra el elemento contrario
			if(posicion == 0)
			{
				posicion = 1;
			}
			else 
			{
				posicion = 0;
			}
			if(event.currentTarget.currentLabel == "normal")
			{
				event.currentTarget.gotoAndStop("seleccionado");
				_movieClip.botonesJuegoLectura[posicion][posicionBoton].gotoAndStop("normal");
			}
			else
			{
				event.currentTarget.gotoAndStop("normal");
				_movieClip.botonesJuegoLectura[posicion][posicionBoton].gotoAndStop("seleccionado");
			}
			//se indica si el boton de si eta seleccionado o no lo esta
			if(_movieClip.botonesJuegoLectura[0][posicionBoton].currentLabel == "seleccionado")
			{
				arrayJuegoLecturaSelecciones[posicionBoton] = true;
			}
			else
			{
				arrayJuegoLecturaSelecciones[posicionBoton] = false;
			}
			//se comprueba si ya se seleccionaron todas las opciones para poder cargar el boton de compare
			var sumaTotal:int = 0;
			for (var i:uint = 0; i < arrayJuegoLecturaSelecciones.length; i++)
			{
				if(arrayJuegoLecturaSelecciones[i] != null)
				{
					sumaTotal += 1;
				}
			}
			//se verifica si ya esta cargado todos los elementos y carga el listener para el boton de comparacion
			if(sumaTotal == arrayJuegoLecturaSelecciones.length)
			{
				CodeCraft.property(_movieClip.rutaJuego.compare,{alpha:1});
				Events.listener(_movieClip.rutaJuego.compare,MouseEvent.CLICK, compararJuegoLectura,true,true);
			}
			
		}
		
		/**
		* inicia la carga de la otra ventana emergente que muestra las respuestas
		*/
		private function compararJuegoLectura (event:MouseEvent):void 
		{
			//se hacen visibles las respuestas y se detienen segun el fotograma
			for(var i:uint = 0; i < _movieClip.respuestaJuegoLectura.length; i++)
			{
				if(_movieClip.respuestaJuegoLectura[i] == arrayJuegoLecturaSelecciones[i])
				{
					_movieClip.estadoRespuestasJuegoLectura[i].gotoAndStop("bien");					
				}
				else
				{
					_movieClip.estadoRespuestasJuegoLectura[i].gotoAndStop("mal");
				}
			}
			CodeCraft.visibility(_movieClip.estadoRespuestasJuegoLectura,true);
			juegoEscenaLecturaCompleto();
		}
		
		/**
		* Cuando termina de cargar todas las opciones del  juego
		*/
		public function juegoEscenaLecturaCompleto ():void 
		{
			if(_movieClip.estadoBotonesMenu[2] == false)
			{
				_movieClip.estadoBotonesMenu[2] = true;
				Menu.mainMenuReload(_movieClip.estadoBotonesMenu);
				//se carga la animacion de los botones del menu activos 
				_animation.animacionEscalaBotonesMenu();
				//los listener para activar las carga de las escenas y detener la animacion de escala
				listenerBotonesMenu();
				//se silencia el canal de audio 0
				Audio.playAudio(null,0);
			}
		}
		
		
		
		/****************************************************************************************
		*
		* Seccion de la escena de  observador
		*
		****************************************************************************************/
		
		
		
		/*  indica si se cargo o no las secciones de observar, para corregir el error de eliminar el elemento sin que este haya sido creado */
		private var _observarCargado:Boolean = false;
		private var _observar2Cargado:Boolean = false;
		/* Almacena las piezas para mover los elementos */
		private var _elementosObservarMover:Array;
		/* Almacen las piezas de las colisiones */
		private var _elementosObservarObjetivo:Array;
		/* Indicara que cantidad de objetos seran visibles por seccion de colision */
		private var _cantidadElementosObservar:Array;
		/* Indica la posicion actual del juego con el fin de poder cargar las secciones */
		private var _posicionJuegoObservar:int = 0;
		/* posicion inicias para ubicar las filas de los elementos con el adchild */
		private var _posicionElementosObservar:Array;
		/* almacena la posicion del limite para devolver los elementos a la posicion original */
		private var _retornoObservar:Array;
		/* almacena la variable de texto para que se ingreso en el teclado */
		private var _nombreObservar:String = "";
		private var _compareJuegoObservador:Array;
		
		
		/**
		* Activa las animaciones de la escena incluyendo la reproduccion del audio
		*/
		public function iniciarObservar1 ():void 
		{
			eliminarListenerBotonSonido();
			//se carga la Presentacion
			Presentation.load(_movieClip.rutaJuego.botonBack,_movieClip.rutaJuego.botonNext,null,_movieClip.rutaJuego.presentacion);
			Presentation.loadSound(AudioClass.audioEscenas[escenaActual]);
			listenerObservar1();
			_observarCargado = true;
			//Cargamos el nombre en la variable de nombre de la presentacion pero primero se verifica si es undefined
			if(SystemClass.memoriaUsuario.data.nombre != undefined)
			{
				_movieClip.rutaJuego.presentacion.nombre = SystemClass.memoriaUsuario.data.nombre;
			}
		}
		
		
		public function eliminarObservar():void
		{
			if(_observarCargado)
			{
				eliminarListenerObservar1();
				eliminarListenerObservar2();
				Presentation.remove();
				Magnet.remove();
				Collision.remove();
				_observarCargado = false;
			}			
		}
		
		public function iniciarObservar2 ():void
		{
			_observarCargado = true;
			_movieClip.cargarJuego();
			_posicionJuegoObservar = 0;
			_cantidadElementosObservar = new Array(4,2);
			_retornoObservar = new Array(650,1000);
			_posicionElementosObservar = new Array(
				[
					[800,240],[250,240]
				],
				[
					[814,397],[330,397]
				]
			);
			_compareJuegoObservador = Arrays.fill(false,_cantidadElementosObservar.length);
			CodeCraft.property(_movieClip.rutaJuego.compare,{alpha: 0.3});
			CodeCraft.visibility([_movieClip.rutaJuego.botonNext,_movieClip.rutaJuego.botonBack]);
			//se verifica si tiene movieClip de presentacion y se hace invisible hasta que cargue la presentacion
			if(_movieClip.rutaJuego.contains(_movieClip.rutaJuego.presentacion))
			{
				_movieClip.rutaJuego.presentacion.visible = false;	
				_movieClip.rutaJuego.presentacion.gotoAndStop(1);	
			}
			Timers.timer(2.2,cargarPresentacionObservar);
			Timers.timer(2.2,cargarJuegoObservar);
		}
	
		
		private function cargarPresentacionObservar ():void
		{
			_movieClip.rutaJuego.presentacion.visible = true;	
			Presentation.load(_movieClip.rutaJuego.botonBack,_movieClip.rutaJuego.botonNext,null,_movieClip.rutaJuego.presentacion,null,false,[observarSale,observarEntra]);
		}
		
		private function cargarJuegoObservar ():void 
		{
			if(_posicionJuegoObservar == 0)
			{
				_movieClip.rutaJuego.presentacion.texto.text = _nombreObservar;
			}
			_observarCargado = true;
			_elementosObservarMover = CodeCraft.store(ColisionObservar,_cantidadElementosObservar[_posicionJuegoObservar],"colisionDiccionarioA");
			_elementosObservarObjetivo = CodeCraft.store(ColisionObservar,_cantidadElementosObservar[_posicionJuegoObservar],"colisionDiccionarioB");
			CodeCraft.stopFrame(_elementosObservarObjetivo, "normal");
			CodeCraft.stopFrame(_elementosObservarMover, "normal");
			CodeCraft.property(_elementosObservarObjetivo,{alpha: 0});
			Texts.load(_elementosObservarMover,_message.escenaObservar[_posicionJuegoObservar]);
			Collision.load(_elementosObservarMover, _elementosObservarObjetivo, _posicionElementosObservar[_posicionJuegoObservar], ["y",33,1,4] ,null, _movieClip.rutaJuego.compare, _retornoObservar,_message.escenaObservar[_posicionJuegoObservar]);
			listenerObservar2();
		}
		
		private function observarSale ():void
		{
			eliminarObservar();
		}
		
		private function observarEntra ():void 
		{
			if(_posicionJuegoObservar != _movieClip.rutaJuego.presentacion.currentFrame - 1)
			{
				_posicionJuegoObservar = _movieClip.rutaJuego.presentacion.currentFrame - 1;
				cargarJuegoObservar();
			}
		}
		
		private function eliminarListenerObservar2 ():void
		{
			Events.removeListener(_movieClip.rutaJuego.compare, MouseEvent.CLICK, verificarCierreObservar,true);
			_elementosObservarMover = null;
			_elementosObservarObjetivo = null;
		}
		private function listenerObservar2 ():void
		{
			Events.listener(_movieClip.rutaJuego.compare, MouseEvent.CLICK, verificarCierreObservar,true,true);
			
		}
		
		/**
		* La funcion verifica cuando llega al ultimo fotograma de la presentacion para poder habilitar la carga de
		* los otros botones
		*/
		private function verificarUltimoFotogramaEscenaObservar(event:Event):void
		{
			if(_movieClip.rutaJuego.presentacion.currentFrame == _movieClip.rutaJuego.presentacion.totalFrames)
			{
				eliminarListenerObservar1();
				_movieClip.rutaJuego.botonNext.visible = true;
				Events.listener(_movieClip.rutaJuego.botonNext,MouseEvent.CLICK, cambiarEscenaObservar1);
			}
		}
		
		private function listenerObservar1 ():void 
		{
			Events.listener(_movieClip.escenario,Event.ENTER_FRAME,verificarUltimoFotogramaEscenaObservar);
		}
		
		private function eliminarListenerObservar1 ():void 
		{
			Events.removeListener(_movieClip.escenario,Event.ENTER_FRAME,verificarUltimoFotogramaEscenaObservar);
			Events.removeListener(_movieClip.rutaJuego.botonNext,MouseEvent.CLICK, cambiarEscenaObservar1);
		}
		
		private function cambiarEscenaObservar1 (event:MouseEvent):void
		{
			//se almaena la variable del nombre
			trace(_movieClip.rutaJuego.presentacion.texto.text);
			SystemClass.memoriaUsuario.data.nombre = _movieClip.rutaJuego.presentacion.texto.text;
			SystemClass.memoriaUsuario.flush();
			_nombreObservar = _movieClip.rutaJuego.presentacion.texto.text;
			Events.removeListener(_movieClip.rutaJuego.botonNext,MouseEvent.CLICK, cambiarEscenaObservar1);
			var posicionEscena:int = Arrays.indexOf(_escene.escenasMultimedia,"observar2");
			_escene.cambioEscena(_escene.escenasMultimedia[posicionEscena]);
		}
		
		
		private function verificarCierreObservar(event:MouseEvent):void 
		{
			//se indica que se cargo el compare
			_compareJuegoObservador[_posicionJuegoObservar] = true;	
			if(Arrays.verifyFill(_compareJuegoObservador,true))
			{
				_movieClip.rutaJuego.botonNext.visible = true;
				Events.listener(_movieClip.rutaJuego.botonNext,MouseEvent.CLICK, cambiarEscenaObservador);
			}
		}

		private function cambiarEscenaObservador (event:MouseEvent):void 
		{
			Events.removeListener(_movieClip.rutaJuego.botonNext,MouseEvent.CLICK, cambiarEscenaObservador);
			_animation.juegoOut();
			eliminarObservar();
			//se elimina los listener y habilita el nuevo boton
			_movieClip.estadoBotonesMenu[3] = true;
			Menu.mainMenuReload(_movieClip.estadoBotonesMenu);
			//se carga la animacion de los botones del menu activos 
			_animation.animacionEscalaBotonesMenu();
			//los listener para activar las carga de las escenas y detener la animacion de escala
			listenerBotonesMenu();
		}
		
		/****************************************************************************************
		*
		* Seccion de la escena de computador  
		*
		****************************************************************************************/
		
		
		
		
		/* almacena las cajas que tienen el signo de pregunta, donde colisionan los elementos */
		private var _elementosComputadorObjetivo:Array;
		/* almacena las fichas que se van a mover */
		private var _elementosComputadorMover:Array;
		/* almacena la posicion de las fichas qeu se meuven como las que colisionan, es un multi array que solo guarda la posicon iniciar de cada nno */
		private var _posicionElementosComputador:Array;
		/* cordenadas en el eje x que indican que zona debe estar tocando la ficha que se mueve para volver a su posicion inicial */
		private var _retornoComputador:Array;
		/* indica en que parte el juego se encuentra actualmetne para cargar el juego de colision que le corresponde */
		private var _posicionJuegoComputador:int = 0;
		/* indica si a presionado el boton para comparar la respuesta, se debe presionar para poder llenar el array u asi pasar a la otra escena */
		private var _compareCargadosComputador:Array;
		/* indica si se cargo o no el juego por completo*/
		private var _juegoComputadorCompleto:Boolean;
		/* indica que cantidad de fichas se muestran por pantalla */
		private var _cantidadOpcionesComputador:Array;
		/* almacena los elementos que van a posicionar cuando le de clic en los objetivos secundarios */
		private var _elementosComputadorPosicion:Array;
		/* indica si ya se cargo o no la escena del computador, se usa para corregir el error de eliminar el listener*/
		private var _computadorCargado:Boolean = false;
		/* Cambia la posicion de los juegos internos del compuntador 3 */
		private var _posicionJuegoComputador3:int = 0;
		/* Almacena las instancias de los input text */
		private var _cajaTextos:Array;
		
		
		public function valoresVariablesComputador ():void 
		{
			_movieClip.cargarJuego();
			_computadorCargado = true;
			_posicionJuegoComputador = new int(escenaActual.substr(escenaActual.length - 1)) - 1;
			_posicionJuegoComputador3 = 0;
			_juegoComputadorCompleto = false;
			_cantidadOpcionesComputador = new Array(4,[3,4,4,4,3],[5,5]);
			_posicionElementosComputador = new Array(
				[
					[272,243],[786,243],[549,243]
				],
				[
					[188,228],[188,285],[188,345],[188,410],[188,472]
				],
				[
					[
					[822,230],[281,230]
					],
					[
						[830,176],new Array(
										[340,200],
										[502,200],
										[430,260],
										[256,323],
										[502,323]
							   		)
					]
				],
				[]
			);
			//se agrega la cantidad de compares que debe tener mirando la posicion del juego y comparando con el tamaño del array de posiciones
			var cantidadCompareJuego:Array = new Array(1,1,2,1);
			_compareCargadosComputador = Arrays.fill(false,cantidadCompareJuego[_posicionJuegoComputador]);
			_retornoComputador = new Array(600, 1000);
			_movieClip.rutaJuego.compare.alpha = 0;
			CodeCraft.visibility([_movieClip.rutaJuego.botonNext,_movieClip.rutaJuego.botonBack]);
			//se verifica si tiene movieClip de presentacion y se hace invisible hasta que cargue la presentacion
			if(_movieClip.rutaJuego.contains(_movieClip.rutaJuego.presentacion))
			{
				_movieClip.rutaJuego.presentacion.visible = false;	
				_movieClip.rutaJuego.presentacion.gotoAndStop(1);	
			}
		}
		
		/**
		* reinicia las varialbes y llama al juego, se ejecuta un timer para esperar que la pantalla del juego temine de cargar
		*/
		public function iniciarComputador1():void
		{
			valoresVariablesComputador();
			Timers.timer(2.2,cargarArrastrarComputador);
			Timers.timer(2.2,cargarComputadorPresentacion);
		}
		
		public function iniciarComputador2 ():void
		{
			valoresVariablesComputador();
			Timers.timer(2.2,cargarImanComputador);
			Timers.timer(2.2,cargarComputadorPresentacion);
		}
		
		public function iniciarComputador3():void
		{
			valoresVariablesComputador();
			Timers.timer(2.2,cargarArrastrarComputador);
			Timers.timer(2.2,cargarComputadorPresentacion);
		}
		
		/**
		 * 
		 */
		public function iniciarComputador4():void
		{
			valoresVariablesComputador();
			Timers.timer(2.2,cargarCompletarComputador);
		}
		
		public function iniciarComputador5():void
		{
			valoresVariablesComputador();
			Timers.timer(2.2,cargarImanComputador);
			Timers.timer(2.2,cargarComputadorPresentacion);
		}
		
		/**
		*
		*/
		public function eliminarComputador():void
		{
			Timers.stopAllTimer();
			eliminarListenerComputador();
			Presentation.remove();
		}
		
		/**
		* se ejecuta cuando se va a pasar de fotograma
		*/
		private function computadorSale():void 
		{
			eliminarListenerComputador();
		}
		
		/**
		* se ejecuta despues de que se asa al siguiente fotograma
		*/
		private function computadorEntra():void 
		{
			if(_posicionJuegoComputador == 2 && _posicionJuegoComputador3 != _movieClip.rutaJuego.presentacion.currentFrame - 1)
			{
				_posicionJuegoComputador3 = _movieClip.rutaJuego.presentacion.currentFrame - 1;
				cargarArrastrarComputador();
			}
		}
		
		/**
		* despues de pasar el tiempo que se le da en la funcion carga la presentacion, esto con el fin de que se carge e inicie los
		* eventos del teclado y se pasen las actividades rapidamente
		*/
		private function cargarComputadorPresentacion ():void
		{
			_movieClip.rutaJuego.presentacion.visible = true;
			Presentation.load(_movieClip.rutaJuego.botonBack,_movieClip.rutaJuego.botonNext,null,_movieClip.rutaJuego.presentacion,null,false,[computadorSale,computadorEntra]);
		}
		
		private function cargarImanComputador():void
		{
			//se ubica para indicar que se cargo una opcion del computador y este pueda tener activo la opcion de removeListener
			_computadorCargado = true;
			_elementosComputadorMover = new Array(
				CodeCraft.store(ColisionComputador2,3,"colisionComputadorA"),
				CodeCraft.store(ColisionComputador2,4,"colisionComputadorB"),
				CodeCraft.store(ColisionComputador2,4,"colisionComputadorC"),
				CodeCraft.store(ColisionComputador2,4,"colisionComputadorD"),
				CodeCraft.store(ColisionComputador2,3,"colisionComputadorE")
			);
			Magnet.load(_elementosComputadorMover,_posicionElementosComputador[_posicionJuegoComputador],_message.escenaComputador[_posicionJuegoComputador],_movieClip.rutaJuego.compare);
			listenerComputador();
		}
		
		private function cargarArrastrarComputador ():void 
		{	
			//se ubica para indicar que se cargo una opcion del computador y este pueda tener activo la opcion de removeListener
			_computadorCargado = true;
			/* Almacena la posicion del elemento par ser cargado a la funcion, como existe doble carga en la escena computador3 se crea esta variable */
			var posicion:Array;
			var distanciaEntreElementos:int = 10;
			var textosVerificacion:Array = null;
			if(escenaActual == "computador1")
			{
				_elementosComputadorObjetivo = CodeCraft.store(ColisionComputador1,_cantidadOpcionesComputador[_posicionJuegoComputador],"colisionComputadorA");
				_elementosComputadorMover = CodeCraft.store(ColisionComputador1,_cantidadOpcionesComputador[_posicionJuegoComputador],"colisionComputadorB");
				_elementosComputadorPosicion = CodeCraft.store(ColisionComputador1,_cantidadOpcionesComputador[_posicionJuegoComputador],"colisionComputadorC");
				Texts.load(_elementosComputadorMover,_message.escenaComputador[_posicionJuegoComputador][0]);
				Texts.load(_elementosComputadorObjetivo,_message.escenaComputador[_posicionJuegoComputador][1]);
				_retornoComputador = new Array(0, 400);
				//se indica la posicion solo valida para la escena 1
				posicion =  _posicionElementosComputador[_posicionJuegoComputador];
			}
			else
			{
				_elementosComputadorObjetivo = CodeCraft.store(ColisionComputador2,_cantidadOpcionesComputador[_posicionJuegoComputador][_posicionJuegoComputador3],"colisionComputadorA");
				_elementosComputadorMover = CodeCraft.store(ColisionComputador2,_cantidadOpcionesComputador[_posicionJuegoComputador][_posicionJuegoComputador3],"colisionComputadorB");
				_retornoComputador = new Array(650, 1000);
				_elementosComputadorPosicion = null;
				distanciaEntreElementos = 18;
				CodeCraft.property(_elementosComputadorObjetivo,{alpha:0});
				Texts.load(_elementosComputadorMover,_message.escenaComputador[_posicionJuegoComputador][_posicionJuegoComputador3]);
				textosVerificacion = _message.escenaComputador[_posicionJuegoComputador][_posicionJuegoComputador3];
				//se indica la posicion a cargar solo valida para la escena dos
				posicion = _posicionElementosComputador[_posicionJuegoComputador][_posicionJuegoComputador3];
			}
			CodeCraft.stopFrame(_elementosComputadorMover, "normal");
			CodeCraft.stopFrame(_elementosComputadorObjetivo, "normal");
			CodeCraft.stopFrame(_elementosComputadorPosicion, "normal");
			Collision.load(_elementosComputadorMover, _elementosComputadorObjetivo,posicion, ["y",distanciaEntreElementos,1,4] ,_elementosComputadorPosicion, _movieClip.rutaJuego.compare, _retornoComputador, textosVerificacion);
			listenerComputador();
		}
		
		/**
		*
		*/
		private function listenerComputador ():void
		{
			Events.listener(_movieClip.rutaJuego.compare, MouseEvent.CLICK, verificarCierreComputador,true,true);
		}
		
		/**
		* el listener de presentacion.remove se carga en eliminarEscenarioDiccionario para que no se pueda ejecutar las acciones del teclado
		*/
		private function eliminarListenerComputador():void
		{
			if(_computadorCargado)
			{
				Events.removeListener(_movieClip.rutaJuego.compare, MouseEvent.CLICK, verificarCierreComputador,true);
				Events.removeListener(_movieClip.rutaJuego.botonNext,MouseEvent.CLICK, cambiarEscenaComputador);
				Collision.remove();
				Magnet.remove();
				_computadorCargado = false;
				_elementosComputadorObjetivo = null;
				_elementosComputadorMover = null;
			}
		}
		
		
		/**
		* Almacena la opcion de que se presiono el boton compare en la seccion que se encuentra el juego, tambien verifica si ya
		* se completo el juego para cambiar de escena
		*/
		private function verificarCierreComputador (event:MouseEvent):void 
		{
			//se indica que se cargo el compare
			if(escenaActual == "computador3")
			{
				_compareCargadosComputador[_posicionJuegoComputador3] = true;	
			}
			else
			{
				_compareCargadosComputador[0] = true;	
			}
			if(Arrays.verifyFill(_compareCargadosComputador,true))
			{
				_movieClip.rutaJuego.botonNext.visible = true;
				Events.listener(_movieClip.rutaJuego.botonNext,MouseEvent.CLICK, cambiarEscenaComputador);
			}
		}
		
		private function  cambiarEscenaComputador (event:MouseEvent):void 
		{
			Events.removeListener(_movieClip.rutaJuego.botonNext,MouseEvent.CLICK, cambiarEscenaComputador);
			//se detecta si es el boton de otra escena diferente y se carga esta
			var posicionEscena:int = (Arrays.indexOf(_escene.escenasMultimedia, escenaActual) + 1);
			//el if cancela la carga de las otras actividades y adelanta la escena es temporal mientras se solucionan problemas de la actividad
			if(_escene.escenasMultimedia[posicionEscena] == "computador5")
			{
				_juegoComputadorCompleto = true;
				_animation.juegoOut();
				//se elimina los listener y habilita el nuevo boton
				_movieClip.estadoBotonesMenu[4] = true;
				Menu.mainMenuReload(_movieClip.estadoBotonesMenu);
				//se carga la animacion de los botones del menu activos 
				_animation.animacionEscalaBotonesMenu();
				//los listener para activar las carga de las escenas y detener la animacion de escala
				listenerBotonesMenu();
				eliminarComputador();
				
			}
			else
			{
				_escene.cambioEscena(_escene.escenasMultimedia[posicionEscena]);
			}
		}
		
		
		private function cargarCompletarComputador():void 
		{
			_cajaTextos = new Array(
				_movieClip.rutaJuego.presentacion.texto1,
				_movieClip.rutaJuego.presentacion.texto2,
				_movieClip.rutaJuego.presentacion.texto3,
				_movieClip.rutaJuego.presentacion.texto4,
				_movieClip.rutaJuego.presentacion.texto5,
				_movieClip.rutaJuego.presentacion.texto6,
				_movieClip.rutaJuego.presentacion.texto7
			);
			_movieClip.rutaJuego.presentacion.visible = true;
			CodeCraft.property(_movieClip.rutaJuego.compare,{alpha: 0.3});
			CheckInput.load(_cajaTextos,_message.escenaComputador[_posicionJuegoComputador][0],5,_movieClip.rutaJuego.compare);
		}
		
		
		/****************************************************************************************
		*
		* Seccion de la escena de pronunciacion
		*
		****************************************************************************************/
		
		
		
		
		/* Almacenara la cantidad de audios que se reproducen, se tiene que dar play a todos para poder avanzar a la siguiente escena */
		private var _cantidadAudiosJuegoPronunciacion:Array;
		/* botones de play para los audios */
		private var _botonesPlayPronunciacion:Array = null;
		/* Indicara que seccion del audio cargara para los botones identificando el fotograma en el que se encuentra */
		private var _posicionJuegoPronunciacion:int = 0;
		/* Verifica si ya se termino de cargar todo el juego para habilitar la nueva escena */
		private var _juegoPronunciacionCompleto:Boolean;
		
		public function iniciarPronunciacion ():void
		{
			_movieClip.cargarJuego();
			Timers.timer(2.5,_movieClip.cargarControlGrabacion);
			_juegoPronunciacionCompleto = false;
			_botonesPlayPronunciacion = new Array();
			_posicionJuegoPronunciacion = 0;
			Presentation.load(_movieClip.rutaJuego.botonBack,_movieClip.rutaJuego.botonNext,null,_movieClip.rutaJuego.presentacion,[_movieClip.rutaJuego.presentacion.botonesPlay],false,[pronunciacionSale,pronunciacionEntra]);
			_cantidadAudiosJuegoPronunciacion = Arrays.fill(false,5);
			almacenarBotonesPlayPronunciacion();
			listenerPronunciacion();
		}
		

		public function eliminarPronunciacion():void 
		{
			eliminarListenerPronunciacion();
			_movieClip.eliminarControlGrabacion();
			Presentation.remove();
		}
		
		private function pronunciacionSale ():void 
		{
			eliminarListenerPronunciacion();
			Audio.playAudio(null,0);
		}
		
		private function pronunciacionEntra ():void 
		{
			_posicionJuegoPronunciacion = _movieClip.rutaJuego.presentacion.currentFrame - 1;
			almacenarBotonesPlayPronunciacion();
			listenerPronunciacion();
		}
		
		private function listenerPronunciacion ():void 
		{
			Events.listener(_botonesPlayPronunciacion,MouseEvent.CLICK, audioPronunciacion,true,true);
		}
		
		private function eliminarListenerPronunciacion ():void 
		{
			if(_botonesPlayPronunciacion != null)
			{
				Events.removeListener(_botonesPlayPronunciacion,MouseEvent.CLICK, audioPronunciacion,true);	
			}
		}
		
		/**
		* Cada vez que se cambie de fotograma almacenara los botones nuevamente
		*/
		private function almacenarBotonesPlayPronunciacion():void 
		{
			_botonesPlayPronunciacion = new Array(
				_movieClip.rutaJuego.presentacion.botonesPlay.play1,
				_movieClip.rutaJuego.presentacion.botonesPlay.play2,
				_movieClip.rutaJuego.presentacion.botonesPlay.play3,
				_movieClip.rutaJuego.presentacion.botonesPlay.play4,
				_movieClip.rutaJuego.presentacion.botonesPlay.play5
			);
			CodeCraft.stopFrame(_botonesPlayPronunciacion,"play");
		}
		
		private function audioPronunciacion (event:MouseEvent):void 
		{
			var posicion:int = Arrays.indexOf(_botonesPlayPronunciacion,event.currentTarget);
			if(event.currentTarget.currentLabel == "play")
			{
				Audio.playAudio(AudioClass.audioEscenas[escenaActual][_posicionJuegoPronunciacion][posicion],0);
				Audio.playComplete(0,audioPronunciacionCompleto);
				CodeCraft.stopFrame(_botonesPlayPronunciacion, "play");
				event.currentTarget.gotoAndStop("pause");
				//se verifica si la posicion es la ultima entonces se almacena las cargas de los botones
				if(_posicionJuegoPronunciacion == _movieClip.rutaJuego.presentacion.totalFrames - 1)
				{
					_cantidadAudiosJuegoPronunciacion[posicion] = true;
				}
			}
			else 
			{
				Audio.playAudio(null,0);
				CodeCraft.stopFrame(_botonesPlayPronunciacion, "play");
			}
			//verifica si ya completo la carga del audio por completo para habilitar la carga a la siguiente escena
			//se ejecuta apenas da play por la razon de que si no hay audios o se demora para cargar por problemas
			//de conexion el boton nunca cambiaria a la siguiente escena
			if(Arrays.verifyFill(_cantidadAudiosJuegoPronunciacion,true) && _juegoPronunciacionCompleto == false)
			{
				_juegoPronunciacionCompleto = true;
				//se elimina los listener y habilita el nuevo boton
				_movieClip.estadoBotonesMenu[5] = true;
				Menu.mainMenuReload(_movieClip.estadoBotonesMenu);
				//se carga la animacion de los botones del menu activos 
				_animation.animacionEscalaBotonesMenu();
				//los listener para activar las carga de las escenas y detener la animacion de escala
				listenerBotonesMenu();
			}
		}
		
		private function audioPronunciacionCompleto ():void 
		{
			Audio.playAudio(null,0);
			CodeCraft.stopFrame(_botonesPlayPronunciacion, "play");
		}
		
		
		
		
		/****************************************************************************************
		*
		* Seccion de la escena de diccionario
		*
		****************************************************************************************/
		
		
		
		
		/* almacena el boton de play que se esta reproducciendo en el momento el audio */
		private var _botonPlayDiccionario:* = null;
		/* almacena las cajas que tienen el signo de pregunta, donde colisionan los elementos */
		private var _elementosDiccionarioObjetivo:Array;
		/* almacena las fichas que se van a mover */
		private var _elementosDiccionarioMover:Array;
		/* almacena la posicion de las fichas qeu se meuven como las que colisionan, es un multi array que solo guarda la posicon iniciar de cada nno */
		private var _posicionElementosDiccionario:Array;
		/* cordenadas en el eje x que indican que zona debe estar tocando la ficha que se mueve para volver a su posicion inicial */
		private var _retornoDiccionario:Array;
		/* almacena todos los botones de play que contienen los elmentos de colision*/
		private var _botonesPlayDiccionario:Array;
		/* indica en que parte el juego se encuentra actualmetne para cargar el juego de colision que le corresponde */
		private var _posicionJuegoDiccionario:int = 0;
		/* indica que cantidad de fichas se muestran por pantalla */
		private var _cantidadOpcionesDiccionario:Array;
		/* almacena los fotogramas en los que debe cargar las cartas que se mueven */
		private var _fotogramaInicialDiccionario:Array;
		/* indica si a presionado el boton para comparar la respuesta, se debe presionar para poder llenar el array u asi pasar a la otra escena */
		private var _compareCargadosDiccionario:Array;
		/* indica si se cargo o no el juego por completo*/
		private var _juegoDiccionarioCompleto:Boolean;
		
		
		/**
		* reinicia las varialbes y llama al juego, se ejecuta un timer para esperar que la pantalla del juego temine de cargar
		*/
		public function iniciarDiccionario():void
		{
			_movieClip.cargarJuego();
			_juegoDiccionarioCompleto = false;
			_cantidadOpcionesDiccionario = new Array(6,4,5,5);
			_fotogramaInicialDiccionario = new Array(1,7,11,16);
			_retornoDiccionario = new Array(600, 1000);
			_compareCargadosDiccionario = Arrays.fill(false,_cantidadOpcionesDiccionario.length);
			_movieClip.rutaJuego.compare.alpha = 0;
			CodeCraft.visibility([_movieClip.rutaJuego.botonNext,_movieClip.rutaJuego.botonBack]);
			Timers.timer(2.2,cargarJuegoDiccionario);
			Timers.timer(2.2,cargarDiccionarioPresentacion);
			
		}
		
		/**
		*
		*/
		public function eliminarDiccionario():void
		{
			Timers.stopAllTimer();
			Presentation.remove();
			eliminarListenerDiccionario();
		}
		
		/**
		* se ejecuta cuando se va a pasar de fotograma
		*/
		private function diccionarioSale():void 
		{
			eliminarListenerDiccionario();
		}
		
		/**
		* se ejecuta despues de que se asa al siguiente fotograma
		*/
		private function diccionarioEntra():void 
		{
			if(_posicionJuegoDiccionario != _movieClip.rutaJuego.presentacion.currentFrame - 1)
			{
				_posicionJuegoDiccionario = _movieClip.rutaJuego.presentacion.currentFrame - 1;
				cargarJuegoDiccionario();
			}
		}
		
		/**
		* despues de pasar el tiempo que se le da en la funcion carga la presentacion, esto con el fin de que se carge e inicie los
		* eventos del teclado y se pasen las actividades rapidamente
		*/
		private function cargarDiccionarioPresentacion ():void
		{
			Presentation.load(_movieClip.rutaJuego.botonBack,_movieClip.rutaJuego.botonNext,null,_movieClip.rutaJuego.presentacion,null,false,[diccionarioSale,diccionarioEntra]);
		}
		
		/**
		* carga el juego por escenas dependiendo de que posicion del fotograma de la presentacion se encuentre
		*/
		private function cargarJuegoDiccionario ():void 
		{
			_elementosDiccionarioObjetivo = CodeCraft.store(ColisionDiccionario1,_cantidadOpcionesDiccionario[_posicionJuegoDiccionario],"colisionDiccionarioA");
			_elementosDiccionarioMover = CodeCraft.store(ColisionDiccionario2,_cantidadOpcionesDiccionario[_posicionJuegoDiccionario],"colisionDiccionarioB");
			_posicionElementosDiccionario = new Array(
				[678,175],
				[255,175]
			);
			CodeCraft.stopFrame(_elementosDiccionarioMover, 0,_fotogramaInicialDiccionario[_posicionJuegoDiccionario]);
			Texts.load(_elementosDiccionarioObjetivo,_message.escenaDiccionario[_posicionJuegoDiccionario]);
			
			//se carga los botones de play
			_botonesPlayDiccionario = new Array();
			for(var i:int = 0; i < _elementosDiccionarioObjetivo.length; i++)
			{
				_botonesPlayDiccionario.push(_elementosDiccionarioObjetivo[i].botonPlay);
			}
			CodeCraft.stopFrame(_botonesPlayDiccionario,"play");
			Collision.load(_elementosDiccionarioMover, _elementosDiccionarioObjetivo, _posicionElementosDiccionario, ["x",10,3,4] ,null, _movieClip.rutaJuego.compare, _retornoDiccionario);
			listenerDiccionario();
		}
		
		/**
		*
		*/
		private function listenerDiccionario ():void
		{
			Events.listener(_botonesPlayDiccionario, MouseEvent.CLICK, audioDiccionario,true,true);
			Events.listener(_movieClip.rutaJuego.compare, MouseEvent.CLICK, verificarCierreDiccionario,true,true);
			
		}
		
		/**
		* el listener de presentacion.remove se carga en eliminarEscenarioDiccionario para que no se pueda ejecutar las acciones del teclado
		*/
		private function eliminarListenerDiccionario():void
		{
			if(_botonesPlayDiccionario != null)
			{
				Events.removeListener(_botonesPlayDiccionario, MouseEvent.CLICK, audioDiccionario,true);
				Events.removeListener(_movieClip.rutaJuego.compare, MouseEvent.CLICK, verificarCierreDiccionario,true);
				Collision.remove();
			}
		}
		
		/**
		* carga un audio al boton de play que se presiono
		*/
		private function audioDiccionario (event:MouseEvent):void 
		{
			CodeCraft.stopFrame(_botonesPlayDiccionario,"play");
			var posicion:int = Arrays.indexOf(_botonesPlayDiccionario, event.currentTarget);
			if(event.currentTarget.currentLabel == "play")
			{
				event.currentTarget.gotoAndStop("pause");
				_botonPlayDiccionario = event.currentTarget;
				Audio.playAudio(AudioClass.audioEscenas[escenaActual][_posicionJuegoDiccionario][posicion],0);
				Audio.playComplete(0,audioDiccionarioCompleto);
			}
		}
		
		/**
		* detiene el audio y restaura los botones
		*/
		private function audioDiccionarioCompleto ():void 
		{
			CodeCraft.stopFrame(_botonesPlayDiccionario,"play");
			Audio.playAudio(null,0);
		}
		
		/**
		* Almacena la opcion de que se presiono el boton compare en la seccion que se encuentra el juego, tambien verifica si ya
		* se completo el juego para cambiar de escena
		*/
		private function verificarCierreDiccionario (event:MouseEvent):void 
		{
			//se indica que se cargo el compare
			_compareCargadosDiccionario[_posicionJuegoDiccionario] = true;
			//se verifica si completaron todos los compare
			if(Arrays.verifyFill(_compareCargadosDiccionario,true) && _juegoDiccionarioCompleto == false)
			{
				_juegoDiccionarioCompleto = true;
				//se elimina los listener y habilita el nuevo boton
				_movieClip.estadoBotonesMenu[6] = true;
				Menu.mainMenuReload(_movieClip.estadoBotonesMenu);
				//se carga la animacion de los botones del menu activos 
				_animation.animacionEscalaBotonesMenu();
				//los listener para activar las carga de las escenas y detener la animacion de escala
				listenerBotonesMenu();
			}	
		}
		
		
		
		
		/****************************************************************************************
		*
		* Seccion de la escena de video
		*
		****************************************************************************************/
		
		
		
		
		public function iniciarEscenaVideo ():void 
		{
			eliminarListenerBotonSonido();
			_movieClip.cargarJuego();
			Audio.playAudio(null,0);
			listenerBotonesMenu();
		}

	}
}