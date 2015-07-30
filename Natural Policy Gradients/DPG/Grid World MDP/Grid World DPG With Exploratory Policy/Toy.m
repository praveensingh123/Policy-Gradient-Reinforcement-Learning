classdef Toy < MDP & DistanceMeasure
    
    properties(SetAccess = private)
        
    end
    
    methods(Access = public)
        
        function obj = Toy(noise, gamma, H, actionDiscCount)
            
             actionDiscCount = 9;
             H=20;  %H = 50;
             noise =  0.02;
             gamma = 0.99;
            start_state_noise = 0.1 ;
            state_dim = 1;
            action_dim = 1;
            max_action = 1;
            %for discretizing
            min_disc_act = -1;
            max_disc_act = 1;
            
            %for sampling
            max_state = 4;
            min_state = -4;
            name = 'Toy';
            
            actionDiscCount = 10;
            obj = obj@MDP(gamma, H, noise, start_state_noise, state_dim, action_dim, max_action,...
                min_disc_act, max_disc_act, max_state, min_state, actionDiscCount, name);
            obj.discAct = 0; %continuous
            obj.all_actions = obj.discretizeActions();
        end
        

        function [distsqr] = sqDistance(obj, X, Z)
            %returns the distance matrix between 2 sets of states
            %X and Z
            distsqr = slmetric_pw(X',Z','sqdist');  %matrix of distances between the states
        end
        
        
        function [distsqr] = stateActionSqDistance(obj, X, Z)
            
        end
        
        
        function [pd] = density(obj, state, action, successor)

            new_state = obj.detTransit(state,action);
            pd = mvnpdf(successor, new_state, obj.noise);
        end
        
        function [rwd] = reward(obj, state, action)
            
            %%%%%%%when only goal state (with no other reward blobs)
            dist = abs(state - 3);
            rwd = exp(-(dist));
            
            
            %%%%%%%%returns the reward at a given srtate and action      
           %%%% alpha = 0.4 + (0.8-0.4).*rand(1,1);
% % % %             beta = 0.3 + (0.8-0.3).*rand(1,1);
% % % % 
% % % %             dist1 = abs(state - randi([0,3]));
% % % %             rwd1 = alpha .* exp(-(dist1));
% % % %             
% % % %             dist2 = abs(state - randi([-4,3]));
% % % %             rwd2 = beta .*exp(-(dist2));
% % % %                       
% % % %             dist = abs(state-3);
% % % %             goal_reward = exp(-(dist));
% % % %             
% % % % 
% % % %             
% % % %             %adding multiple local reward blob - reward less than reward
% % % %             %from goal state
% % % %               rwd = rwd1 + rwd2 +  goal_reward;

         end
        
        function [start_state, start_state_action] = getStartState(obj)

            start_state = obj.start_state_noise*randn(1);
            start_state_action = [start_state 0];
        end
        
        
        function [state] = uniform_state(obj)
            state = unifrnd(obj.min_state, obj.max_state);
        end
        
        function [state] = reward_state(obj)
            state = 3 + unifrnd(-0.1,0.1);
        end
        
        function [new_state] = transit(obj, state, action)

            [new_state] = obj.detTransit(state, action) + obj.noise*randn(1);
            %[new_state] = obj.detTransit(state, action);
        end
        

        
    end
        
    
    methods(Access = private)
        function [new_state] = detTransit(obj, state, action)
            %DETERMINISTIC TRANSITION
            action(action > 1) = obj.max_action;
            action(action < -1) = -obj.max_action;
            new_state = state + action;
            
            if new_state > 4
                new_state = 0;
            end

        end
        
        
    end
end