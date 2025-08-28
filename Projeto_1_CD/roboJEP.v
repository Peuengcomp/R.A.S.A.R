module roboJEP (CH, BF, SF, SD, SE, ST, CE, CD, LedR, LedG, RE, RD);
	input CH, BF, SF, SD, SE, ST;
	output CE, CD, LedR, LedG, RE, RD;

	//Portas NOT dos Sensores
	not Sensor_Bateria (notBF, BF); 
	not Sensor_Frontal (notSF, SF); 
	not Sensor_Direito (notSD, SD); 
	not Sensor_Esquerdo (notSE, SE); 
	
	//Porta NOT para garantir que o robô não está parado
	not LED_RED_Off (notRED, andRED);

	//Portas AND das combinações de sensores
	and SE_SD_SE (andFD_E, SF, SD, notSE); //Sensores Frente, Direita e Esquerda Negado
	and SF_SD_ST (andFDT, SF, SD, ST); //Sensores Frente, Direita e Traseiro
	and SF_SD (andF_D, SF, notSD); //Sensores Frente e Direita Negado
	and SF_SE (andFE, SF, SE); //Sensores Frente e Esquerda
	
	//Portas AND para que as movimentações só ocorram se a chave estiver ligada e o sensor de bateria desligado
	and VerificarEsquerda (andEsquerda, notBF, CH, orEsquerda); //Virar à Esquerda
	and VerificarFrente (andFrente, notBF, CH, notSF); //Ir em Frente
	and VerificarDireita (andDireita, notBF, CH, orDireita); //Virar à Esquerda
	
	//Portas AND para que a mensagem de bateria fraca só apareça se o robô estiver ligado
	and BateriaFracaR (andBFR, BF, CH);
	and BateriaFracaG (LedG, BF, CH); 
	
	//Porta AND do robô parado
	and CondicaoParada (andRED, andEsquerda, andDireita); 

	//Porta AND movimentações, se o robô não estiver parado
	and VerificarParadaESQ_LED (CE, notRED, xorRD);
	and VerificarParadaDIR_LED (CD, notRED, xorRE);
	and VerificarParadaDIR_RODA (RE, notRED,  xorRE);
	and VerificarParadaESQ_RODA (RD, notRED, xorRD);

	//Portas OR das direções do robô
	or VirarEsquerda (orEsquerda, andFD_E, andFDT); 
	or VirarDireita (orDireita, andF_D, andFE); 
	
	//Porta OR para acender o LED Vermelho em caso de parada ou bateria fraca
	or AcenderVermelho (LedR, andBFR, andRED);
	
	//Portas XOR para que as rodas só funcionem, exclusivamente, para ir para frente
	//ou para a direção desejada
	xor AcionarRodaESQ (xorRE, andFrente, andDireita); //Roda Esquerda
	xor AcionarRodaDIR (xorRD, andEsquerda, andFrente); //Roda Direita

endmodule
