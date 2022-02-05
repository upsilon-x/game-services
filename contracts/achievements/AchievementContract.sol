// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
import "../project-control/ProjectNFT.sol";
import "../project-control/PermissionChecker.sol";
import "./AchievementLib.sol";

/**
 *
 */
contract AchievementContract is PermissionChecker {
    bytes32 constant ACHIEVEMENT_PERMISSION = keccak256("ACHIEVEMENTS");
    bytes32 constant AWARD_PERMISSION = keccak256("AWARD_ACHIEVEMENTS");

    using AchievementLib for AchievementLib.Achievement;

    event AchievementAwarded(
        address indexed user,
        uint8 indexed achievementId,
        uint256 totalPoints
    );

    uint256 public projectId;
    uint72 public totalAchievementsWon;
    uint8 public achievementCount;
    uint16 public maxAchievementPoints;
    address payable aggregator;

    // The achievements in the contract
    mapping(uint8 => AchievementLib.Achievement) achievements;

    // Achievements of each player
    mapping(address => uint256) internal achievementsAwarded;

    // Achievement points for each player
    mapping(address => uint256) public achievementPoints;

    // Number of times a user earned an achievement
    // (only accessible for achievements that canAchieveMultipleTimes)
    mapping(uint168 => uint256) public awardCount;

    constructor(uint256 _projectId, ProjectNFT _projects)
        PermissionChecker(_projects)
    {
        projectId = _projectId;
        aggregator = payable(msg.sender);
    }

    // The achievement must exist.
    modifier achievementExists(uint8 a) {
        require(a < achievementCount, "Achievement must exist!");
        _;
    }

    // Creates an achievement
    function createAchievement(AchievementLib.Achievement memory newAchievement)
        external
        hasAccess(projectId, ACHIEVEMENT_PERMISSION)
        returns (uint8 achievementId)
    {
        return _createAchievement(newAchievement);
    }

    function _createAchievement(AchievementLib.Achievement memory newAchievement)
        internal
        returns (uint8 achievementId)
    {
        require(achievementCount < 250, "Too many achievements!");
        achievements[achievementId] = newAchievement;
        achievementId = achievementCount;
        achievementCount++;
        maxAchievementPoints += newAchievement.achievementPoints;
        require(
            maxAchievementPoints < 1000,
            "Achievement points are too large."
        );
    }

    // Batch create achievements

    // Edits an achievement
    function editAchievement(
        uint8 id,
        uint16 points,
        uint120 canAchieveMultipleTimes
    ) external hasAccess(projectId, ACHIEVEMENT_PERMISSION) {
        _editAchievement(id, points, canAchieveMultipleTimes);
    }

    function _editAchievement(
        uint8 id,
        uint16 points,
        uint120 canAchieveMultipleTimes
    ) internal achievementExists(id) {
        AchievementLib.Achievement storage a = achievements[id];
        uint16 totalPoints = maxAchievementPoints -
            a.achievementPoints +
            points;
        maxAchievementPoints = totalPoints;

        a.achievementPoints = points;
        a.canAchieveMultipleTimes = canAchieveMultipleTimes;

        require(totalPoints < 1000, "Achievement points are too large.");
    }

    // Awards an achievement
    function award(address user, uint8 achievementId)
        external
        hasAccess(projectId, AWARD_PERMISSION)
    {
        AchievementLib.Achievement memory a = achievements[achievementId];
        uint256 achievementBits = achievementsAwarded[user];
        bool hasAchievement = (achievementBits >> achievementId) % 2 == 1;
        uint168 awardCountKey = ((uint160(user) << 8) | achievementId);
        require(
            !hasAchievement ||
                awardCount[awardCountKey] < a.canAchieveMultipleTimes,
            "Max awards for this achievement received."
        );

        totalAchievementsWon++;
        awardCount[awardCountKey]++;
        if (!hasAchievement) { 
            achievementPoints[user] += a.achievementPoints; 
            achievementsAwarded[user] = achievementBits | (0x1 << achievementId);
        }
        (bool success, ) = aggregator.call(
            abi.encodeWithSignature(
                "addToAchievements(uint256,address,uint8,uint16)",
                projectId,
                user,
                hasAchievement ? 0 : a.achievementPoints
            )
        );

        require(success, "Error with adding to total achievement points.");
        emit AchievementAwarded(user, achievementId, achievementPoints[user]);
    }
}
