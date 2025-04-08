function grip_goal = packGripGoal_struct(gripPos, grip_goal, optns)
    % Assuming you want to create a simple gripper trajectory with positions
    % and possibly velocities, without efforts (as this is not recognized).
    
    % Example: Joint names and positions based on the grip position
    jointWaypoints = [gripPos];  % Assuming only one gripper joint
    
    % Set joint names (for example, gripper joints)
    grip_goal.Trajectory.JointNames = {'gripper_joint'};  % Adjust as needed
    
    % Initialize the points structure (typically a cell array)
    points = rosmessage('trajectory_msgs/JointTrajectoryPoint');
    
    % Set positions (e.g., the gripper's position)
    points.Positions = jointWaypoints;  % Set joint position
    
    % Optionally: Set velocities and accelerations (if required)
    points.Velocities = zeros(size(jointWaypoints));  % Placeholder (adjust as needed)
    points.Accelerations = zeros(size(jointWaypoints));  % Placeholder (adjust as needed)
    
    % Set points into the trajectory
    grip_goal.Trajectory.Points = points;
end
