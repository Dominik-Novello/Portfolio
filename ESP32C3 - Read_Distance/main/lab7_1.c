#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include "driver/i2c.h"
#include "esp_log.h"
#include "driver/temperature_sensor.h"
#include "esp_timer.h"

#define TRIGGER_PIN 8
#define ECHO_PIN 10
#define DISTANCE_MAX 400
#define TIMEOUT 23200

#define I2C_MASTER_SCL_IO 8
#define I2C_MASTER_SDA_IO 10
#define I2C_MASTER_NUM I2C_NUM_0
#define I2C_MASTER_TX_BUF_DISABLE 0
#define I2C_MASTER_RX_BUF_DISABLE 0
#define I2C_MASTER_FREQ_HZ 100000
#define SHTC3_SENSOR_ADDR 0x70

#define SHTC3_CMD_READ_ID 0xEFC8
#define SHTC3_CMD_MEASURE 0x7866
#define SHTC3_MEAS 0x7CA2

static const char *TAG = "Lab7";

static esp_err_t i2c_master_init(){
	i2c_config_t conf = {
		.mode = I2C_MODE_MASTER,
		.sda_io_num = I2C_MASTER_SDA_IO,
		.sda_pullup_en = GPIO_PULLUP_ENABLE,
		.scl_io_num = I2C_MASTER_SCL_IO,
		.scl_pullup_en = GPIO_PULLUP_ENABLE,
		.master.clk_speed = I2C_MASTER_FREQ_HZ,
	};

	esp_err_t err = i2c_param_config(I2C_MASTER_NUM, &conf);

	if (err != ESP_OK){
		return err;
	}

	return i2c_driver_install(I2C_MASTER_NUM, conf.mode, I2C_MASTER_RX_BUF_DISABLE, I2C_MASTER_TX_BUF_DISABLE, 0);
}

static esp_err_t shtc3_read(uint16_t command, uint8_t *data, size_t size){
	esp_err_t err;

	i2c_cmd_handle_t cmd = i2c_cmd_link_create();
	i2c_master_start(cmd);
	i2c_master_write_byte(cmd, (SHTC3_SENSOR_ADDR << 1) | I2C_MASTER_WRITE, true);
	i2c_master_write_byte(cmd, SHTC3_MEAS >> 8, true);
	i2c_master_write_byte(cmd, SHTC3_MEAS & 0xFF, true);
	i2c_master_stop(cmd);
	err = i2c_master_cmd_begin(I2C_MASTER_NUM, cmd, pdMS_TO_TICKS(100));
	i2c_cmd_link_delete(cmd);
	if(err != ESP_OK) {
		ESP_LOGE(TAG, "Failed to send measurement command");
		return err;
	}

	vTaskDelay(pdMS_TO_TICKS(20));

	cmd = i2c_cmd_link_create();
	i2c_master_start(cmd);
	i2c_master_write_byte(cmd, (SHTC3_SENSOR_ADDR << 1) | I2C_MASTER_READ, true);
	i2c_master_read(cmd,data, 5, I2C_MASTER_ACK);
	i2c_master_read_byte(cmd, data + 5, I2C_MASTER_NACK);
	i2c_master_stop(cmd);
	err = i2c_master_cmd_begin(I2C_MASTER_NUM, cmd, pdMS_TO_TICKS(1000));
	i2c_cmd_link_delete(cmd);
	if(err != ESP_OK) {
		ESP_LOGE(TAG, "Failed to read data");
		return err;
	}

	return ESP_OK;
}


void app_main() {

	gpio_config_t io_conf = {
		.intr_type = GPIO_INTR_DISABLE,
		.mode = GPIO_MODE_OUTPUT,
		.pin_bit_mask = 1ULL << TRIGGER_PIN,
	};
	gpio_config(&io_conf);

	io_conf.intr_type = GPIO_INTR_POSEDGE,
	io_conf.mode = GPIO_MODE_INPUT,
	io_conf.pin_bit_mask = 1ULL << ECHO_PIN,
	gpio_config(&io_conf);

	esp_err_t err = i2c_master_init();
	if (err != ESP_OK){
		ESP_LOGE(TAG, "FAILED");
		return;
	}

	uint8_t data[6] = {0,};

	temperature_sensor_handle_t temp_sensor = NULL;
	temperature_sensor_config_t temp_sensor_config = TEMPERATURE_SENSOR_CONFIG_DEFAULT(10,50);
	
	ESP_ERROR_CHECK(temperature_sensor_install(&temp_sensor_config, &temp_sensor));
	ESP_ERROR_CHECK(temperature_sensor_enable(temp_sensor));

	float tsens_value;
	while (true) {
		gpio_set_level(TRIGGER_PIN, 0);
		esp_rom_delay_us(2);
		gpio_set_level(TRIGGER_PIN, 1);
		esp_rom_delay_us(10);
		gpio_set_level(TRIGGER_PIN, 0);

		if(shtc3_read(SHTC3_CMD_MEASURE, data, 6) == ESP_OK){
			ESP_ERROR_CHECK(temperature_sensor_get_celsius(temp_sensor, &tsens_value));
		} else {
			ESP_LOGE(TAG, "Failed to read data from the SHTC3 sensor");
		}

		uint32_t start = esp_timer_get_time();
		while(gpio_get_level(ECHO_PIN) == 0 && esp_timer_get_time() - start < TIMEOUT);

		start = esp_timer_get_time();
		while(gpio_get_level(ECHO_PIN) == 1 && esp_timer_get_time() - start < TIMEOUT);
		
		float SOS = 0.0001 * (331.4 + 0.6 * tsens_value);
		uint32_t time = esp_timer_get_time() - start;
		
		float distance = (time / 2) * SOS;
		printf("Distance: %.1f cm at %dC\n", distance, (int)tsens_value);

		vTaskDelay(pdMS_TO_TICKS(1000));

	}
}
