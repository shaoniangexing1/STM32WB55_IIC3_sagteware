/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32wbxx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* Clock Source Configuration Types */
typedef enum {
    CLOCK_HSE_LSE = 0,
    CLOCK_HSI_LSE = 1
} ClockSource_t;

/* Power Test Status */
typedef enum {
    POWER_TEST_IDLE = 0,
    POWER_TEST_RUNNING = 1,
    POWER_TEST_COMPLETE = 2
} PowerTestStatus_t;

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* I2C3 Configuration */
#define I2C3_SCL_PIN                    GPIO_PIN_0
#define I2C3_SCL_GPIO_PORT              GPIOC
#define I2C3_SDA_PIN                    GPIO_PIN_1
#define I2C3_SDA_GPIO_PORT              GPIOC

/* Test Parameters */
#define POWER_TEST_DURATION_MS          10000  /* 10 seconds per test */
#define I2C_TEST_DATA_SIZE              128
#define I2C_TEST_ADDRESS                0xA0   /* Test I2C slave address */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* Clock Configuration Functions */
void SystemClock_Config_HSE_LSE(void);
void SystemClock_Config_HSI_LSE(void);

/* I2C Functions */
void MX_I2C3_Init(void);
void I2C3_Power_Test(void);

/* Power Measurement Functions */
void Power_Measurement_Start(void);
void Power_Measurement_Stop(void);
uint32_t Power_Measurement_Get_Result(void);

/* Test Control Functions */
void Run_Power_Consumption_Tests(void);
void Switch_Clock_Source(ClockSource_t source);

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */