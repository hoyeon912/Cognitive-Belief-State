function [h] = plot_belief(results)
    h = figure;
    [idx, label] = make_windows(results);
    colors = jet(numel(idx));

    ax1 = subplot(3, 1, 1);
    hold on
    for i = 2:numel(idx)
        plot( ...
            1:15, results.b(idx(i), :), ...
            'Color', colors(i, :), ...
            'DisplayName', label(i) ...
            );
    end
    hold off
    title("Belief state b0");
    xticks(1:15);
    xticklabels(label(2:end));
    legend("Location", "bestoutside");

    ax2 = subplot(3, 1, 2);
    hold on
    for i = 2:numel(idx)
        plot( ...
            1:15, results.bT(idx(i), :), ...
            'Color', colors(i, :), ...
            'DisplayName', label(i) ...
            );
    end
    hold off
    title("Belief state bT");
    ylabel("Belief (a.u.)");
    xticks(1:15);
    xticklabels(label(2:end));

    ax3 = subplot(3, 1, 3);
    hold on
    for i = 1:numel(idx)-1
        plot( ...
            1:15, results.b(idx(i)+1, :), ...
            'Color', colors(i, :), ...
            'DisplayName', label(i) ...
            );
    end
    hold off
    title("Belief state bT.*O");

    linkaxes([ax1, ax2, ax3], 'xy');
    xlim([1, 15]);
    xticks(1:15);
    xticklabels(label(2:end));
end
