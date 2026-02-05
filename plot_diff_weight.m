function [h] = plot_diff_weight(results)
    h = figure;
    r_last = find(results.r == 1, 1, 'last');

    ax1 = subplot(3, 1, 1);
    bar( ...
        results.w(r_last-1, :), ...
        'DisplayName', 'w0' ...
        );
    title("w(r_{last}-1)");
   
    ax2 = subplot(3, 1, 2);
    bar( ...
        results.w(r_last, :), ...
        'DisplayName', 'w1' ...
        );
    title("w(r_{last})");
    ylabel("Weight (a.u.)");

    ax3 = subplot(3, 1, 3);
    bar( ...
        results.w(r_last, :)-results.w(r_last-1,:), ...
        'DisplayNAme', 'diff' ...
        );
    title("\delta_{w}(r_{last})");

    linkaxes([ax1, ax2, ax3], 'x');
    xlim([0.5 15.5]);
    xlabel("State (i)");
end
