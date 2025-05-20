import express from "express";
import cors from "cors";
import dotenv from "dotenv";
dotenv.config();
import os from "os";
import api from "./routes/api.js";
import { connectToMqttBroker } from "./utils/mqttPublisher.js";
const port = process.env.PORT || 8000;
const api_url = process.env.API_URL;


const app = express();
// Cấu hình CORS cho tất cả các domain
app.use(cors());

app.use(express.json());

app.use(
  express.urlencoded({
    extended: true,
  })
);

// 🔥 Lấy địa chỉ IP khả dụng tự động
const getLocalExternalIP = () => {
  const networkInterfaces = os.networkInterfaces();
  const ipAddress = Object.values(networkInterfaces)
    .flat()
    .find((details) => details.family === 'IPv4' && !details.internal)?.address;
  return ipAddress || '0.0.0.0'; // Trả về '0.0.0.0' nếu không tìm thấy IP nào
};
const HOST = getLocalExternalIP();

await connectToMqttBroker();

app.listen(port, HOST, () => {
  // const networkInterfaces = os.networkInterfaces();
  // const ip = Object.values(networkInterfaces)
  //   .flat()
  //   .find((details) => details.family === 'IPv4' && !details.internal)?.address;

  console.log(`Server is running on: http://${HOST || 'localhost'}:${port}${api_url}`);
});

  app.get('/', (req, res) => {
    res.send('Hello from Express server');
  });
    app.use(`${api_url}/`, api);