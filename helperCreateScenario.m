function [scenario, egoVehicle, sensors] = helperCreateScenario(scenarioHandle)

% Create the drivingScenario object and ego car
[~, scenario, ~, egoVehicle] = scenarioHandle();

% Create all the sensors
[sensors, ~] = createSensors(scenario);
end

function [sensors, numSensors] = createSensors(scenario)
    % createSensors Returns all sensor objects to generate detections
    numSensors = 6;
    sensors = cell(numSensors,1);
    egoCar.Wheelbase = 2.8;
    egoCar.FrontOverhang = 0.9;
    egoCar.Width = 1.8;
    
    Radar_UpdateRate = 25;
    Camera_UpdateInterval = 1 / Radar_UpdateRate;

    % Front-facing long-range radar sensor at the center of the front bumper of the car.
    sensors{1} = drivingRadarDataGenerator('SensorIndex', 1, ...
        'UpdateRate', Radar_UpdateRate, ...
        'RangeLimits',[0 200], ...
        'MountingLocation', [egoCar.Wheelbase + egoCar.FrontOverhang, 0 0.2],...
        'FieldOfView', [20, 5]...
        );

    % Configurations from SRR 308-21 Data sheet
    SR_RangeLimit = [1.2 80];
    SR_FoV = [150 12];
    SR_ReferenceRange = 50;
    SR_AzimuthResolution = 5;
    SR_RangeResolution = 1.00;

    % Rear-left-facing short-range radar sensor at the left rear wheel well of the car.
    sensors{2} = drivingRadarDataGenerator('SensorIndex', 2, ...
        'UpdateRate', Radar_UpdateRate, ...
        'RangeLimits',SR_RangeLimit,...
        'MountingLocation',[0, egoCar.Width/2 0.2],...
        'MountingAngles',[110 0 0],...
        'FieldOfView',SR_FoV,...
        'ReferenceRange',SR_ReferenceRange,...
        'AzimuthResolution',SR_AzimuthResolution,...
        'RangeResolution',SR_RangeResolution...
        );

    % Rear-right-facing short-range radar sensor at the right rear wheel well of the car.
    sensors{3} = drivingRadarDataGenerator('SensorIndex', 3, ...
        'UpdateRate', Radar_UpdateRate, ...
        'RangeLimits',SR_RangeLimit,...
        'MountingLocation',[0, -egoCar.Width/2 0.2],...
        'MountingAngles',[-110 0 0],...
        'FieldOfView',SR_FoV,...
        'ReferenceRange',SR_ReferenceRange,...
        'AzimuthResolution',SR_AzimuthResolution,...
        'RangeResolution',SR_RangeResolution...
        );

    % Front-left-facing short-range radar sensor at the left front wheel well of the car.
    sensors{4} = drivingRadarDataGenerator('SensorIndex', 4, ...
        'UpdateRate', Radar_UpdateRate, ...
        'RangeLimits',SR_RangeLimit,...
        'MountingLocation',[egoCar.Wheelbase, egoCar.Width/2 0.2],...
        'MountingAngles',[70 0 0],...
        'FieldOfView',SR_FoV,...
        'ReferenceRange',SR_ReferenceRange,...
        'AzimuthResolution',SR_AzimuthResolution,...
        'RangeResolution',SR_RangeResolution...
        );

    % Front-right-facing short-range radar sensor at the right front wheel well of the car.
    sensors{5} = drivingRadarDataGenerator('SensorIndex', 5, ...
        'UpdateRate', Radar_UpdateRate, ...
        'RangeLimits',SR_RangeLimit,...
        'MountingLocation',[egoCar.Wheelbase, -egoCar.Width/2 0.2],...
        'MountingAngles',[-70 0 0],...
        'FieldOfView',SR_FoV,...
        'ReferenceRange',SR_ReferenceRange,...
        'AzimuthResolution',SR_AzimuthResolution,...
        'RangeResolution',SR_RangeResolution...
        );

    % Front-facing camera located at front windshield.
    sensors{6} = visionDetectionGenerator('SensorIndex', 6, 'FalsePositivesPerImage', 0.1, ...
        'UpdateInterval', Camera_UpdateInterval, ...
        'SensorLocation', [0.75*egoCar.Wheelbase 0], 'Height', 1.1,'DetectionProbability',1,...
        'MaxAllowedOcclusion',0.5);

    numRadar = sum(cellfun(@(s) isa(s, 'drivingRadarDataGenerator'), sensors, 'UniformOutput', true));
    for i = 1:numRadar
        sensors{i}.TargetReportFormat = 'Detections';
        sensors{i}.DetectionCoordinates = 'Sensor Spherical';
        sensors{i}.HasFalseAlarms = true;
        sensors{i}.FalseAlarmRate = 1e-5;
        sensors{i}.HasNoise = true;
        sensors{i}.HasRangeRate = true;
        sensors{i}.Profiles = actorProfiles(scenario);
        sensors{i}.HasOcclusion = true;
    end

    for i = numRadar+1:numSensors
        sensors{i}.DetectionCoordinates = 'Sensor Cartesian';
        sensors{i}.HasNoise = true;
        sensors{i}.FalsePositivesPerImage = 0.1;
        sensors{i}.ActorProfiles = actorProfiles(scenario);
    end
end


    