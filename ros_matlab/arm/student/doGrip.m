function [res, state] = doGrip(type, optns, doGripValue)
%--------------------------------------------------------------------------
% doGrip
% Tell gripper to either pick or place via the ROS gripper action client.
%
% Inputs:
%   type (string) - 'pick' or 'place'
%   optns - containers.Map with robot handle under key 'rHandle'
%   doGripValue (optional) - value for grip position
%
% Outputs:
%   res - action result
%   state - goal state
%--------------------------------------------------------------------------

    %% Input Handling
    if nargin < 2
        error('doGrip requires at least 2 arguments: type and optns');
    end

    % Set default grip position if not provided
    if nargin < 3
        doGripValue = 0.8;  % Default pick (closed) position
    end

    %% Get robot handle from optns
    if isa(optns, 'containers.Map') && isKey(optns, 'rHandle')
        r = optns('rHandle');
    else
        error('Missing or invalid rHandle in optns. Must be containers.Map with key ''rHandle''.');
    end

    % Check if grip_action_client exists and is valid
    if ~isprop(r, 'grip_action_client') || isempty(r.grip_action_client)
        error('grip_action_client not found or is empty in rHandle');
    end

    %% Create grip goal message
    grip_goal = rosmessage(r.grip_action_client);  % Assumes FollowJointTrajectoryGoal

    % Optional: remove feedback/result callback functions
    r.grip_action_client.FeedbackFcn = [];
    r.grip_action_client.ResultFcn = [];

    %% Set grip position
    if strcmpi(type, 'place')
        gripPos = 0;  % Open
    elseif strcmpi(type, 'pick')
        gripPos = doGripValue;  % Close
    else
        error('Unknown grip type: %s. Use ''pick'' or ''place''.', type);
    end

    %% Pack the goal
    grip_goal = packGripGoal_struct(gripPos, grip_goal, optns);

    %% Send grip goal
    disp('Sending grip goal...');
    try
        waitForServer(r.grip_action_client, 2);  % Wait up to 2 seconds
        disp('Connected to grip action server.');
        [res, state] = sendGoalAndWait(r.grip_action_client, grip_goal);
    catch ME
        warning('First attempt failed: %s', ME.message);
        try
            pause(0.5);  % Retry delay
            [res, state] = sendGoalAndWait(r.grip_action_client, grip_goal);
        catch
            error('Failed to connect or send grip goal on retry.');
        end
    end
end
