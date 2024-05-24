% Run this after running 'main.m'

% This will plot the best fit lines from each fold in the same figure so we
% can see the variability of each predictive model

results = ans;   % store output from 'main.m' ('ans') as 'results' 
                 % (to ensure we don't accidentally overwrite 'ans')
clear ans

x = csvread('/Users/ajsimon/Documents/Data/HCP/all_behav.csv');

% find highest value for the sum of positive and negative predictive edges
highbnd = max(results.testsum);
lowbnd = min(results.testsum);

% loop through number of folds
for iter = 1:length(results.modelInt)
    for i = 0:highbnd
        if i == 0
            fitline(iter,i+1) = results.modelInt(iter,1);
        else
            fitline(iter,i+1) = results.modelInt(iter,1) + i*results.modelSlope(iter,1);
        end
    end
end

avgline = mean(fitline);
stdline = std(fitline);

f=figure;
e=shadedErrorBar(1:length(avgline),avgline,stdline)
e.mainLine.Color=[0.9 0.9 0.9]; e.patch.FaceColor=[0.75 0.75 0.75]; 
hold on;
a=plot(1:length(avgline),avgline,'LineWidth',3,'Color',[0.3 0.3 0.3]);

xlim([lowbnd highbnd])



%% Plot predicted vs actual fluid intelligence scores
x = load('/Users/ajsimon/Documents/Data/MINDS_lab/PTSD/CPM_data/PCA_T3_minus_T1_Surveys.mat');
x=x.SCORE(:,1);

figure;
x = x.y;
for i = length(x):-1:1
    if isnan(x(i))
        x(i) = [];
    end
end


sc = scatter(y,T1_arousal.Y,'b','filled');
% xlim([0 60])
% ylim([0 35])
xlabel('Actual T1 CAPS5 avoidance score','FontSize',20)
ylabel('Predicted T1 CAPS5 avoidance score','FontSize',20)
%title('Tel Aviv','FontSize',20)
hold on

% add in fit line
actvpred = polyfit(y, T1_arousal.Y, 1);

% loop through number of possible fluid intelligence scores (x axis)
ix=0;
for i = floor(min(y)):ceil(max(y)) 
    ix=ix+1;
    if i == 0
        %fline(1,i+1) = actvpred(2);
        fline(1,ix) = actvpred(2);
    else
        %fline(1,i+1) = actvpred(2) + (i*actvpred(1));
        fline(1,ix) = actvpred(2) + (i*actvpred(1));
    end
end

fl = plot(floor(min(y)):ceil(max(y)),fline,'k');

% % added shaded errors around fit line (using se)
% se(1) = 0;
% for i = 1:ceil(max(x))
%     

% add coefficient and p-value to plot
str = {['Rho = ', num2str(results.r_rank)]}; %,['p-value = ', num2str(results.p_rank)]};
annotation('textbox', [0.2 0.5 0.3 0.3], 'String', str,'FitBoxToText','on','FontSize',14);



% This section is some sample code for making shaded error bars around fit
% line
% 
% xx = 0:0.2:10;                     
% yy = besselj(0, xx);
% 
% xconf = [xx xx(end:-1:1)] ;         
% yconf = [yy+0.15 yy(end:-1:1)-0.15];
% 
% figure
% p = fill(xconf,yconf,'red');
% p.FaceColor = [1 0.8 0.8];      
% p.EdgeColor = 'none';           
% 
% hold on
% plot(xx,yy,'ro')
% hold off
