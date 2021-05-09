function displayFunctions(display,robot,dim,cellAssembly)

    % Show what the Laplace transform looks like over time.
    if (display.SHOWBASIS)
        figure;
        for i = 1:9  
            plot(display.indAxis,robot.(cellAssembly).laplaceRep.(dim)(i,:),'LineWidth',2); hold on;
        end
        title({'Laplace Transform, F(s),','9 Slowest Time Constants'},'FontSize',14)
        xlabel('Distance from Maze Boundary (m)','FontSize',14)
        ylabel('Firing Rate','FontSize',14)
    end

    if (display.SHOWESTIMATE)
        figure;
        plot(display.estIndAxis,display.f_tilde,'x-');
        %legend('f\_tilde','f\_tilde\_tran','FontSize',14,'Location','NorthWest');
        title({'Inverse Laplace Transform','Remembered Signal'},'FontSize',14)
        xlabel('Distance from Maze Boundary (m)','FontSize',14)
    end

    if (display.SHOWPATH)
        figure; hold on;
        plot(display.telem.truth(:,1),display.telem.truth(:,2),'kx-','LineWidth',4); 
        plot(display.telem.robot(:,1),display.telem.robot(:,2),'bo-','LineWidth',2)
        legend('Landmark Truth','Robot Estimates','FontSize',14,'Location','NorthWest');
        title({'Robot Navigation Path Versus the True Landmark Locations'},'FontSize',14)
        axis([-1 3 -1 3]);
        xlabel('Meters','FontSize',14)
        ylabel('Meters','FontSize',14)
    end
    
end

