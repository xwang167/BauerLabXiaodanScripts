stimMatrix =  cell(4,12,3,2,4);% seeds,runs,species,band,protocol
xform_isbrain_Aubrey = ones(128,128);

stimMatrix= getMapMatrix(stimMatrix,xform_isbrain_Aubrey,196:199,1);
stimMatrix= getMapMatrix(stimMatrix,xform_isbrain_Aubrey,206:209,2);
stimMatrix= getMapMatrix(stimMatrix,xform_isbrain_Aubrey,210:213,3);
stimMatrix= getMapMatrix(stimMatrix,xform_isbrain_Aubrey,214:217,4);


for ii = 1:4
    for jj = 1:12
        for kk = 1:3
            for ll = 1:2
                for mm = 1:4
                    map = stimMatrix{ii,jj,kk,ll,mm};
                    map(isnan(map)) = 0;
                    stimMatrix{ii,jj,kk,ll,mm} = map;
                    
                end
            end
        end
    end
end

    

xform_isbrain_total = xform_isbrain_total.*xform_isbrain_Aubrey;
xform_isbrain_total(isnan(xform_isbrain_total)) = 0;

stimArray= zeros(4,12,3,2,4);

    for jj = 1:12
        for kk = 1:4
         oxyMap = seedFCMapCat{1,1};
         totalMap = seedFCMapCat{1,3};
         fluorMap = seedFCMapCat{1,4};
        
             stimArray(1,jj,1,1,kk) = corr(reshape(stimMatrix{1,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(oxyMap(:,:,3).*xform_isbrain_total,[],1));        
             stimArray(2,jj,1,1,kk) = corr(reshape(stimMatrix{2,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(oxyMap(:,:,4).*xform_isbrain_total,[],1));         
             stimArray(3,jj,1,1,kk) = corr(reshape(stimMatrix{3,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(oxyMap(:,:,5).*xform_isbrain_total,[],1));        
             stimArray(4,jj,1,1,kk) = corr(reshape(stimMatrix{4,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(oxyMap(:,:,7).*xform_isbrain_total,[],1)); 
             
             stimArray(1,jj,2,1,kk) = corr(reshape(stimMatrix{1,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(totalMap(:,:,3).*xform_isbrain_total,[],1));        
             stimArray(2,jj,2,1,kk) = corr(reshape(stimMatrix{2,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(totalMap(:,:,4).*xform_isbrain_total,[],1));         
             stimArray(3,jj,2,1,kk) = corr(reshape(stimMatrix{3,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(totalMap(:,:,5).*xform_isbrain_total,[],1));        
             stimArray(4,jj,2,1,kk) = corr(reshape(stimMatrix{4,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(totalMap(:,:,7).*xform_isbrain_total,[],1)); 
             
                          
             stimArray(1,jj,3,1,kk) = corr(reshape(stimMatrix{1,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(fluorMap(:,:,3).*xform_isbrain_total,[],1));        
             stimArray(2,jj,3,1,kk) = corr(reshape(stimMatrix{2,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(fluorMap(:,:,4).*xform_isbrain_total,[],1));         
             stimArray(3,jj,3,1,kk) = corr(reshape(stimMatrix{3,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(fluorMap(:,:,5).*xform_isbrain_total,[],1));        
             stimArray(4,jj,3,1,kk) = corr(reshape(stimMatrix{4,jj,1,1,kk}.*xform_isbrain_total,[],1),reshape(fluorMap(:,:,7).*xform_isbrain_total,[],1));
  
                                
        end
    end


function stimMatrix= getMapMatrix(stimMatrix,xform_isbrain_Aubrey,excelRows,procNum)
ind = 1;
excelFile = "D:\GCaMP\GCaMP_awake.xlsx";
for excelRow = excelRows
     [~, ~, excelRaw]=xlsread(excelFile,1, ['A',num2str(excelRow),':T',num2str(excelRow)]);
     recDate = excelRaw{1};
     recDate = string(recDate);
     mouseName = excelRaw{2};
     procDir = excelRaw{4};
     namePre = fullfile(procDir,recDate,strcat(recDate,'-',mouseName,'-fc'));
     for runs = 1:3
         if runs ==1
             load(strcat(namePre,num2str(runs),'-dataHb.mat'),'xform_isbrain')
             xform_isbrain_Aubrey = xform_isbrain_Aubrey.*xform_isbrain;
         end
         load(strcat(namePre,num2str(runs),'-seedFC-0p009-0p08.mat'),'seedFCMap');
         oxyMap = seedFCMap{1,1};
         totalMap = seedFCMap{1,3};
         fluorMap = seedFCMap{1,4};
         stimMatrix{1,ind,1,1,procNum} = oxyMap(:,:,3);
         stimMatrix{2,ind,1,1,procNum} = oxyMap(:,:,4);
         stimMatrix{3,ind,1,1,procNum} = oxyMap(:,:,5);
         stimMatrix{4,ind,1,1,procNum} = oxyMap(:,:,7);
         
         stimMatrix{1,ind,2,1,procNum} = totalMap(:,:,3);
         stimMatrix{2,ind,2,1,procNum} = totalMap(:,:,4);
         stimMatrix{3,ind,2,1,procNum} = totalMap(:,:,5);
         stimMatrix{4,ind,2,1,procNum} = totalMap(:,:,7);
         
         stimMatrix{1,ind,3,1,procNum} = fluorMap(:,:,3);
         stimMatrix{2,ind,3,1,procNum} = fluorMap(:,:,4);
         stimMatrix{3,ind,3,1,procNum} = fluorMap(:,:,5);
         stimMatrix{4,ind,3,1,procNum} = fluorMap(:,:,7);
         
         
         
         load(strcat(namePre,num2str(runs),'-seedFC-0p4-4.mat'),'seedFCMap');
         
         oxyMap = seedFCMap{1,1};
         totalMap = seedFCMap{1,3};
         fluorMap = seedFCMap{1,4};
         
         stimMatrix{1,ind,1,2,procNum} = oxyMap(:,:,3);
         stimMatrix{2,ind,1,2,procNum} = oxyMap(:,:,4);
         stimMatrix{3,ind,1,2,procNum} = oxyMap(:,:,5);
         stimMatrix{4,ind,1,2,procNum} = oxyMap(:,:,7);
         
         stimMatrix{1,ind,2,2,procNum} = totalMap(:,:,3);
         stimMatrix{2,ind,2,2,procNum} = totalMap(:,:,4);
         stimMatrix{3,ind,2,2,procNum} = totalMap(:,:,5);
         stimMatrix{4,ind,2,2,procNum} = totalMap(:,:,7);
         
         stimMatrix{1,ind,3,2,procNum} = fluorMap(:,:,3);
         stimMatrix{2,ind,3,2,procNum} = fluorMap(:,:,4);
         stimMatrix{3,ind,3,2,procNum} = fluorMap(:,:,5);
         stimMatrix{4,ind,3,2,procNum} = fluorMap(:,:,7);
         ind = ind+1;
     end
end
end