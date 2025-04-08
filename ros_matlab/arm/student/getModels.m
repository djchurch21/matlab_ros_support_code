function models = getModels(optns)
%--------------------------------------------------------------------------
% getModels
% This method creates a client that communicates with Gazebo's
% get_world_properties service to retrieve all models in the world.
%
% Inputs: (struct) optns
% Output: (cell array) models - names of all models in the world
%--------------------------------------------------------------------------
    % 01 Get robot handle
    if isfield(optns, 'robot')
        robot = optns.robot;
    else
        error('Robot handle not found in optns.');
    end

    % 02 Create service client correctly
    % We need to use a valid ROS node (robot in this case) to create the client
    modelClient = rossvcclient('/gazebo/get_world_properties');
    
    % Create a message for the service request
    modelReq = rosmessage(modelClient);

    % 03 Call client
    try
        % Call the service with the request message and a timeout
        response = call(modelClient, modelReq, 'Timeout', 3);
        
        % Extract the model names from the response
        models = response.ModelNames;  % This is a cell array of model names
        disp(['Found ' num2str(length(models)) ' models in the world.']);
    catch ME
        % Catch any error during the service call
        warning('Failed to get models: %s', ME.message);
        models = {};  % Return an empty cell array if there's an error
    end
end


