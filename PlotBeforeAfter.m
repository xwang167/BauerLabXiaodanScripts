
close all;clearvars;clc
import mouse.*
excelFile = "C:\Users\xiaodanwang\Documents\GitHub\BauerLabXiaodanScripts\DataBase_Xiaodan.xlsx";

runs = 1:6;
excelRows = 304:311;
saveDir_cat1 = 'K:\OptoRGECO\Cat';
miceName1 = 'ChR2-RGECO';
load(fullfile('K:\BleedOver\Cat','ROI.mat'),'ROI')
photoSwitchVis(excelFile,excelRows,runs,miceName1,saveDir_cat1,128,128,ROI)
% bleedOverVis_v2(excelFile,excelRows,runs,miceName1,saveDir_cat1,128,128,2,ROI)
% bleedOverVis_v2(excelFile,excelRows,runs,miceName1,saveDir_cat1,128,128,1,ROI)


excelRows = 297:303;
saveDir_cat2 = 'K:\BleedOver\Cat';
miceName2 = 'Thy1-RGECO';
load(fullfile('K:\BleedOver\Cat','ROI.mat'),'ROI')
photoSwitchVis(excelFile,excelRows,runs,miceName2,saveDir_cat2,128,128,ROI)
% bleedOverVis_v2(excelFile,excelRows,runs,miceName2,saveDir_cat2,128,128,1,ROI)
% bleedOverVis_v2(excelFile,excelRows,runs,miceName2,saveDir_cat2,128,128,2,ROI)

