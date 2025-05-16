export class BodyMetricsCalculator {
  static getAge(dateOfBirth) {
    const today = new Date();
    const birthDate = new Date(dateOfBirth);
    if (isNaN(birthDate) || birthDate > today) return null;

    let age = today.getFullYear() - birthDate.getFullYear();
    const isBirthdayPassed =
      today.getMonth() > birthDate.getMonth() ||
      (today.getMonth() === birthDate.getMonth() &&
        today.getDate() >= birthDate.getDate());

    if (!isBirthdayPassed) age--;
    return age;
  }

  static getBmi(weight, height) {
    if (weight && height) {
      height = height / 100; // cm to m
      return parseFloat((weight / (height ** 2)).toFixed(2));
    }
    return null;
  }

  static getBmr(weight, height, age, gender) {
    if (weight && height && age && gender) {
      if (gender === 'male') {
        return parseFloat((88.362 + 13.397 * weight + 4.799 * height - 5.677 * age).toFixed(2));
      } else {
        return parseFloat((447.593 + 9.247 * weight + 3.098 * height - 4.330 * age).toFixed(2));
      }
    }
    return null;
  }

  static getTdee(weight, height, age, gender, activityFactor) {
    const bmr = this.getBmr(weight, height, age, gender);
    if (bmr) return parseFloat((bmr * activityFactor).toFixed(2));
    return null;
  }

  static getLbm(weight, height, gender) {
    if (weight && height && gender) {
      return gender === 'male'
        ? parseFloat(((0.32810 * weight) + (0.33929 * height) - 29.5336).toFixed(2))
        : parseFloat(((0.29569 * weight) + (0.41813 * height) - 43.2933).toFixed(2));
    }
    return null;
  }

  static getFatPercentage(weight, height, age, gender) {
    const lbm = this.getLbm(weight, height, gender);
    if (lbm)
      return parseFloat(
        ((1.2 * (weight - lbm) / weight * 100) + (0.23 * age) - (gender === 'male' ? 10.8 : 0) - 5.4).toFixed(2)
      );
    return null;
  }

  static getWaterPercentage(weight, height, age, gender) {
    const fatPercentage = this.getFatPercentage(weight, height, age, gender);
    if (fatPercentage)
      return parseFloat(((100 - fatPercentage) * (gender === 'male' ? 0.55 : 0.49)).toFixed(2));
    return null;
  }

  static getBoneMass(weight, height, gender) {
    const lbm = this.getLbm(weight, height, gender);
    if (lbm)
      return parseFloat((lbm * (gender === 'male' ? 0.175 : 0.15)).toFixed(2));
    return null;
  }

  static getMuscleMass(weight, height, age, gender) {
    const fatPercentage = this.getFatPercentage(weight, height, age, gender);
    const boneMass = this.getBoneMass(weight, height, gender);
    if (fatPercentage && boneMass)
      return parseFloat((weight - (fatPercentage / 100 * weight) - boneMass).toFixed(2));
    return null;
  }

  static getProteinPercentage(weight, height, age, gender) {
    const muscleMass = this.getMuscleMass(weight, height, age, gender);
    const waterPercentage = this.getWaterPercentage(weight, height, age, gender);
    if (muscleMass && waterPercentage) {
      return parseFloat(((muscleMass * 0.19 + weight * waterPercentage * 0.01 * 0.16) / weight * 100).toFixed(2));
    }
    return null;
  }

  static getVisceralFat(weight, height, age, gender) {
    if (weight && height && age && gender) {
      return parseFloat((
        gender === 'male'
          ? weight * 0.1 + age * 0.05 + (0.1 * (weight / height))
          : weight * 0.08 + age * 0.06 + (0.08 * (weight / height))
      ).toFixed(2));
    }
    return null;
  }

  static getIdealWeight(height, gender) {
    if (height && gender) {
      const baseHeight = 152.4;
      const additionalWeightPerInch = 2.3;
      const heightInInches = (height - baseHeight) / 2.54;

      if (gender === 'male') {
        return parseFloat((50 + additionalWeightPerInch * heightInInches).toFixed(2));
      } else {
        return parseFloat((45.5 + additionalWeightPerInch * heightInInches).toFixed(2));
      }
    }
    return null;
  }
}
