function plot_difference(fig_name, r_last, n_state, minuend, subtrahend)
    figure('Name', fig_name);
    times = (-(n_state-1):0) + r_last;
    states = 1:(n_state+1);
    colors = jet(n_state+1);
    hold on
    for i = states(1:end-1)
        plot( ...
            minuend(times(i), states) - subtrahend(times(i), states), ...
            'Color', colors(i, :), ...
            'DisplayName', sprintf('State %d', i) ...
            );
    end
    xlabel('Sub state');
    ylabel('Belief (a.u.)');
    title(fig_name);
    xlim([1 n_state+1]);
    colormap(jet(n_state+1))
    legend('Location', 'bestoutside');
end
