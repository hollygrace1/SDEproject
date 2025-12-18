
% Parameters

K = 0.5;    
sigma = 0.3;    
R0 = 0;       

A = 1.85;       
B = 1.06;        
beta = @(t) A + B * sin((2*pi*t)/365 + pi/2); 

T_total = 365 * 3;  
N_paths = 1000; 
a = 4;

N_steps = T_total * 100;
dt = T_total/N_steps;      
Dt = a * dt;
L = N_steps / a;

Time = 0:Dt:T_total;
R = zeros(N_paths, L + 1);
R(:, 1) = R0; 


% EM Scheme 

for j = 1:N_paths
    dW = sqrt(dt) * randn(1,N_steps);
    for i = 2:L+1
        Winc = sum(dW(a*(i-2)+1:a*(i-1)));
        t_now = Dt * (i-1);
        R(j,i) = R(j, i-1) + K * (beta(t_now) - R(j,i-1)) * Dt + sigma * Winc;
    end
end



% Figure 

colours = [0 0.4470 0.7410;   
           0.4940 0.1840 0.5560;   
           0.8500 0.3250 0.0980];  

figure;
hold on;
xlabel('$t$', 'FontSize', 14, 'Interpreter', 'latex');
ylabel('$R(t)$', 'FontSize', 14, 'Interpreter', 'latex');

N_plot = 3; 
for i = 1:N_plot
    plot(Time, R(i, :),'LineWidth', 0.8, "Color", colours(i,:));
end

plot(Time, beta(Time), 'k-', 'LineWidth', 2.2);
legend('Simulated path 1','Simulated path 2','Simulated path 3','$\beta(t)$', 'FontSize', 13, 'Interpreter', 'latex', 'Location', 'southwest');
xlim([0 1095]);
ylim([-2.5 5]);

ax = gca;      
ax.FontSize = 13; 
ax.TickLabelInterpreter = 'latex';
grid on;
hold off;



