function displayFunctions(display,robot)

    % Show what the Laplace transform looks like over time.
    if (display.SHOWBASIS)
        figure;
        for i = 1:9  
            plot(display.x,robot.laplaceRep.x(i,:),'LineWidth',2); hold on;
        end
        title({'Laplace Transform, F(s),','9 Slowest Time Constants'},'FontSize',14)
        xlabel('Time (s)','FontSize',14)
        ylabel('Firing Rate','FontSize',14)
    end

    if (display.SHOWESTIMATE)
        figure;
        plot(display.x_star,display.f_tilde,'x-');hold on;plot(display.x_star,display.f_tilde_tran,'x-')
        legend('f\_tilde','f_tilde_tran','FontSize',14);
        title({'Inverse Laplace Transform','Remembered Signal'},'FontSize',14)
        xlabel('Past Time','FontSize',14)
    end

end

