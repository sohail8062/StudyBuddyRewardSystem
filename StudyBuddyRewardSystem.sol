// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Study Buddy Reward System
 * @dev A blockchain-based reward system for students
 * @author Study Buddy Team
 */
contract Project {
    
    // State variables
    mapping(address => uint256) public studyCoins;
    mapping(address => uint256) public totalStudyTime;
    mapping(address => string) public studentNames;
    mapping(address => bool) public registeredStudents;
    
    uint256 public constant COINS_PER_HOUR = 4; // 1 coin per 15 minutes
    uint256 public constant MIN_STUDY_TIME = 15 * 60; // 15 minutes in seconds
    
    // Events
    event StudentRegistered(address indexed student, string name);
    event StudySessionCompleted(address indexed student, uint256 studyTime, uint256 coinsEarned);
    event CoinsRedeemed(address indexed student, uint256 coins, string reward);
    
    /**
     * @dev Core Function 1: Register a new student
     * @param _name Student's name
     */
    function registerStudent(string memory _name) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(!registeredStudents[msg.sender], "Student already registered");
        
        studentNames[msg.sender] = _name;
        registeredStudents[msg.sender] = true;
        studyCoins[msg.sender] = 0;
        totalStudyTime[msg.sender] = 0;
        
        emit StudentRegistered(msg.sender, _name);
    }
    
    /**
     * @dev Core Function 2: Complete a study session and earn coins
     * @param _studyMinutes Number of minutes studied
     */
    function completeStudySession(uint256 _studyMinutes) public {
        require(registeredStudents[msg.sender], "Student not registered");
        require(_studyMinutes >= 15, "Minimum 15 minutes required");
        require(_studyMinutes <= 480, "Maximum 8 hours per session");
        
        uint256 coinsEarned = (_studyMinutes * COINS_PER_HOUR) / 60;
        
        studyCoins[msg.sender] += coinsEarned;
        totalStudyTime[msg.sender] += _studyMinutes;
        
        emit StudySessionCompleted(msg.sender, _studyMinutes, coinsEarned);
    }
    
    /**
     * @dev Core Function 3: Redeem coins for rewards
     * @param _coins Number of coins to redeem
     * @param _reward Description of the reward
     */
    function redeemCoins(uint256 _coins, string memory _reward) public {
        require(registeredStudents[msg.sender], "Student not registered");
        require(studyCoins[msg.sender] >= _coins, "Insufficient coins");
        require(_coins > 0, "Must redeem at least 1 coin");
        require(bytes(_reward).length > 0, "Reward description required");
        
        studyCoins[msg.sender] -= _coins;
        
        emit CoinsRedeemed(msg.sender, _coins, _reward);
    }
    
    /**
     * @dev Get student statistics
     * @param _student Student address
     * @return name Student name
     * @return coins Current coin balance
     * @return totalTime Total study time in minutes
     */
    function getStudentStats(address _student) public view returns (
        string memory name,
        uint256 coins,
        uint256 totalTime
    ) {
        return (
            studentNames[_student],
            studyCoins[_student],
            totalStudyTime[_student]
        );
    }
    
    /**
     * @dev Check if student is registered
     * @param _student Student address
     * @return Boolean indicating registration status
     */
    function isRegistered(address _student) public view returns (bool) {
        return registeredStudents[_student];
    }
}
