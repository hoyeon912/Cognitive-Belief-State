function sim_lineartrack(n_trials, n_states, o_sigma, t_sigma)
    close all
    
    % LINEARTRACK
    %       n_trials - the number of total trials.
    %       n_states - the number of states (one for ITI, the others for ISI).

    % Dopamine RPEs Reflect Hidden State Inference Across Time:
    % Task 1 Model (100% Rewarded)
    % POMDP in the spirit of Daw et al. (2006), Rao (2010)
    % Authors: Clara Kwon Starkweather, Dr. Samuel J. Gershman
    
    
    %initialize
    x=[]; %series of observations during trials - will be filled in later
    s=[]; %series of state during trials - will be filled in later
    
    % Set hazard rate of transitioning OUT of the ITI
    % 1/65 is based on task parameters
    ITIhazard=(1/65);

    
    % Generate sequence of observations that corresponds to trials
    % Observations:
    for i=1:n_trials
        ITI = ones(1,geornd(ITIhazard));
        x=[x;2;ones([n_states-2, 1]);3;ITI'];
        s=[s;15;(1:(n_states-1))';n_states*ones(size(ITI))'];
        ITIdistributionMatrix(i)=length(ITI);
        fprintf('\r[%d/%d] Make trial list.', i, n_trials);
    end
    fprintf('\n');
    
    % states:
    % ISI = 1-14
    % ITI = 15
    
    %Fill out the observation matrix O
    % O(x,y,:) = [a b c]
    % a is the probability that observation 1 (null) was observed given that a
    % transition from sub-state x-->y just occurred
    % b is the probability that observation 2 (odor ON) was observed given that
    % a transition from sub-state x-->y just occurred
    % c is the probability that observation 2 (reward) was observed given that
    % a transition from sub-state x-->y just occurred
    
    O=zeros(n_states, n_states, 3);
    if numel(o_sigma) == 1
        o_sigma = repmat(o_sigma, n_states-2, 1);
    end
    %ISI
    for i = 1:n_states-2
        O(i, 1:(n_states-1), 1) = normpdf(i+1, 1:(n_states-1), o_sigma(i));
    end
    O(O < 0) = 0;
    
    %obtaining reward
    O(n_states-1, n_states, 3) = 1;
        
    %stimulus onset
    O(n_states, 1, 2) = 1;
        
    %ITI
    O(n_states, n_states, 1) = 1;
        
        
    %Fill out the transition matrix T
    %T(x,y) is the probability of transitioning from sub-state x-->y
    T=zeros(n_states, n_states);
    
    %odor ON from substates 1-6
    %no probability of transitioning out of ISI while odor ON
    % T(1,2)=1;
    % T(2,3)=1;
    % T(3,4)=1;
    % T(4,5)=1;
    % T(5,6)=1;
    
    % after state 5, each state has gaussian distribution transition probability
    % TODO: add reduced std variance by state (V)
    % TODO: cut right tail
    if numel(t_sigma) == 1
        t_sigma = repmat(t_sigma, n_states-2, 1);
    end
    for i = 1:n_states-3
        % T(i, 1:i+2) = normpdf(1:i+2, i+1, 1);
        T(i, 1:(i+2)) = normpdf(1:(i+2), i+1, t_sigma(i));
    end
    T(n_states-2, 1:(n_states-1)) = normpdf(1:(n_states-1), n_states-1, t_sigma(i+1));
    % for i = 1:12
    %     T(i, 1:i+2) = 1;
    % end
    % T(13, 1:14) = 1;
    
    % remain probability is linked to reward
    % remained = 1-sum(T, 2);
    % for i = 1:13
    %     T(i, i+1) = T(i, i+1) + remained(i);
    % end
    
    % normalize pdf
    for i = 1:(n_states-2)
        T(i, :) = T(i, :) / sum(T(i, :));
    end
    
    % State 14 is always linked to state 15 because of reward
    T(n_states-1, n_states) = 1;
    
    % ITI length is drawn from exponential distribution in task
    % this is captured with single ITI substate with high self-transition
    % probability
    T(n_states, n_states)=(1-ITIhazard);
    T(n_states, 1)=ITIhazard;
    
    %% Visualize the transition and observation matrices
    %Code for Supplementary Figure 7
    figure;
    subplot(2,1,1)
    imagesc(T)
    colorbar
    title('Transition Matrix')
    xlabel('Next Substate')
    ylabel('Current Substate')
    
    subplot(2,1,2)
    
    imagesc(O)
    colorbar
    title('Observation Matrix')
    xlabel('Next Substate')
    ylabel('Current Substate')
    %% Run TD learning
    
    gamma = 0.98 * ones(size(x));
    alpha = 0.1 * ones(size(x));
    results = core_td(x, s, O, T, alpha, gamma);
    
    dest = join([".", "results", string(datetime)], filesep);
    if ~exist(dest, "dir")
        mkdir(dest);
    end
    saveas(gcf, join([dest, "environments"], filesep), "png");

    save(join([dest, 'results'], filesep), 'results')
end
