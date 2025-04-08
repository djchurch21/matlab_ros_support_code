function traj_goal = convert2ROSPointVec(mat_joint_traj, robot_joint_names, traj_steps, traj_duration, traj_goal, optns)
%--------------------------------------------------------------------------
% convert2ROSPointVec
% Converts all of the MATLAB joint trajectory values into a vector of ROS
% Trajectory Points. 
% 
% Make sure all messages have the same DataFormat (i.e. struct)
%
% Inputs:
% mat_joint_traj (n x q) - matrix of n trajectory points for q joint values
% robot_joint_names {} - cell of robot joint names
% traj_goal (FollowJointTrajectoryGoal)
% optns (dict) - traj_duration, traj_steps, ros class handle
%
% Outputs:
% vector of TrajectoryPoints (1 x n)
%--------------------------------------------------------------------------
    
    % Get robot handle. Will work with r.point
    r = optns{'rHandle'};

    % Compute time step as duration over steps
    timeStep = traj_duration / traj_steps;
    
    % Set joint names. Assuming robot_joint_names is a cell array
    traj_goal.Trajectory.JointNames = robot_joint_names;
  
    %% Set Points
    % Create an array of TrajectoryPoint messages
    points = cell(1, traj_steps);

    % Iterate through trajectory points
    for i = 1:traj_steps
        % Create a new TrajectoryPoint message for each trajectory step
        point_msg = rosmessage('trajectory_msgs/JointTrajectoryPoint');
        
        % Set position for each joint (transpose to match expected format)
        point_msg.Positions = mat_joint_traj(i, :).';
        
        % Set velocities to zero (if not required, else set according to your needs)
        point_msg.Velocities = zeros(size(mat_joint_traj(i, :)));
        
        % Set accelerations to zero (if not required, else set according to your needs)
        point_msg.Accelerations = zeros(size(mat_joint_traj(i, :)));
        
        % Set the time for each point to the time step
        point_msg.TimeFromStart = rosduration(i * timeStep); % Time from start
        
        % Add the point to the points array
        points{i} = point_msg;
    end
    
    % Assign the points array to the trajectory goal
    traj_goal.Trajectory.Points = points;
end
