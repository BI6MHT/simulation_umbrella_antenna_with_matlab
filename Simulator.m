% 设计最初的天线
hx = helix('Radius',33e-3,'Width',3e-3,'Turns',3,'Spacing',53e-3)
fc =1.42e9;
minFreq = fc*0.8;
maxFreq = fc*1.2;
freqRange = linspace(minFreq,maxFreq,35);
% Radiation pattern
figure;
pattern(hx,fc)
% S11 curve
figure;
rfplot(sparameters(hx,freqRange))
figure;
show(hx)


% 自动优化参数
% Design Varibles
% Property Names
propNames = {'Radius','Spacing'};
bounds = {0.03,0.05;0.05,0.073};
figure;
optAnt = optimize(hx,fc,'maximizeBandwidth', ...
propNames,bounds, ...
'Constraints',{'Gain > 10'}, ...
'FrequencyRange',freqRange,...
'UseParallel',true);

% 结合反射面进行仿真
rs = reflectorSpherical('Radius',0.525,'Depth',0.15,'FeedOffset',[0 0 0.45],'Exciter',optAnt);
rs.Exciter.Tilt = 180;
rfplot(sparameters(rs,freqRange))
pattern(rs,fc)