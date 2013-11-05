/**
 * Clase encargada de almacenar la url de los audios de la presentacion
 * @author: Luis Felipe Zapata
 * @fecha: 26 de Octubre del 2013
 */
package clases 
{
	import flash.utils.Dictionary;
	
	public class AudioClass 
	{
		
		public static var audioArray:Array = new Array(
			//Sonidos del sistema
				//sonido de inicio
				null,
				//sonido de menu instrucciones
				null,
				//sonido de fondo
				"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/ambiente.mp3"
		);
		
		/* Audio para la carga de las escenas */
		public static var audioEscenas:Dictionary =  new Dictionary();
		
		/* Audio de las instrucciones de cada seccion */
		public static var audiosInstrucciones:Dictionary = new Dictionary();
		
		public static function inciarAudios():void
		{
			
			audiosInstrucciones["inicio"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["audio"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["lectura"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["observar"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["computador1"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["computador2"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["computador3"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["computador4"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["computador5"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["pronunciacion"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["diccionario"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audiosInstrucciones["video"] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			
			
			audioEscenas['inicio'] = null;
			audioEscenas['audio'] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audioEscenas['lectura'] = "http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Instrucciones/instruction.mp3";
			audioEscenas['observar1'] = new Array(
				null
			);
			audioEscenas['observar2'] = new Array(
				null
			);
			audioEscenas['computador1'] = new Array(null);
			audioEscenas['computador2'] = new Array(null);
			audioEscenas['computador3'] = new Array(null);
			audioEscenas['computador4'] = new Array(null);
			audioEscenas['computador5'] = new Array(null);
			audioEscenas['pronunciacion'] = new Array(
				[
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/chinesse.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/colombian.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/italian.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/american.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/french.mp3"
				],
				[
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/chinesse.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/colombian.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/italian.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/american.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/french.mp3"
				],
				[
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/chinesse.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/colombian.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/italian.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/american.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/french.mp3"
				]
			);
			audioEscenas['diccionario'] = new Array(
				[
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/chinesse.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/colombian.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/italian.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/american.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/french.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/mexican.mp3"
				],
				[
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/bag.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/cartridge.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/calculators.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/markers.mp3"
				],
				[
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/1.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/2.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/3.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/4.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/5.mp3"
				],
				[
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/6.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/7.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/8.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/9.mp3",
					"http://sena.blackboard.com/bbcswebdav/institution/51250026_1_VIRTUAL/Audio_visuales/Audios/Actividad_Aprendizaje_1/Vocabulario/10.mp3"
				]
				
			);
			audioEscenas['video'] = null;
			
		}
	}
}