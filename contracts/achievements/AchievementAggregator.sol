// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;
import "../project-control/ProjectNFT.sol";
import "../project-control/PermissionChecker.sol";
import "./AchievementContract.sol";

/**
 * Creates achievement contracts & stores them. Needs to be granted access to
 * the "Achievements" permission before it can do anything.
 */
contract AchievementAggregator is PermissionChecker {
    bytes32 constant ACHIEVEMENT_PERMISSION = keccak256("ACHIEVEMENTS");
    
    struct AchievementStats {
        uint128 achievementPoints;
        uint128 achievementsAwarded;
    }

    event AchievementContractCreated(uint indexed projectId, address indexed caller);
    event AchievementAwarded(uint indexed projectId, address indexed user, uint8 indexed awardId, uint16 points);

    // Maps projectIds to achievement contracts.
    mapping(uint256 => AchievementContract) public achievementContracts;

    // Maps achievement points to a user
    mapping(address => AchievementStats) public userAchivementStats;

    constructor(ProjectNFT _projects) PermissionChecker(_projects) {}

    // Creates an achievement contract
    function createAchievements(uint256 projectId)
        public
        hasAccess(projectId, ACHIEVEMENT_PERMISSION)
        userHasAccess(msg.sender, projectId, ACHIEVEMENT_PERMISSION)
    {
        require(
            address(achievementContracts[projectId]) == address(0),
            "Achievements already exist."
        );

        achievementContracts[projectId] = new AchievementContract(
            projectId,
            projects
        );

        emit AchievementContractCreated(projectId, msg.sender);
    }

    // Adds to the total achievement statistics
    function addToAchievements(uint256 projectId, address user, uint8 awardId, uint16 points) external {
        require(msg.sender == address(achievementContracts[projectId]), "Only the achievement contract can add to total points.");
        AchievementStats memory stats = userAchivementStats[user];
        userAchivementStats[user] = AchievementStats(stats.achievementPoints + points, stats.achievementsAwarded + 1);
        emit AchievementAwarded(projectId, user, awardId, points);
    }
}
