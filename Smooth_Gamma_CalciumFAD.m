        T_CalciumFAD_2min_median_2 = T_CalciumFAD_2min_median;
        W_CalciumFAD_2min_median_2 = W_CalciumFAD_2min_median;
        A_CalciumFAD_2min_median_2 = A_CalciumFAD_2min_median;
        r_CalciumFAD_2min_median_2 = r_CalciumFAD_2min_median;
        r2_CalciumFAD_2min_median_2 = r2_CalciumFAD_2min_median;
        
        
        
        
        
            figure
            subplot(2,3,4)
            imagesc(r_CalciumFAD_2min_smooth_median-r_CalciumFAD_2min_median,'AlphaData',mask)
            cb=colorbar;
            caxis([-1 1])
            axis image off
            colormap jet
            title('r')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,5)
            imagesc(r2_CalciumFAD_2min_smooth_median-r2_CalciumFAD_2min_median,'AlphaData',mask)
            cb=colorbar;
            caxis([0 1])
            axis image off
            colormap jet
            title('R^2')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,1)
            imagesc(T_CalciumFAD_2min_smooth_median-T_CalciumFAD_2min_median,'AlphaData',mask)
            cb=colorbar;
            caxis([0 0.3])
            axis image off
            cmocean('ice')
            title('T(s)')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,2)
            imagesc(W_CalciumFAD_2min_smooth_median-W_CalciumFAD_2min_median,'AlphaData',mask)
            cb=colorbar;
            caxis([0 0.06])
            axis image off
            cmocean('ice')
            title('W(s)')
            set(gca,'FontSize',14,'FontWeight','Bold')
            
            subplot(2,3,3)
            imagesc(A_CalciumFAD_2min_smooth_median-A_CalciumFAD_2min_median,'AlphaData',mask)
             cb=colorbar;
            caxis([0 1.4])
            axis image off
            cmocean('ice')
            title('A')
            set(gca,'FontSize',14,'FontWeight','Bold')           
            sgtitle(strcat(recDate,'-',mouseName,'-',sessionType,num2str(n),'-CalciumFAD-GammaFit-2min'))