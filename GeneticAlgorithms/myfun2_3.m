function [x,fval,exitflag,output,population,score] = myfun2_3(nvars,lb,ub)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = gaoptimset;
%% Modify options setting
options = gaoptimset(options,'CrossoverFcn', {  @crossoverintermediate [] });
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'PlotFcns', { @gaplotbestf });
[x,fval,exitflag,output,population,score] = ...
ga(@myfun2,nvars,[],[],[],[],lb,ub,[],[],options);
