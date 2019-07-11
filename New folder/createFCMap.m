function createFCMap(R_oxy_ISA,R_gcampCorr_ISA,R_oxy_Delta,R_gcampCorr_Delta,saveDir,visName)
            seednames={'Olf','Fr','Cg','M','SS','RS','V'};
            numseeds=numel(seednames);
            figure;
            for s=1:numseeds
                
                
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_ISA(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p1 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_ISA(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            colorbar
            set(p1,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
            
            for s=1:numseeds
                
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_ISA(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p2 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_ISA(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            
            colorbar
            set(p2,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))+0.35 0.08 0.08]);
            
            
            
            
            
            for s=1:numseeds
                
                
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_Delta(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p3 = subplot('position', [OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_oxy_Delta(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            colorbar
            set(p3,'Position',[OE+0.08 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
            
            for s=1:numseeds
                
                
                if mod(s,2)==0
                    OE=0.26;
                else
                    OE=0.1;
                end
                
                subplot('position', [OE+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+1)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_Delta(:,:,(2*(s-1)+1)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+1,1),refseeds(2*(s-1)+1,2),'ko');
                axis image off
                title([seednames{s},'R'],'FontSize',6)
                
                p4 = subplot('position', [OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
                %             Im2=overlaymouse(R_oxy(:,:,(2*(s-1)+2)),double(WL_atlas), xform_isbrain,'jet',-1,1);
                imagesc(R_gcampCorr_Delta(:,:,(2*(s-1)+2)),[-1 1]); %changed 3/1/11
                hold on;
                plot(refseeds(2*(s-1)+2,1),refseeds(2*(s-1)+2,2),'ko');
                axis image off
                title([seednames{s},'L'],'FontSize',6)
                hold off;
                
            end
            
            colorbar
            set(p4,'Position',[OE+0.08+0.5 (0.45-((round(s/2)-1)*0.1))-0.1 0.08 0.08]);
             
            
            annotation('textbox',[0.125 0.95 0.75 0.05],'HorizontalAlignment','center','LineStyle','none','String',strcat(visName,' Processed Data Visualization'),'FontWeight','bold');
            annotation('textbox',[0.15 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"Oxy",'FontWeight','bold','Color',[1 0 0]);
            annotation('textbox',[0.65 0.93 0.2 0.04],'HorizontalAlignment','center','LineStyle','none','String',"gcampCorr",'FontWeight','bold','Color',[0 1 0]);
            
            annotation('textbox',[0.01 0.6 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"ISA",'FontWeight','bold','Color',[1 0 0]);
            annotation('textbox',[0.01 0.1 0.04 0.2],'VerticalAlignment','middle','LineStyle','none','String',"Delta",'FontWeight','bold','Color',[0 1 0]);
            
            output= strcat(fullfile(saveDir,visName),'_FCMap.jpg');
            orient portrait
            print ('-djpeg', '-r300', output);
            
            figure('visible', 'on');
            close all