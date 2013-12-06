function output=som(input)
%%
% This Self-Organizing Maps (SOM) toolbox is a collection of 5 different
% algorithms all derived from the original Kohonen network. The 5
% algorithms are:
%
%   ONLINE      - the online SOM (see ref. [1])
%   BATCH       - the batch version of SOM
%   FUZZYBATCH  - this is the fuzzy batch SOM, where there is no Best
%                 Matching Unit (BMU) instead every neuron is a winner with 
%                 some degree. This degree is a fuzzy value where 1 indicates 
%                 winner take-all and 0 is not a winner.
%   RELATIONAL  - use relational SOM with relational data. When you do not
%                 have the feature vectors instead you have the dissimilatities 
%                 among objects in a relational data matrix D (see ref. [2])
%   RELATIONALFUZZY - a combination of the RELATIONAL SOM and FUZZY BATCH SOM
%
% Usage: output = som(input) where input is a structure with the following fields
%
% data           - either the feature vector data organized in a n x d matrix or a
%                  dissimilarity data in matrix n x n
% alg            - which algorithm to use, which of course depends on the type of
%                  data you provided. The alg can take any of the 5 different algorithms
%                  mentioned above
% maxIter        - maximum number of iterations SOM will run before it terminates
% radius         - array of two elements indicating the start and end of the SOM
%                  neighborhood radius
% fuzzifier      - array of two elements indicating the start and end values of
%                  the fuzzifier
% weightInitType - indicates the type of weight/codebook initialization
%                   1 = random initialization
%                   2 = randomly select c rows from the data to initialize the
%                  codebooks, where c is the number of neurons
%
% [1] T. Kohonen, “The self-organizing map,” Neurocomputing, 1998.
% [2] Hasenfuss, A. & Hammer, B. Relational topographic maps. Advances in Intelligent Data
%    Analysis VII (2007). at <http://www.springerlink.com/index/D0664R20V2L83MX5.pdf>

    %% Initializations  
    munits = prod(input.mapdim);
    
    % Initialize codebook/weights
    codebook = init_codebooks(input.data,input.mapdim,input.weightsInitFun);
    coords = node_coords(input.mapdim);
    nodeDist = coord_dist(munits,coords);
    qe = zeros(1,input.maxIter);
    te = qe;
    cost = qe;
    
    %% Iterate
    for iter=1:input.maxIter      
        [codebook u bmu hu h m Dx cost(iter)] = som_step(input, codebook, iter, nodeDist);
        fprintf('Iteration %d, obj fun = %f\n',iter, cost(iter));    
    end

    D = node_pairwise_dist(input.alg,codebook,input.data);
    [umatrix uheight] = som_umatrix(input.mapdim,D);
    
    %% Generate output structure
    output = struct('config',input,...
                    'codebook',codebook,...
                    'codebookDist',D,...
                    'vis',struct('umatrix',umatrix,'uheight',uheight),...
                    'u',u,...
                    'bmu',bmu,...
                    'hu',hu,...
                    'h',h,...
                    'Dx',Dx,...
                    'fuzzifier',m,...
                    'cost',cost,...
                    'date',datestr(now, 'mmmm dd, yyyy HH:MM AM'));
end
