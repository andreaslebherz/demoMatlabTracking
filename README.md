# demoMatlabTracking
Matlab demonstration of object tracking in sumilated scenarios. This repository is based on:  

https://de.mathworks.com/help/driving/ug/extended-object-tracking.html

It therefore requires the 'Automated Driving Toolbox' and the 'Sensor Fusion and Tracking Toolbox'. This demo was developed under MatLab version R2021a.

The sensor configuration consists of 5R1C and is implemented scenario independent. 

Scenario files should be placed in the /scenario folder. 

Output .csv (detections) and .gif (simulation) are generated in the /output folder.

In mainDemoGhosting.m:

    1. Set EVAL_POT and EVAL_JPDA flags
    2. Set EXPORT_CSV and PLOT_METRICS flags
    3. Set scenarioHandle to <scenario>.m
    4. Set filename to <scenario>.m (This has to match scenarioHandle)
    5. Set display.FollowActorID for .gif visualization
    6. Run
