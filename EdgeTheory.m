function EdgeTheory
    % Initialize the GUI
    fig = figure('Name', 'Wave Calculator', 'NumberTitle', 'off', ...
                 'Position', [100, 100, 800, 600], 'Resize', 'off', ...
                 'CloseRequestFcn', @closeApp);
             
    % Input Panel UI
    uicontrol(fig, 'Style', 'text', 'Position', [20, 550, 200, 20], ...
              'String', 'Wave Period (sec)?');
    TInput = uicontrol(fig, 'Style', 'edit', 'Position', [20, 525, 200, 25], ...
                       'String', '3.0');
                   
    uicontrol(fig, 'Style', 'text', 'Position', [20, 500, 200, 20], ...
              'String', 'Mean Slope?');
    SlopeInput = uicontrol(fig, 'Style', 'edit', 'Position', [20, 475, 200, 25], ...
                           'String', '0.1');
                       
    uicontrol(fig, 'Style', 'text', 'Position', [20, 450, 200, 20], ...
              'String', 'Max Offshore Distance (m)?');
    XmaxInput = uicontrol(fig, 'Style', 'edit', 'Position', [20, 425, 200, 25], ...
                          'String', '5.0');
                      
    % Buttons
    uicontrol(fig, 'Style', 'pushbutton', 'Position', [20, 380, 100, 30], ...
              'String', 'Calculate', 'Callback', @calculateCallback);
    uicontrol(fig, 'Style', 'pushbutton', 'Position', [130, 380, 100, 30], ...
              'String', 'Stop', 'Callback', @stopCallback);

    % Axes for plotting
    ax = axes(fig, 'Position', [0.35, 0.2, 0.6, 0.7]);
    xlabel(ax, 'Offshore Distance (m)');
    ylabel(ax, 'Wave Height');
    title(ax, 'Wave Simulation');
    hold(ax, 'on');

    % Globals for wave animation
    stopFlag = false; % Use a persistent variable to manage the stop condition
    waveData = struct();
    
    % Nested function: Calculate button callback
    function calculateCallback(~, ~)
        % Get inputs
        T = str2double(get(TInput, 'String'));
        slope = str2double(get(SlopeInput, 'String'));
        xmax = str2double(get(XmaxInput, 'String'));
        
        % Validate inputs
        if isnan(T) || isnan(slope) || isnan(xmax)
            errordlg('Please enter valid numbers.', 'Input Error');
            return;
        end
        
        % Generate bathymetry profile
        bath = generateBathymetry(slope, xmax, 200);
        
        % Initialize wave data
        waveData = initializeWave(T, slope, bath, xmax);
        
        % Reset the stop flag and start animation
        stopFlag = false;
        animateWaves(ax, waveData, xmax);
    end

    % Nested function: Stop button callback
    function stopCallback(~, ~)
        % Set the stop flag to true
        stopFlag = true;
    end

    % Nested function: Animate waves
    function animateWaves(ax, waveData, xmax)
        while ~stopFlag
            % Update wave data
            waveData.jstep = waveData.jstep + 1;
            sigma = 2 * pi / waveData.T;
            vect = cell(1, waveData.nModes);
            for n = 1:waveData.nModes
                vect{n} = waveData.ewave{n} .* cos(sigma * waveData.jstep * waveData.dt);
            end

            % Plot waves
            cla(ax);
            colors = ['r', 'b', 'g'];
            for n = 1:waveData.nModes
                plot(ax, linspace(0, xmax, waveData.bath.npts), vect{n}, ...
                     colors(n), 'LineWidth', 1.5);
            end

            % Add labels
            legend(ax, arrayfun(@(x) sprintf('Mode %d', x - 1), 1:waveData.nModes, ...
                                'UniformOutput', false), 'Location', 'northwest');

            % Pause for animation
            pause(0.05);
        end
    end

    % Nested function: Close the app
    function closeApp(~, ~)
        stopFlag = true; % Stop animation when the app is closed
        delete(fig);
    end
end

function bath = generateBathymetry(slope, xmax, npts)
    dx = xmax / (npts - 1);
    bath.h = slope * (0:dx:xmax);
    bath.npts = npts;
end

function waveData = initializeWave(T, slope, bath, xmax)
    g = 9.81; % Gravity
    nModes = 3; % Number of wave modes
    waveData.T = T;
    waveData.dt = T / 300;
    waveData.jstep = 0;
    waveData.lambda = zeros(1, nModes);
    waveData.ewave = cell(1, nModes);
    
    % Calculate decay factor and wave amplitudes
    for n = 0:nModes - 1
        waveData.lambda(n + 1) = (2 * pi / T)^2 / (g * (2 * n + 1) * slope);
        waveData.ewave{n + 1} = -exp(-waveData.lambda(n + 1) * bath.h);
    end
    
    waveData.bath = bath;
    waveData.nModes = nModes;
    waveData.xmax = xmax;
end
