function resetWorld(optns)
%--------------------------------------------------------------------------
% resetWorld()
% Calls Gazebo service to reset the world
% Input: (struct) optns - contains the robot handle under 'robot' (optional)
% Output: None
%--------------------------------------------------------------------------
    disp('Resetting the world...');

    % 01 Get robot handle (optional)
    if isfield(optns, 'robot') && ~isempty(optns.robot)
        robot = optns.robot;
        resetClient = rossvcclient(robot, '/gazebo/reset_world');
    else
        % Use global node
        resetClient = rossvcclient('/gazebo/reset_world');
    end

    % 02 Create empty reset message
    resetReq = rosmessage(resetClient);

    % 03 Call reset service
    try
        call(resetClient, resetReq, 'Timeout', 3);
        disp('World reset successfully.');
    catch ME
        warning('Failed to reset world: %s', ME.message);
    end
end

