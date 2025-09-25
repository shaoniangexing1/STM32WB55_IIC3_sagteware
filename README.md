# STM32WB55 I2C3 Power Consumption Testing Software

## 项目概述 (Project Overview)

本项目实现了STM32WB55微控制器上I2C3外设在不同时钟源配置下的功耗测试软件。主要测试HSE+LSE和HSI+LSE两种时钟配置下I2C3的功耗表现。

This project implements power consumption testing software for the I2C3 peripheral on STM32WB55 microcontroller under different clock source configurations. It mainly tests I2C3 power consumption under HSE+LSE and HSI+LSE clock configurations.

## 技术需求 (Technical Requirements)

### 时钟配置 (Clock Configurations)
1. **HSE+LSE**: 高速外部晶振 + 低速外部晶振
   - HSE (High Speed External): 32MHz 外部晶振
   - LSE (Low Speed External): 32.768kHz 外部晶振
   - 适用于需要高精度时钟和低功耗蓝牙应用

2. **HSI+LSE**: 高速内部RC振荡器 + 低速外部晶振
   - HSI (High Speed Internal): 16MHz 内部RC振荡器
   - LSE (Low Speed External): 32.768kHz 外部晶振
   - 平衡成本和性能，仍支持蓝牙RF功能

### 为什么不测试LSI (Why LSI is not tested)
LSI (Low Speed Internal) 不支持蓝牙射频功能，因此不在测试范围内。蓝牙功能需要LSE提供精确的32.768kHz时钟。

LSI (Low Speed Internal) does not support Bluetooth RF functionality, so it's excluded from testing. Bluetooth functionality requires LSE to provide accurate 32.768kHz clock.

## 项目结构 (Project Structure)

```
STM32WB55_IIC3_sagteware/
├── Core/
│   ├── Inc/
│   │   ├── main.h                    # 主头文件
│   │   ├── stm32wbxx_hal_conf.h     # HAL配置文件
│   │   └── stm32wbxx_it.h           # 中断处理头文件
│   └── Src/
│       ├── main.c                    # 主程序文件
│       ├── stm32wbxx_hal_msp.c      # MSP初始化文件
│       ├── stm32wbxx_it.c           # 中断处理文件
│       └── system_stm32wbxx.c       # 系统初始化文件
├── Makefile                          # 构建文件
└── README.md                         # 项目说明
```

## 主要功能 (Main Features)

### 1. 时钟源切换 (Clock Source Switching)
- `SystemClock_Config_HSE_LSE()`: 配置HSE+LSE时钟
- `SystemClock_Config_HSI_LSE()`: 配置HSI+LSE时钟
- `Switch_Clock_Source()`: 动态切换时钟源

### 2. I2C3外设配置 (I2C3 Peripheral Configuration)
- 标准I2C通信配置
- 支持7位地址模式
- 配置为主机模式
- GPIO引脚: PC0 (SCL), PC1 (SDA)

### 3. 功耗测试 (Power Consumption Testing)
- `I2C3_Power_Test()`: 执行I2C3功耗测试
- 测试持续时间: 10秒
- 包含I2C读写操作
- 功耗测量钩子函数

### 4. 测试控制 (Test Control)
- `Run_Power_Consumption_Tests()`: 完整测试流程
- 自动切换时钟源
- 系统稳定化延时
- 循环测试执行

## 硬件连接 (Hardware Connections)

### I2C3引脚定义 (I2C3 Pin Definitions)
- **SCL**: PC0 - 时钟线
- **SDA**: PC1 - 数据线

### 外部器件需求 (External Component Requirements)
- 32MHz HSE晶振 (可选，用于HSE+LSE配置)
- 32.768kHz LSE晶振 (必需，蓝牙功能要求)
- I2C从设备用于测试 (地址: 0xA0)

## 功耗测量方法 (Power Measurement Methods)

### 外部测量工具 (External Measurement Tools)
软件提供了功耗测量的钩子函数，可以与外部功耗测量工具集成：

1. **Power_Measurement_Start()**: 开始功耗测量标记点
2. **Power_Measurement_Stop()**: 结束功耗测量标记点

### 建议的测量设置 (Recommended Measurement Setup)
1. 使用高精度电流表或功耗分析仪
2. 在VDD引脚串联测量
3. 记录测试期间的平均功耗
4. 对比不同时钟配置下的功耗差异

## 使用方法 (Usage Instructions)

### 1. 编译项目 (Build Project)
```bash
make clean
make all
```

### 2. 烧录程序 (Flash Program)
使用ST-Link或其他支持的调试器烧录生成的.hex文件到STM32WB55开发板。

### 3. 运行测试 (Run Tests)
程序启动后会自动执行以下测试序列：
1. HSE+LSE配置下的I2C3功耗测试 (10秒)
2. 2秒间隔
3. HSI+LSE配置下的I2C3功耗测试 (10秒)
4. 30秒等待后重复测试循环

### 4. 结果分析 (Result Analysis)
通过外部功耗测量工具记录两种配置下的功耗数据，进行对比分析。

## 测试参数配置 (Test Parameter Configuration)

可以通过修改main.h文件中的宏定义来调整测试参数：

```c
#define POWER_TEST_DURATION_MS    10000   // 测试持续时间(毫秒)
#define I2C_TEST_DATA_SIZE        128     // I2C测试数据大小
#define I2C_TEST_ADDRESS          0xA0    // I2C测试地址
```

## 预期结果 (Expected Results)

### HSE+LSE配置
- 优点: 高精度时钟，优秀的时钟稳定性
- 缺点: 需要外部晶振，可能功耗稍高

### HSI+LSE配置
- 优点: 降低BOM成本，内部RC振荡器
- 缺点: 时钟精度相对较低，但仍满足I2C通信需求

## 注意事项 (Important Notes)

1. **蓝牙兼容性**: 两种配置都保持LSE用于蓝牙功能
2. **系统稳定性**: 时钟切换后有延时确保系统稳定
3. **I2C从设备**: 需要连接I2C从设备以完成通信测试
4. **功耗测量**: 建议使用专业功耗测量设备
5. **测试环境**: 保持一致的测试环境条件

## 故障排除 (Troubleshooting)

### 常见问题 (Common Issues)
1. **I2C通信失败**: 检查从设备连接和地址设置
2. **时钟配置失败**: 确认外部晶振连接正确
3. **功耗测量不准确**: 检查测量工具配置和连接

### 调试建议 (Debug Recommendations)
1. 使用调试器监控程序执行
2. 添加GPIO指示信号标记测试阶段
3. 串口输出测试状态信息

## 扩展功能 (Extended Features)

### 可选增强 (Optional Enhancements)
1. 添加串口调试输出
2. 实现内置功耗测量ADC
3. 增加更多时钟配置选项
4. 实现测试结果数据记录

## 许可证 (License)

本项目基于STMicroelectronics的HAL库开发，遵循相应的开源许可证。

This project is developed based on STMicroelectronics HAL library and follows the corresponding open source license.

## 联系支持 (Contact & Support)

如有技术问题或改进建议，请通过GitHub Issues或相关技术论坛联系。

For technical questions or improvement suggestions, please contact through GitHub Issues or relevant technical forums.