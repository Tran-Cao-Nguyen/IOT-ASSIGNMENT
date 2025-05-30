import mqtt from 'mqtt';

const ACCESS_TOKEN = 'wxmqt1VbKfiufPvZ1FI1';
const MQTT_HOST = 'mqtt://app.coreiot.io';
const CLIENT_ID = `iot_client_${Math.random().toString(16).slice(2)}`;
const MQTT_TOPIC = 'v1/devices/me/telemetry';

let client = null;
let isConnected = false;

export async function connectToMqttBroker(maxRetries = 3, retryDelay = 1000) {
  if (isConnected) return client; // tránh kết nối lại nhiều lần

  let retries = 0;
  while (retries < maxRetries) {
    try {
      client = mqtt.connect(MQTT_HOST, {
        clientId: CLIENT_ID,
        username: ACCESS_TOKEN,
        reconnectPeriod: 5000,
      });

      return await new Promise((resolve, reject) => {
        client.on('connect', () => {
          console.log('Đã kết nối CoreIoT MQTT broker');
          isConnected = true;
          resolve(client);
        });

        client.on('error', (err) => {
          console.error(`MQTT error: ${err.message}`);
          client.end();
          reject(err);
        });
      });
    } catch (err) {
      retries++;
      if (retries >= maxRetries) {
        throw new Error(`Không thể kết nối MQTT sau ${maxRetries} lần: ${err.message}`);
      }
      console.log(`Thử lại kết nối (${retries}/${maxRetries})...`);
      await new Promise(resolve => setTimeout(resolve, retryDelay));
    }
  }
}

export const sendMetricsToMQTT = async (metrics) => {
  try {
    if (!client || !isConnected) {
      await connectToMqttBroker();
    }

    const payload = {};

    for (const metric of metrics) {
      if (metric.key && metric.value !== undefined) {
        payload[metric.key] = metric.value;
      }
    }

    await new Promise((resolve, reject) => {
      client.publish(MQTT_TOPIC, JSON.stringify(payload), { qos: 1 }, (err) => {
        if (err) {
          console.error('Gửi thất bại:', err.message);
          reject(err);
        } else {
          console.log('Gửi dữ liệu thành công');
          resolve();
        }
      });
    });
  } catch (error) {
    console.error('Lỗi trong sendMetricsToMQTT:', error.message);
    throw error;
  }
};
