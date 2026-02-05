function results = core_td(x, s, O, T, alpha, gamma)
    
    % TD learning for partially observable MDP.
    % Author: Dr. Samuel J. Gershman
    %
    % USAGE: results = TD(x,O,T)
    %
    % INPUTS:
    %   x - stimulus timeseries (1 = nothing, 2 = stimulus, 3 = reward)
    %   O - [S x S x M] observation distribution: O(i,j,m) = P(x'=m|s=i,s'=j)
    %   T - [S x S] transition distribution: T(i,j) = P(s'=j|s=i)
    %   alpha - value learning rate
    %   gamma - discount factor
    %
    % OUTPUTS:
    %   results - structure with the following fields:
    %               .w0 - weight vector at each time point (prior to updating)
    %               .b0 - belief state at each time point (prior to updating)
    %               .b0T - belief state before observation at each time point
    %               .b
    %               .rpe - TD error (after updating)
    %
    %%
    % initialization
    S = size(T,1);      % number of states
    b = ones(S,1)/S;    % belief state
    w = zeros(S,1);     % weights
    
    %%
    for t = 1:length(x)
        b0 = b; % old posterior, used later
        b0T = b'*T;
        if sum(b0T) ~= 0
            b0T = b0T ./ sum(b0T);
        end
        b = (b'*T).*O(s(t), :, x(t));
        b=b';
        if sum(b) ~= 0
            b = b./sum(b);
        end

        % TD update
        w0 = w;
        r = double(x(t)==3);        % reward
        rpe = r + w'*(gamma(t)*b-b0);  % TD error
        w = w + alpha(t)*rpe*b0;         % weight update
        
        % store results
        results.w(t,:) = w0;
        results.b(t,:) = b0;
        results.bT(t,:) = b0T;
        results.bTO(t, :) = b;
        results.r(t,1) = r;
        results.rpe(t,1) = rpe;
        results.alpha(t,1) = alpha(t);
        results.T = T;
        results.O = O;
        results.gamma(t,1) = gamma(t);
        results.x = x;
        results.s = s;

        fprintf('\r[%d/%d] Simulating...', t, length(x));
    end
    fprintf('\n');
