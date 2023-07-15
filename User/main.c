/**
  ******************************************************************************
  * File Name          : main.c
  * Description        : Main program body
  ******************************************************************************
  *
  * COPYRIGHT(c) 2015 STMicroelectronics
  *
  * Redistribution and use in source and binary forms, with or without modification,
  * are permitted provided that the following conditions are met:
  *   1. Redistributions of source code must retain the above copyright notice,
  *      this list of conditions and the following disclaimer.
  *   2. Redistributions in binary form must reproduce the above copyright notice,
  *      this list of conditions and the following disclaimer in the documentation
  *      and/or other materials provided with the distribution.
  *   3. Neither the name of STMicroelectronics nor the names of its contributors
  *      may be used to endorse or promote products derived from this software
  *      without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  */
	
/*
		MODIFIED by Hexabitz for BitzOS (BOS) V0.2.2 - Copyright (C) 2017-2020 Hexabitz
    All rights reserved
*/

/* Includes ------------------------------------------------------------------*/
#include "BOS.h"
#include "H08R6.h"


/* Private variables ---------------------------------------------------------*/
float sensor = 0.0f;
uint32_t period = 100;
/* Private function prototypes -----------------------------------------------*/
bool DetectedPing(float distance);


/* Main functions ------------------------------------------------------------*/

int main(void)
{


  /* MCU Configuration----------------------------------------------------------*/

  /* Reset all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* Configure the system clock */
  SystemClock_Config();

  /* Initialize all user peripherals */

	/* Initialize BitzOS */
	BOS_Init();

  /* Call init function for freertos objects (in freertos.c) */
  MX_FREERTOS_Init();

  /* Start scheduler */
  osKernelStart();
  
  /* We should never get here as control is now taken by the scheduler */

  /* Infinite loop */
  while (1)
  {


  }


}

/*-----------------------------------------------------------*/

/* User Task */
void UserTask(void * argument)
{
	//Start stream data to each other among modules
	#if _module == 1
		// Set units to mm
		SetRangeUnit(UNIT_MEASUREMENT_MM);
		// Stream to memory
		Stream_ToF_Memory(50, portMAX_DELAY, &sensor);
	#endif	
	#if _module == 2
		// Set units to cm
		SetRangeUnit(UNIT_MEASUREMENT_MM);
		// Stream to memory
		Stream_ToF_Memory(50, portMAX_DELAY, &sensor);
	#endif	
	
  /* Infinite loop */
  for(;;)
  {
		 //For the case of module 1, if DetectedPing(sensor) is true, send a serial message to PC. "1\r\n\"
		 #if _module == 1 //1st instrument
						if (DetectedPing(sensor)) 
						{					
							sprintf( ( char * ) pcUserMessage, "1\r\n");
							writePxMutex(PcPort, pcUserMessage, strlen(pcUserMessage), cmd50ms, HAL_MAX_DELAY);
							responseStatus = BOS_OK;	
							IND_blink(1);
							
						}
				#endif
				
				//For the case of module 1, if DetectedPing(sensor) is true, send a serial message to PC. "2\r\n\"
				//Since module 2 cannot send a message directly to PC without passing module 1,
				//Program uses CODE_USER_MESSAGE_01 to tell module 1 to print out given Message
				#if _module == 2 //2nd instrument
						if (DetectedPing(sensor)) 
						{					
						/*	sprintf( ( char * ) pcUserMessage, "2\r\n");
							writePxMutex(PcPort, pcUserMessage, strlen(pcUserMessage), cmd50ms, HAL_MAX_DELAY);
							responseStatus = BOS_OK;	
							IND_blink(1);*/
							SendMessageToModule(1, CODE_USER_MESSAGE_01, 5);
							IND_blink(1);
						  //Delay_ms(1);
						}
				#endif
	}
}

//Method to findout whether an object is within distance for each of the modules to trigger
// if condtions at for(;;)
bool DetectedPing(float distance)
{
		static float state;
	if (distance < 200.0f && state != 1)
	{
		state = 1;	// Detected an object
		return true;
	}
	else if (distance >= 200.0f && state == 1) {
		state = 2;	// The object cleared
	} 
	return false;	
}

/*-----------------------------------------------------------*/

/************************ (C) COPYRIGHT HEXABITZ *****END OF FILE****/
