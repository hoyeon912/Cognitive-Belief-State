function [h] = plot_value(results)
    h = figure;
    [idx, label] = make_windows(results);

    v = nan([3, numel(idx)]);
    for i = 1:numel(idx)
        v(1, i) = results.w(idx(i), :) * results.b(idx(i), :)';
        v(2, i) = results.w(idx(i), :) * results.bT(idx(i), :)';
        v(3, i) = results.w(idx(i), :) * results.b(idx(i)+1, :)';
    end

    ax1 = subplot(3, 1, 1);
    plot(1:16, v);
    ylabel("Value (a.u.)");
    legend( ...
        ["Before transition", "After transition", "After observation"], ...
        "Location", "bestoutside" ...
        );
    title("wb");
    xticks(1:16);
    xticklabels(label);

    ax2 = subplot(3, 1, 2);
    hold on
    plot(v(2, :) - v(1, :));
    plot(v(3, :) - v(2, :));
    plot(v(3, :) - v(1, :));
    hold off
    ylabel("Value (a.u.)");
    legend( ...
        ["Diff transition", "Diff observation", "Diff process"], ...
        "Location", "bestoutside" ...
        );
    title("\delta_{wb}");
    xticks(1:16);
    xticklabels(label);

    ax3 = subplot(3, 1, 3);
    plot(results.rpe(idx));
    ylabel("RPE (a.u.)");
    title("RPE");
    linkaxes([ax1, ax2, ax3], 'x');
    xlim([1, 16]);
    xticks(1:16);
    xticklabels(label);
end
