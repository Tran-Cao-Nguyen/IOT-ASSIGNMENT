import { BodyMetricsCalculator } from '../utils/calculateMetrics.js';
import { evaluate_overall_health } from '../utils/metricEvalutor.js';

export const calculateMetrics = (req, res) => {
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
        { key: "Weight", name: "Cân nặng", value: weight, unit: "Kg" },
        { key: "BMI", name: "Chỉ số khối (BMI)", value: bmi, unit: "" },
        { key: "BMR", name: "Tỉ lệ trao đổi chất (BMR)", value: bmr, unit: "kcal/ngày" },
        { key: "TDEE", name: "Năng lượng tiêu hao (TDEE)", value: tdee, unit: "kcal/ngày" },
        { key: "LBM", name: "Khối lượng không mỡ (LBM)", value: lbm, unit: "kg" },
        { key: "Fat %", name: "Tỉ lệ mỡ", value: fatPercentage, unit: "%" },
        { key: "Water %", name: "Tỉ lệ nước", value: waterPercentage, unit: "%" },
        { key: "Bone Mass", name: "Khối lượng xương", value: boneMass, unit: "kg" },
        { key: "Muscle Mass", name: "Khối lượng cơ", value: muscleMass, unit: "kg" },
        { key: "Protein %", name: "Tỉ lệ protein", value: proteinPercentage, unit: "%" },
        { key: "Visceral Fat", name: "Mỡ nội tạng", value: visceralFat, unit: "kg" },
        { key: "Ideal Weight", name: "Cân nặng lý tưởng", value: idealWeight, unit: "kg" },
        {overall},
    ];


    return res.json({ metrics });
};
