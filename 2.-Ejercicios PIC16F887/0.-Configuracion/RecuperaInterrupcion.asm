;Utilización de registros PCLATH para ejecutar interrupciones:
	MOVF		PC_R,W
	MOVWF		PCLATH
	WAPF		ST_R,W
	MOVWF		STATUS
	SWAPF		W_R,F
	SWAPF		W_R,W
	RETFIE