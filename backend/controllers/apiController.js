import { BodyMetricsCalculator } from '../utils/calculateMetrics.js';

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

    const metrics = [
        { name: "Weight", value: weight, unit: "Kg" },
        { name: "BMI", value: bmi, unit: "" },
        { name: "BMR", value: bmr, unit: "kcal/day" },
        { name: "TDEE", value: tdee, unit: "kcal/day" },
        { name: "LBM", value: lbm, unit: "kg" },
        { name: "Fat %", value: fatPercentage, unit: "%" },
        { name: "Water %", value: waterPercentage, unit: "%" },
        { name: "Bone Mass", value: boneMass, unit: "kg" },
        { name: "Muscle Mass", value: muscleMass, unit: "kg" },
        { name: "Protein %", value: proteinPercentage, unit: "%" },
        { name: "Visceral Fat", value: visceralFat, unit: "kg" },
        { name: "Ideal Weight", value: idealWeight, unit: "kg" }
    ];

    return res.json(metrics);
};
