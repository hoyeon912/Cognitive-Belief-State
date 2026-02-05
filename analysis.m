function [] = analysis(fpath)
    close all;

    load(join([fpath, "results.mat"], filesep));   
    
    h1 = plot_diff_weight(results);   
    h2 = plot_belief(results);
    h3 = plot_value(results);

    hs = [h1, h2, h3];
    names = ["weight", "belief", "value"];
    for i = 1:numel(hs)
        saveas( ...
            hs(i), ...
            join([fpath, names(i)], filesep), ...
            "png" ...
            );
    end
end
