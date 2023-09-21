#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/i2c.h"
#include "esp_log.h"
#include "sdkconfig.h"

#define ICM42670_ADDR 0x68
#define I2C_PORT I2C_NUM_0
#define SDA_PIN 10
#define SCL_PIN 8

static const char *TAG = "Lab3_1";

void i2c_master_init(){
	i2c_config_t conf = {
		.mode = I2C_MODE_MASTER,
		.sda_io_num = SDA_PIN,
		.sda_pullup_en = GPIO_PULLUP_ENABLE,
		.scl_io_num = SCL_PIN,
		.scl_pullup_en = GPIO_PULLUP_ENABLE,
		.master.clk_speed = 100000,
	};

	ESP_ERROR_CHECK(i2c_param_config(I2C_PORT, &conf));
	ESP_ERROR_CHECK(i2c_driver_install(I2C_PORT, conf.mode, 0, 0, 0));
}

void i2c_write(uint8_t reg, uint8_t data) {
	i2c_cmd_handle_t cmd = i2c_cmd_link_create();
	i2c_master_start(cmd);
	i2c_master_write_byte(cmd, (ICM42670_ADDR << 1) | I2C_MASTER_WRITE, true);
	i2c_master_write_byte(cmd, reg, true);
	i2c_master_write_byte(cmd, data, true);
	i2c_master_stop(cmd);
	i2c_master_cmd_begin(I2C_PORT, cmd, pdMS_TO_TICKS(1000));
	i2c_cmd_link_delete(cmd);
}

uint8_t i2c_read(uint8_t reg){
	uint8_t data;
	i2c_cmd_handle_t cmd = i2c_cmd_link_create();
	i2c_master_start(cmd);
	i2c_master_write_byte(cmd, (ICM42670_ADDR << 1) | I2C_MASTER_WRITE, true);
	i2c_master_write_byte(cmd, reg, true);
	i2c_master_start(cmd);
	i2c_master_write_byte(cmd, (ICM42670_ADDR << 1) | I2C_MASTER_READ, true);
	i2c_master_read_byte(cmd, & data, I2C_MASTER_LAST_NACK);
	i2c_master_stop(cmd);
	i2c_master_cmd_begin(I2C_PORT, cmd, pdMS_TO_TICKS(1000));
	i2c_cmd_link_delete(cmd);
	return data;
}

void icm42670_init() {
	i2c_write(0x1F, 0b00011111);

	i2c_write(0x20, 0b01101100);

	i2c_write(0x20, 0);
}

void read_accel() {
	int16_t data_x = (i2c_read(0x0B) << 8) | i2c_read(0x0C);
	int16_t data_y = (i2c_read(0x0D) << 8) | i2c_read(0x0E);
	//int16_t data_z = (i2c_read(0x0F) << 8) | i2c_read(0x10);

	if(data_x > 400){
		if(data_y > 400){
			ESP_LOGI(TAG, "LEFT/UP");
		} else if (data_y < -400){
			ESP_LOGI(TAG, "LEFT/DOWN");
		} else {
			ESP_LOGI(TAG, "LEFT");
		}
	} else if (data_x < -400) {
		if(data_y > 400){
			ESP_LOGI(TAG, "RIGHT/UP");
		} else if (data_y < -400){
			ESP_LOGI(TAG, "RIGHT/DOWN");
		} else {
			ESP_LOGI(TAG, "RIGHT");
		}
	} else if (data_y > 400){
		ESP_LOGI(TAG, "UP");
	} else if (data_y < -400){
		ESP_LOGI(TAG, "DOWN");
	}
}

void app_main(){
	i2c_master_init();
	icm42670_init();

	while (1){
		read_accel();
		vTaskDelay(pdMS_TO_TICKS(100));
	}
}
