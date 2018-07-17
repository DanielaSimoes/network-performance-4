function [MaximumLoad, AverageDelay]  = EvaluateLoad(lambda)
    Matrizes;
    miu= R*1e9/(8*1000);
    T(:,3:4)= T(:,3:4)*1e6/(8*1000);
    gama= sum(sum(T(:,3:4)));
    d= L*1e3/2e8;
    nT= size(T,1);
    
    
    Load= lambda./miu;
    Load(isnan(Load))= 0;
    MaximumLoad = max(max(Load));
    
    % Kleinrock aproximation => network average delay
    AverageDelay = (lambda./(miu-lambda)+lambda.*d);
    AverageDelay(isnan(AverageDelay)) = 0;
    AverageDelay = sum(sum(AverageDelay))/gama;
    AverageDelay = AverageDelay*2; %ida e volta => descomentar para ver o resultado

end
