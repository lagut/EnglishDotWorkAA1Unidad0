/**
 * Clase encargada de la carga de todos los elementos de la libreria menos los textos
 * @author: Luis Felipe Zapata
 * @fecha: 26 de Octubre del 2013
 */
package clases 
{
	
	import flash.display.MovieClip;
	
	import codeCraft.core.CodeCraft;
	import codeCraft.display.Menu;
	import codeCraft.text.Texts;
	import codeCraft.utils.Arrays;
	import codeCraft.media.MediaPlayer;
	import codeCraft.media.Record;
	import codeCraft.media.Audio;
	import codeCraft.debug.Debug;
	import flash.events.*;
	import flash.ui.*;
	import flash.text.*;
	
	//import Escuela_fla.*;
	
	public class MovieClipClass extends MovieClip
	{
		
		//refencia de las clases utilizadas
		private var _animation:AnimationClass;
		private var _navigation:NavigationClass;
		private var _message:MessageClass;
		private var _escene:EsceneClass;

		/* Clips de Pelicula que hacen referencia a los escenarios que esten actualmente cargados*/
		public var escenario:MovieClip = null;
		/* Ventana de carga de los juegos de la multimedia, dentro de la ventana hay un movieclip que tiene los juegos y son cargados por etiquetas */
		public var juegos:MovieClip = null;
		/* Almacenar una ruta peque�a de los juegos */
		public var rutaJuego:MovieClip;
		/* Indicara si los menus ya se cargaron con true, y false para indicar que no se han cargado */
		private var  _menusCargadosEscenario:Boolean = false;
		//elementos correspondientes al menu de navegacion
		public var menuGrabacion:MovieClip = new MenuGrabacion();
		public var menuOpciones:MovieClip = new MenuOpciones();
		public var menuPrincipal:MovieClip = new MenuPrincipal();
		public var menuSonido:MovieClip = new MenuSonido();
		public var popUpBotonesMenu:MovieClip = null;
		public var ventanaInstrucciones:MovieClip;
		
		//---variables de la actividad Completar---
		public var numeropalabra:int = 1;
		public var contadorbuenos = 0;
		public var TextosCorrectos:Array=new Array();
		public var ArrayCajas:Array=new Array();
		public var texto:TextField=new TextField();
		public var ref:int;
		public var estilo:StyleSheet = new StyleSheet();
		public var temporal:Array=new Array();
		public var busqueda:Array = new Array();
		public var instanciaBoton:MovieClip;
		//public var myTextFormat:TextFormat = new TextFormat();
		//-----------------------------------------------------------------
		private var _posicionMenu:Array = new Array(500,45);
		public var botonesMenu:Array = new Array(
			menuPrincipal.botonSonido,
			menuPrincipal.botonLectura,
			menuPrincipal.botonObservar,
			menuPrincipal.botonComputador,
			menuPrincipal.botonGrabacion,
			menuPrincipal.botonDiccionario,
			menuPrincipal.botonVideo
		);
		/* Almacena boolean que indicaran el estado de los botones del menu, si estan o no activos, esta variable es cargada desde EsceneClass */
		public var estadoBotonesMenu:Array;
		
		
		
		public var botonesPlayGrabacion:Array = new Array();
		
		public function setVar (navigationClass, animationClass, messageClass, esceneClass):void 
		{
			_navigation = navigationClass;
			_animation = animationClass;
			_message = messageClass;
			_escene = esceneClass;
		}
		
		/****************************************************************************************
		*
		* Carga generar del escenario
		*
		****************************************************************************************/
		
		/**
		* Se encarga de cargar el escenario de la escuela verificando que este ya halla sido cargado
		*/
		public function cargarEscenario ():void 
		{
			//se verifica que exista el elmento
			if(escenario == null)
			{
				escenario = new Escuela1();
				escenario.gotoAndStop(1);
				//escenario.escena.gotoAndStop(1);
			}
			//se verifica si ya se cargo
			if(!(CodeCraft.getMainObject().contains(escenario)))
			{
				CodeCraft.addChild(escenario);
			}
		}
		
		/**
		* Carga la ventana del juego
		*/
		public function cargarJuego ():void 
		{
			//se verifica que exista el elmento
			if(juegos == null)
			{
				juegos = new VentanaJuegos();
			}
			//se verifica si ya se cargo
			if(!(CodeCraft.getMainObject().contains(juegos)))
			{
				CodeCraft.addChild(juegos);
			}
			//se ubica el frame del juego actual
			juegos.ventana.contenido.gotoAndStop(_navigation.escenaActual);
			//inicia la animacion y despues de que termina la animacion de carga se llama el listener
			_animation.juegoIn();
			//Como se desabilito la opcion CodeCraft.mainMenuLoaded = false; se debe cargar manualmente
			//la ventana del menu, entonces se elimina y se vuelve a cargar
			recargarMenu();
			//se almacena la ruta para los juegos
			rutaJuego = juegos.ventana.contenido.juego;
		}
		
		/**
		* elimina la ventana del juego y limpia la variables de pues de que se ejecute la animacion
		*/
		public function eliminarJuegoCompleto ():void 
		{
			if(juegos != null)
			{
				CodeCraft.removeChild(juegos);
				juegos = null;
			}
		}
		
		/**
		* elimina el menu principal y vuelve a cargarlo para que pueda quedar encima de los demas elementos
		*/
		public function recargarMenu ():void 
		{
			CodeCraft.removeChild(menuPrincipal);
			CodeCraft.addChild(menuPrincipal,null,_posicionMenu);
			_navigation.listenerOcultarPopUp();
			_navigation.listenerBotonesMenu();
		}
		
		/****************************************************************************************
		*
		* Instrucciones de cada escenario
		*
		****************************************************************************************/
		
		public function cargarInstrucciones ():void 
		{
			ventanaInstrucciones = new VentanaInstrucciones();
			//se detiene en la etiqueta indicara segun la posicion del menu
			ventanaInstrucciones.ventana.contenido.gotoAndStop(_navigation.escenaActual);
			CodeCraft.addChild(ventanaInstrucciones);
			_animation.instruccionesIn();
			_navigation.listenerInstrucciones();
			//se carga el audio de las instrucciones activas en el momento
			Audio.playAudio(AudioClass.audiosInstrucciones[_navigation.escenaActual],0);
			//cuando termine de el audio de las instrucciones inicia la animacion para el parlante
			//indicando que debe dar clic para volver a rerpdicir el audio
			Audio.playComplete(0,_navigation.instruccionesAudioCompleto);
			//se verifica si se enceuntra en la ubicacion del inicio para no cargar el menu
			if(_navigation.escenaActual != "inicio")
			{
				//recargamos el menu
				recargarMenu();
			}
		}

		public function eliminarInstrucciones ():void 
		{
			CodeCraft.removeChild(ventanaInstrucciones);
			ventanaInstrucciones = null;
			//se llama a la funcion que se encarga de decir que la escena inicie para ello se busca la posicion
			//de la escena actual y se carga la funcion que este en el array 
			var posicion:int = Arrays.indexOf(_escene.escenasMultimedia,_navigation.escenaActual);
			var funcionRetornar:Function = _navigation.funcionesIniciarEscena[posicion];
			//se verifica si se esta agregando una escena para poder realizar esta accion
			if(_escene.accionEscena == "agregar")
			{
				funcionRetornar();
			}			
		}
		
		/****************************************************************************************
		*
		* Manejo del menu, carga de los menus y los menus de controles de grabacion y reproduccion
		*
		****************************************************************************************/
		
		
		public function cargarMenu ():void
		{
			//se verifica si ya se cargaron los menus una vez para no volver a cargarlos
			if(_menusCargadosEscenario == false)
			{
				_menusCargadosEscenario = true;
				Menu.loadMainMenu(menuPrincipal,botonesMenu,_posicionMenu, estadoBotonesMenu);
				Menu.loadOptionsMenu(menuOpciones,menuOpciones.botonSonido,menuOpciones.botonSonidoFondo,menuOpciones.botonPantallaCompleta,[58,587]);
				_navigation.listenerOcultarPopUp();
				//cancelamos la opcion que permite que este menu este sobre las demas ventanas para evitar
				//que la animacion de los globos nose vea sobre los demas botones
				CodeCraft.mainMenuLoaded = false;
			}
		}
		
		/**a
		* activa la carga del controlador de audio
		*/
		public function cargarMediaPlayer(botonSonido:MovieClip, posicion:Array = null):void
		{
			if(posicion == null)
			{
				posicion = new Array([],[275,116]);
			}
			//se carga el menu de reproduccion
			MediaPlayer.loadSound(AudioClass.audioEscenas[_navigation.escenaActual]);
			MediaPlayer.load(botonSonido,menuSonido,menuSonido.botonPlay,menuSonido.botonPrev,menuSonido.botonNext,menuSonido.controlBarraProgreso,menuSonido.controlBarra,posicion);
		}
		
		public function eliminarMediaPlayer():void 
		{
			MediaPlayer.remove();
		}
		
		/**
		* 
		*/
		public function cargarControlGrabacion ():void 
		{
			//se carga el menu de grabacion
			Record.load(null,menuGrabacion,menuGrabacion.botonGrabar,menuGrabacion.botonPlay,[[],[766,349]]);
		}
		
		public function eliminarControlGrabacion ():void 
		{
			Record.remove();
		}
		
		/**
		 * Carga el mensaje del popUp al boton donde se encuentra y le asigna el mensaje
		 * @param boton Hace referencia al boton del menu que se activo apra cargar el popUp
		 */
		public function cargarPopUp (boton:*):void 
		{
			var posicionBoton:int = Arrays.indexOf(botonesMenu,boton);
			//verifica si el boton se encuentra activo para cargar el mensaje
			if(estadoBotonesMenu[posicionBoton])
			{
				popUpBotonesMenu = new PopUpBotonesMenu();
				CodeCraft.addChild(popUpBotonesMenu,null,CodeCraft.getMainObject().mouseX,CodeCraft.getMainObject().mouseY);
				Texts.load(popUpBotonesMenu,_message.textoBotonesMenu[posicionBoton]);
			}
		}
		
		/**
		 * eliminar el boton del popUp de los botones del menu y limpia su variable, la funcion es llamada desde la clase
		 * AnimationClass cuando termina la animacion que oculta el mensaje
		 */
		public function eliminarPopUp ():void
		{
			if(popUpBotonesMenu != null)
			{
				CodeCraft.removeChild(popUpBotonesMenu);
				popUpBotonesMenu = null;
			}
		}
		
		
		/****************************************************************************************
		*
		* Carga el contenido de la escena numero 1, inicio donde sale la ciudad entera
		*
		****************************************************************************************/
		
		public var escenaInicio:MovieClip;
		public var ventanaInicio:MovieClip;
		public var arrayModule:Array;
		public var arrayPosition:Array;		
		
		public function configurarEscenainicio ():void 
		{
			escenaInicio = new EscenaInicio();
			ventanaInicio = new VentanaInicio();
			CodeCraft.addChild(escenaInicio,null,496,279);
			//this is to display the initial animation modules
			CodeCraft.scaleMode(escenaInicio,0.6);
			CodeCraft.addChild(ventanaInicio);
			arrayModule = new Array(
				escenaInicio.module1,
				escenaInicio.module2,
				escenaInicio.module3,
				escenaInicio.module4
			);
			arrayPosition = new Array(
				[600,-126],
				[-71,312],
				[578,663],
				[1114,350]
			);
			_animation.ventanaInicioIn();
			_navigation.listenerVentanaInicio();
		}
		
		public function eliminarVentanaInicio():void 
		{
			CodeCraft.removeChild(ventanaInicio);
			ventanaInicio = null;
			cargarInstrucciones();
		}
		
		public function eliminarEscenaInicio ():void 
		{
			CodeCraft.removeChild(escenaInicio);
			escenaInicio = null;
		}
		
		/****************************************************************************************
		*
		* Elementos del juego de lectura
		*
		****************************************************************************************/
		
		/* Almacena los botones del juego de lectura */
		public var botonesJuegoLectura:Array = new Array();
		/* Almacena las respuestas correctas que debe tener la seccion */
		public var respuestaJuegoLectura:Array;
		/* Almacena las instnacias de los clips que contienen los iconos de las x para malas y de los chulos para buenas */
		public var estadoRespuestasJuegoLectura:Array;
		
		public function configurarJuegoLectura ():void 
		{
			botonesJuegoLectura[0] = new Array(
				rutaJuego.Yes1,
				rutaJuego.Yes2,
				rutaJuego.Yes3,
				rutaJuego.Yes4,
				rutaJuego.Yes5
			);
			botonesJuegoLectura[1] = new Array(
				rutaJuego.No1,
				rutaJuego.No2,
				rutaJuego.No3,
				rutaJuego.No4,
				rutaJuego.No5
			);
			estadoRespuestasJuegoLectura = new Array(
				rutaJuego.respuesta1,
				rutaJuego.respuesta2,
				rutaJuego.respuesta3,
				rutaJuego.respuesta4,
				rutaJuego.respuesta5
			);
			respuestaJuegoLectura = new Array(
				true,
				true,
				false,
				false,
				true
			);
			CodeCraft.stopFrame(botonesJuegoLectura[0],"normal");
			CodeCraft.stopFrame(botonesJuegoLectura[1],"normal");
			CodeCraft.stopFrame(estadoRespuestasJuegoLectura,"bien");
			CodeCraft.visibility(estadoRespuestasJuegoLectura,false);
			Texts.load(botonesJuegoLectura[0],"Yes");
			Texts.load(botonesJuegoLectura[1],"No");
		}
		
		
	}
	
}