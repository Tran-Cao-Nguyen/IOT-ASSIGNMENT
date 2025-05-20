import { BodyMetricsCalculator } from '../utils/calculateMetrics.js';
import { evaluate_overall_health } from '../utils/metricEvalutor.js';
import { sendMetricsToMQTT } from '../utils/mqttPublisher.js';

export const calculateMetrics = async (req, res) => {
  try {
    const { gender, race, birthday, height, weight, activityFactor } = req.body;
    const age = BodyMetricsCalculator.getAge(birthday);
    const bmi = BodyMetricsCalculator.getBmi(weight, height);
    const bmr = BodyMetricsCalculator.getBmr(weight, height, age, gender);
    const tdee = BodyMetricsCalculator.getTdee(weight, height, age, gender, activityFactor);
    const lbm = BodyMetricsCalculator.getLbm(weight, height, gender);
    const fatPercentage = BodyMetricsCalculator.getFatPercentage(weight, height, age, gender);
    const waterPercentage = BodyMetricsCalculator.getWaterPercentage(weight, height, age, gender);
    const boneMass = BodyMetricsCalculator.getBoneMass(weight, height, gender);
    const muscleMass = BodyMetricsCalculator.getMuscleMass(weight, height, age, gender);
    const proteinPercentage = BodyMetricsCalculator.getProteinPercentage(weight, height, age, gender);
    const visceralFat = BodyMetricsCalculator.getVisceralFat(weight, height, age, gender);
    const idealWeight = BodyMetricsCalculator.getIdealWeight(height, gender);
    const overall = evaluate_overall_health(bmi, age, gender, race);

    const metrics = [
      { key: "Height", name: "Chiều cao", value: height, unit: "Cm" },
      { key: "Gender", name: "Giới tính", value: gender, unit: "" },
      { key: "Race", name: "Chủng tộc", value: race, unit: "" },
      { key: "Age", name: "Tuổi", value: age, unit: "" },
      { key: "Weight", name: "Cân nặng", value: weight, unit: "Kg" },
      { key: "BMI", name: "Chỉ số khối (BMI)", value: bmi, unit: "" },
      { key: "BMR", name: "Tỉ lệ trao đổi chất (BMR)", value: bmr, unit: "kcal/ngày" },
      { key: "TDEE", name: "Năng lượng tiêu hao (TDEE)", value: tdee, unit: "kcal/ngày" },
      { key: "LBM", name: "Khối lượng không mỡ (LBM)", value: lbm, unit: "kg" },
      { key: "Fat_Percentage", name: "Tỉ lệ mỡ", value: fatPercentage, unit: "%" },
      { key: "Water_Percentage", name: "Tỉ lệ nước", value: waterPercentage, unit: "%" },
      { key: "Bone_Mass", name: "Khối lượng xương", value: boneMass, unit: "kg" },
      { key: "Muscle_Mass", name: "Khối lượng cơ", value: muscleMass, unit: "kg" },
      { key: "Protein_Percentage", name: "Tỉ lệ protein", value: proteinPercentage, unit: "%" },
      { key: "Visceral_Fat", name: "Mỡ nội tạng", value: visceralFat, unit: "kg" },
      { key: "Ideal_Weight", name: "Cân nặng lý tưởng", value: idealWeight, unit: "kg" },
      { key: "Overall", name: "Đánh giá tổng thể", value: overall.overall_status, unit: "" },
      {overall},
];

    // Send Data
    await sendMetricsToMQTT(metrics);

    return res.json({ metrics });
  } catch (error) {
    console.error('Lỗi khi tính toán/gửi MQTT:', error.message);
    return res.status(500).json({ error: 'Đã có lỗi xảy ra khi xử lý dữ liệu.' });
  }
};
