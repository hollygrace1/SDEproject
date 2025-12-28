% Parameters

K = 0.5;               
sigma = 0.3;           
A = 1.85; 
B = 1.06;          
dt = 1;                
N = 1000;              
forecast_days = 7;     
t0 = 40;              
days = 1:forecast_days;
R0 = 0.4;   

R_next = zeros(N, forecast_days+1);
R_next(:,1) = R0;

dW = sqrt(dt) * randn(N, forecast_days);

seasonal_mean = A + B * sin(2*pi*(days + t0 - 30)/365);


% EM simulation

for t = 1:forecast_days
    beta_t = A + B * sin(2*pi*(days(t)+40)/365 + pi/2); 
    R_next(:,t+1) = R_next(:,t) + K*(beta_t - R_next(:,t))*dt + sigma*dW(:,t);
end


% Expected number of rainy days 

rainy_day_threshold = 2.5;
rainy_days_per_path = sum(R_next(:,2:end) > rainy_day_threshold,2);
expected_rainy_days = 1/1000 * sum(rainy_days_per_path);


% Plot figure 

figure;
h1 = plot(days, R_next(1:50,2:8)','LineWidth',0.6, 'Color', [0.2 0.5 0.8 0.8]);
hold on;
h3 = yline(rainy_day_threshold,'LineWidth',3, 'Color',[1 0 0], 'Alpha', 1) ;
h2 = plot(days, mean(R_next(:, 2:8),1),'k-','LineWidth',3, 'LineStyle', '-.');  

lgd = legend([h1(1) h2 h3],'Simulated Paths','Mean of simulated paths','Rainy day threshold','FontSize', 13, 'Interpreter', 'latex');
grid on;
ylim ([0 5]); 
xlabel('Date in December 2025','FontSize', 13,'Interpreter', 'latex');
ylabel('Predicted rainfall','FontSize', 13,'Interpreter', 'latex');
ax = gca;      
ax.FontSize = 13; 
ax.TickLabelInterpreter = 'latex';
xticklabels({'1st','2nd','3rd','4th','5th','6th','7th'});
hold off;
