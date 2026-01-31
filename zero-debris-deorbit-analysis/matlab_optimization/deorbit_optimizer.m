% ZERO-DEBRIS DEORBIT ANALYSIS
% ESA 25-year compliance study

clear; clc;

%% Parameters
altitudes = [400, 500, 600, 700, 800];  % km
target_alt = 100;  % Reentry altitude
R_earth = 6378;
mu = 398600.4;

%% Constants for drag decay
Cd = 2.2;
A_m_ratio = 0.02;  % Area/mass ratio (m^2/kg)
rho_ref = 3.614e-13;  % kg/m^3 at 400km
H = 50;  % Scale height (km)

%% Initialize results
delta_v_results = zeros(length(altitudes), 1);
natural_decay_years = zeros(length(altitudes), 1);
compliant_25yr = false(length(altitudes), 1);

%% Analysis loop
for i = 1:length(altitudes)
    h0 = altitudes(i);
    
    % Delta-V calculation (Hohmann transfer)
    r_initial = R_earth + h0;
    v_circular = sqrt(mu / r_initial);
    r_perigee = R_earth + target_alt;
    a_transfer = (r_initial + r_perigee) / 2;
    v_transfer = sqrt(mu * (2/r_initial - 1/a_transfer));
    delta_v_results(i) = abs(v_circular - v_transfer) * 1000;  % m/s
    
    % Natural decay time estimate
    rho = rho_ref * exp(-(h0 - 400) / H);
    v = sqrt(mu / r_initial) * 1000;  % m/s
    decay_rate = -Cd * A_m_ratio * rho * v / 2;  % km/s
    time_to_decay = (h0 - 100) / abs(decay_rate * 86400 * 365);  % years
    natural_decay_years(i) = time_to_decay;
    
    % ESA 25-year compliance check
    compliant_25yr(i) = time_to_decay <= 25;
    
    fprintf('Altitude: %d km\n', h0);
    fprintf('  Delta-V: %.2f m/s\n', delta_v_results(i));
    fprintf('  Natural decay: %.1f years\n', time_to_decay);
    fprintf('  ESA compliant: %s\n\n', mat2str(compliant_25yr(i)));
end

%% Plot results
figure('Position', [100 100 1200 500]);

% Delta-V vs Altitude
subplot(1,2,1);
plot(altitudes, delta_v_results, 'o-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Initial Altitude (km)');
ylabel('Required Delta-V (m/s)');
title('Active Deorbit Delta-V Budget');
grid on;

% Natural Decay Time
subplot(1,2,2);
bar(altitudes, natural_decay_years);
hold on;
yline(25, 'r--', 'LineWidth', 2, 'Label', 'ESA 25-year limit');
xlabel('Altitude (km)');
ylabel('Natural Decay Time (years)');
title('ESA Zero-Debris Compliance');
grid on;

saveas(gcf, '../plots/matlab_analysis.png');

%% Save results to file
results_table = table(altitudes', delta_v_results, natural_decay_years, compliant_25yr, ...
    'VariableNames', {'Altitude_km', 'DeltaV_ms', 'DecayTime_years', 'ESA_Compliant'});
writetable(results_table, '../data/deorbit_analysis.csv');

fprintf('Analysis complete. Results saved.\n');