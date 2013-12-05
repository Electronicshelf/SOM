dataset = somDatasetStruct({'ws3g'});

input.name              = dataset.name;
input.datatype          = 'relational';
input.data              = dataset.RelationalData;
input.mode              = 'frbsom';
input.maxIter           = 10;
input.mapdim            = dataset.mapsize;
input.radius            = [2 0.5];
input.fuzzifier         = [1.01 2];
input.weightsInitFun    = 'random';
        
smap = som(input);
[qe te] = quality(smap.u, smap.Dx, input.mapdim, 2);
[tef ~] = fuzzyTopographicError(input.mapdim, smap.u);
cost = smap.cost(end);
        
figure;
summarization(smap, smap.config, dataset);