/**
 * Clase encargada de las animaciones principales
 * @author: Luis Felipe Zapata
 * @fecha: 26 de octubre del 2013
 */
package clases
{
 
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.TimelineMax;
	import codeCraft.media.Audio;
	import codeCraft.display.Button;
	import com.greensock.easing.Cubic;
	import codeCraft.core.CodeCraft;

	public class AnimationClass extends MovieClip 
	{
		//refencia de las clases utilizadas
		private var _movieClip:MovieClipClass;
		private var _navigation:NavigationClass;		
		private var _message:MessageClass;
		private var _escene:EsceneClass; 
		
		
		/* Realiza la animacion del boton de audio para indicar uqe puede presionarlo de nuevo */
		public var timeLineBotonSonido:TimelineMax = new TimelineMax();
		/* Realiza la animacion del boton del menu */
		public var timeLineBotonesMenu:TimelineMax = new TimelineMax();
		/* time line para el efecto de iluminado */
		public var timeLineEscenaInicio:TimelineMax;
		
		
		public function setVar (movieClipClass, navigationClass, messageClass, esceneClass):void 
		{
			_movieClip = movieClipClass;
			_navigation = navigationClass;
			_message = messageClass;
			_escene = esceneClass;
		}
		
		/****************************************************************************************
		*
		* Animacion de cambio de escenas
		*
		****************************************************************************************/
		
		/**
		* Carga el escenario de la escuela a la posicion de origen para poder volver a cargar los demas
		* escenarios
		*/
		public function restaurarEscuela ():void 
		{
			TweenMax.to(_movieClip.escenario,1,{scaleX: 1, scaleY: 1, x: 0, y: 0, ease: Cubic.easeOut, onComplete: _escene.cargarEscena});
		}
		
		
		/****************************************************************************************
		*
		* Animacion de carga de juegos
		*
		****************************************************************************************/
		
		/**
		* Anima la ventana que contiene los juegos para que aparesca en el escenario y al terminar la animacion
		* carga el listener del juego
		*/
		public function juegoIn():void 
		{
			var timeLine:TimelineMax = new TimelineMax({});
			timeLine.add(TweenMax.from(_movieClip.juegos,1,{alpha:0}));
			timeLine.add(TweenMax.from(_movieClip.juegos.ventana,1,{scaleX: 0, scaleY: 0, alpha: 0, ease: Back.easeOut}));
			timeLine.play();
		}

		/**
		* elimina los listener del juego y ejecuta una animacion para cerrar la ventana, cuando cierra la ventana
		* llama a una funcion de cambio de escena
		*/
		public function juegoOut():void 
		{
			if(_movieClip.juegos != null)
			{
				var timeLine:TimelineMax = new TimelineMax({onComplete: _movieClip.eliminarJuegoCompleto});
				timeLine.add(TweenMax.to(_movieClip.juegos.ventana,0.5,{scaleX: 0, scaleY: 0, alpha: 0, ease: Back.easeIn}));
				timeLine.add(TweenMax.to(_movieClip.juegos,0.2,{alpha:0}));			
				timeLine.play();
			}
		}
		
		/****************************************************************************************
		*
		* Animacion de las instrucciones
		*
		****************************************************************************************/
		
		public function instruccionesIn():void 
		{
			TweenMax.from(_movieClip.ventanaInstrucciones.ventana,1,{scaleX: 0, scaleY: 0, alpha:0, ease: Back.easeOut});
		}
		
		public function instruccionesOut():void 
		{
			if(_movieClip.ventanaInstrucciones != null)
			{
				var timeLine:TimelineMax = new TimelineMax({onComplete: _movieClip.eliminarInstrucciones});
				timeLine.add(TweenMax.to(_movieClip.ventanaInstrucciones.ventana,0.5,{scaleX: 0, scaleY: 0, ease: Back.easeIn}));
				timeLine.add(TweenMax.to(_movieClip.ventanaInstrucciones,0.5,{alpha: 0}));
				timeLine.play();
			}
		}
		

		/****************************************************************************************
		*
		* Animaciones los menus
		*
		****************************************************************************************/
		
		/**
		* Oculta el reproductor de media player si esta activo para cargar asi otra escena
		*/
		public function ocultarMediaPlayer ():void 
		{
			TweenMax.to(_movieClip.menuSonido,0.5,{alpha: 0,scaleX: 0, scaleY: 0, ease: Back.easeIn, onComplete: _movieClip.eliminarMediaPlayer});
		}
	
		/**
		* Anima los botones con el efecto de escala para que indique o llamen la atencion para dar clic
		*/
		public function animarBotonEscala():void 
		{
			timeLineBotonSonido= new TimelineMax({repeat: -1});
			timeLineBotonSonido.add(TweenMax.to(_movieClip.menuOpciones.botonSonido, 1, {scaleX:1.5, scaleY:1.5}));
			timeLineBotonSonido.add(TweenMax.to(_movieClip.menuOpciones.botonSonido, 1, {scaleX:1, scaleY:1}));
			timeLineBotonSonido.play();
			//se carga el istener para eliminar el efecto o animacion del boton del sonido
			_navigation.listenerBotonSonido();
			//se descativa el efecto over del boton la libreria lo habilita nuevamente 
			Button.removeOver(_movieClip.menuOpciones.botonSonido,1);
		}
		
		/**
		* Cancela la animacion de las escalas del boton del  menuOpciones
		*/
		public function detenerBotonEscala():void 
		{
			//se verifica si la animacion del boton de sonido no es null
			if (timeLineBotonSonido != null)
			{
				timeLineBotonSonido.stop();
				timeLineBotonSonido = null;
				TweenMax.to(_movieClip.menuOpciones.botonSonido, 1, {scaleX:1, scaleY:1});
			}
		}
		
		/**
		* Realiza una animacion de escala a los botones del menu que esten activos para indicarle al
		* aprendiz que debe presionar alguno de los botones, cuando se de clic a alguno de los botones
		* se cancela la animacion en la funcion _navigation.
		*/
		public function animacionEscalaBotonesMenu ():void 
		{
			timeLineBotonesMenu = new TimelineMax({repeat: -1});
			var arrayTemporalBotones:Array = new Array();
			//se recorre el estado de los botones
			for(var i:uint = 0; i < _movieClip.estadoBotonesMenu.length; i++)
			{
				if(_movieClip.estadoBotonesMenu[i] == true)
				{
					arrayTemporalBotones.push(_movieClip.botonesMenu[i]);
				}
			}
			timeLineBotonesMenu.add(TweenMax.allTo(arrayTemporalBotones, 1, {scaleX:1.5, scaleY:1.5}));
			timeLineBotonesMenu.add(TweenMax.allTo(arrayTemporalBotones, 1, {scaleX:1, scaleY:1}));
			timeLineBotonesMenu.play();
		}
		
		/**
		* Detiene la animacion de escala de los botones del menu despues de presionar alguno de ellos y cargar
		* una escena nueva
		*/
		public function detenerAnimacionEscalaBotonesMenu ():void 
		{
			//se verifica que tenga una animacion
			if(timeLineBotonesMenu != null)
			{
				timeLineBotonesMenu.stop();
				timeLineBotonesMenu = null;
				TweenMax.allTo(_movieClip.botonesMenu, 1, {scaleX:1, scaleY:1});
			}
		}
		
		
		/****************************************************************************************
		*
		* Animaciones de la escena del inicio donde esta la ciudad completa
		*
		****************************************************************************************/
		
		public function ventanaInicioIn():void 
		{
			var timeLine:TimelineMax = new TimelineMax();
			timeLine.add(TweenMax.from(_movieClip.ventanaInicio,0.5,{alpha:0}));
			timeLine.add(TweenMax.from(_movieClip.ventanaInicio.ventana,0.5,{scaleX:0, scaleY: 0, alpha: 0}));
			timeLine.play();
		}
		
		public function ventanaInicioOut():void 
		{
			var timeLine:TimelineMax = new TimelineMax({onComplete: _movieClip.eliminarVentanaInicio});
			timeLine.add(TweenMax.to(_movieClip.ventanaInicio.ventana,0.5,{scaleX:0, scaleY: 0, alpha: 0}));
			timeLine.add(TweenMax.to(_movieClip.ventanaInicio,0.5,{alpha:0}));
			timeLine.play();
		}
		
		public function animacionAlumbarEscenaInicio ():void
		{
			timeLineEscenaInicio = new TimelineMax({repeat:-1});
			timeLineEscenaInicio.add(TweenMax.to(_movieClip.escenaInicio.module1, 1,{dropShadowFilter:{color:0xffffff, alpha:1, blurX:75, blurY:75}}));
			timeLineEscenaInicio.add(TweenMax.to(_movieClip.escenaInicio.module1, 1,{dropShadowFilter:{color:0xffffff, alpha:1, blurX:0, blurY:0}}));
			timeLineEscenaInicio.play();
		}
		
		public function animacionDetenerAlumbarEscenaInicio ():void 
		{
			timeLineEscenaInicio.stop();
			TweenMax.to(_movieClip.escenaInicio.module1, 1,{dropShadowFilter:{color:0xffffff, alpha:1, blurX:0, blurY:0}});
		}
		
		//input animation
		public function animacionInicioIn ():void 
		{
			if(_navigation.positionIntro < _movieClip.arrayModule.length)
			{
				var timeLineMax:TimelineMax = new TimelineMax();
				timeLineMax.add(TweenMax.to(_movieClip.escenaInicio, 1, {scaleX:2, scaleY:2}));
				timeLineMax.add(TweenMax.to(_movieClip.escenaInicio, 1, {x:_movieClip.arrayPosition[_navigation.positionIntro][0], y:_movieClip.arrayPosition[_navigation.positionIntro][1]}));
				timeLineMax.add(TweenMax.to(_movieClip.arrayModule[_navigation.positionIntro], 1,{dropShadowFilter:{color:0xffffff, alpha:1, blurX:75, blurY:75}}));
				timeLineMax.add(TweenMax.to(_movieClip.arrayModule[_navigation.positionIntro], 1,{dropShadowFilter:{color:0xffffff, alpha:1, blurX:0, blurY:0},onComplete:animacionInicioIn}));
				timeLineMax.play();
				_navigation.positionIntro++;
			}
			else
			{
				TweenMax.to(_movieClip.escenaInicio, 1, {x:496, y: 279, scaleX:1, scaleY:1, onComplete:animacionInicioInComplete});
			}
		}
		
		private function animacionInicioInComplete():void 
		{
			_navigation.listenerEscenaInicio();
			animacionAlumbarEscenaInicio();
		}
		
		/****************************************************************************************
		*
		* Animaciones del juego movimiento Colision
		*
		****************************************************************************************/
		
		public function movimientoColisionIn():void 
		{
			
		}
		
		public function movimientoColisionOut():void 
		{
			
		}
		
		
	}

}