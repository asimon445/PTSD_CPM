clear;

nperms = 1000; 
nfolds = 10;

% load connectomes
load('/Users/ajsimon/Documents/Data/MINDS_lab/PTSD/TelAviv/Averages/connectome.mat');

% load CAPS
load('/Users/ajsimon/Documents/Data/MINDS_lab/PTSD/TelAviv/Averages/T1_CAPS.mat')
x=avgconn; clear avgconn
y = T1_CAPS; clear T1_CAPS

for i = length(y):-1:1
    if isnan(y(i))
        y(i) = [];
        x(:,:,i) = [];
    end
end

% run CPM
for i = 1:nperms

    % T1 domino
    results = main(x,y,nfolds,'results');
    rho(i,1) = results.r_rank;

    % shuffle the y data and re-run CPM on random data
    test = randperm(numel(y));
    ShuffledData=reshape(y(test),size(y));

    results_rand = main(x,ShuffledData,nfolds,'results');

    rho_rand(i,1) = results_rand.r_rank;

    clear results ShuffledData test results_rand

end

clear x* y*

save('/Users/ajsimon/Documents/Data/MINDS_lab/PTSD/TelAviv/T1_prediction_results.mat');