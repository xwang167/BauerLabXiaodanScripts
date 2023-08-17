function [h,p] = ttest2groups(group1, group2)
% Input
    % group1, group2: needs to be formatted in m1*m2...*n (n = number of mice)
    % group1_name, group2_name: String for the names of different groups
    
dimension = size(group1);
n = dimension(end); % number of mice
group1 = reshape(group1,[],n);
group2 = reshape(group2,[],n);

m = size(group1,1);

h = nan(1,m);
p = nan(1,m);

for ii = 1:m
    [h(ii),p(ii)] = ttest2(group1(ii,:),group2(ii,:),0.05,'both','unequal');
end

h = reshape(h,dimension(1:end-1));
p = reshape(p,dimension(1:end-1));