import express from "express";  
import { calculateMetrics } from "../controllers/apiController.js";

const router = express.Router();

router.post(`/metrics`, calculateMetrics);
export default router;