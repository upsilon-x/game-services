// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

library AchievementLib {

    struct Achievement {
        uint8 achievementId;
        uint16 achievementPoints;
        uint120 canAchieveMultipleTimes;
    }

}