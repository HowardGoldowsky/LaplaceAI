function displayFunctions(display,robot,dim,cellAssembly)

    % Show what the Laplace transform looks like over time.
    if (display.SHOWBASIS)
        figure(4);
        for i = 1:9  
            plot(display.indAxis,robot.(cellAssembly).laplaceRep.(dim)(i,:),'LineWidth',2); hold on;
        end
        title({'Laplace Transform, F(s),','9 Slowest Time Constants'},'FontSize',14)
        xlabel('Distance from Landmark (m)','FontSize',14)
        ylabel('Firing Rate','FontSize',14)
    end

    if (display.SHOWESTIMATE)
        figure(3);
        plot(display.estIndAxis,display.f_tilde,'x-');
        %legend('f\_tilde','f\_tilde\_tran','FontSize',14,'Location','NorthWest');
        title({'Inverse Laplace Transform','Remembered Signal'},'FontSize',14)
        xlabel('Distance from Maze Boundary (m)','FontSize',14)
    end

    if (display.SHOWPATH)
        figure(1); hold on;        
        plot(display.telem.truth(:,1),display.telem.truth(:,2),'ko-','LineWidth',4); 
        plot(display.telem.robot(:,1),display.telem.robot(:,2),'.-','LineWidth',1,'MarkerSize',12)      
        text(max(display.telem.robot(:,1)),max(display.telem.robot(:,2)),num2str(robot.currentPos.k),'FontSize',12)
        
        legend('Landmark Truth','Robot Estimates','FontSize',14,'Location','NorthWest');
        title({'Robot Navigation Path Versus True Landmark Locations','for Different Values of k'},'FontSize',14)
        axis([-.1 2.1 -.1 1.6]);
        xlabel('Meters','FontSize',14,'FontWeight','bold')
        ylabel('Meters','FontSize',14,'FontWeight','bold')
        
        if (robot.currentPos.k==26)
            figure(2); hold on
            plot(2:2:26,display.telem.MSE,'rx-','LineWidth',2);
            xlabel('k','FontSize',14,'FontWeight','bold')
            ylabel('Mean Square Error at Via Point','FontSize',14,'FontWeight','bold')     
            title({'Mean Square Error at Via Point, Versus k','100 Verses 500 Cells Entorhinal Cortex'},'FontSize',14,'FontWeight','bold');
            legend('100 Cells EC','500 Cells EC','FontSize',14,'Location','NorthWest');
        end
        
        
    end
    
end

