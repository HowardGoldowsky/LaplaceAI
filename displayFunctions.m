function displayFunctions(display,robot,dim)

    % Show what the Laplace transform looks like over time.
    if (display.SHOWBASIS)
        figure;
        for i = 1:9  
            plot(display.indAxis,robot.currentPos.laplaceRep.(dim)(i,:),'LineWidth',2); hold on;
        end
        title({'Laplace Transform, F(s),','9 Slowest Time Constants'},'FontSize',14)
        xlabel('Time (s)','FontSize',14)
        ylabel('Firing Rate','FontSize',14)
    end

    if (display.SHOWESTIMATE)
        figure;
        plot(display.estIndAxis,display.f_tilde,'x-');hold on;plot(display.estIndAxis,display.f_tilde_tran,'x-')
        legend('f\_tilde','f\_tilde\_tran','FontSize',14,'Location','NorthWest');
        title({'Inverse Laplace Transform','Remembered Signal'},'FontSize',14)
        xlabel('Past Time','FontSize',14)
    end

end

