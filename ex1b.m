Matrizes;
miu= R*1e9/(8*1000);
NumberLinks= sum(sum(R>0));
T(:,3:4)= T(:,3:4)*1e6/(8*1000);
gama= sum(sum(T(:,3:4)));
d= L*1e3/2e8;
nT= size(T,1);
lambda= zeros(20);
routes= zeros(nT,20);

for i=1:nT
    origin= T(i,1);
    destination= T(i,2);
    lambda_od= T(i,3);
    lambda_do= T(i,4);
    r= ShortestPathSym(d,origin,destination); 
    routes(i,:)= r;
    j= 1;
    while r(j)~= destination
        lambda(r(j),r(j+1))= lambda(r(j),r(j+1)) + lambda_od; 
        lambda(r(j+1),r(j))= lambda(r(j+1),r(j)) + lambda_do; 
        j= j+1;
    end
end
Load= lambda./miu;
Load(isnan(Load))= 0;
MaximumLoad = max(max(Load)); 
AverageLoad = sum(sum(Load))/NumberLinks;

RTDelay = (lambda./(miu-lambda)+lambda.*d);
RTDelay(isnan(RTDelay)) = 0;
RTDelay = sum(sum(RTDelay))/gama;
RTDelay = RTDelay*2

delayFlows = zeros(nT,1);

for i=1:nT
    origin= T(i,1);
    destination= T(i,2);
    r = routes(i,:);
    j=1;
    while r(j)~= destination
        delayFlows(i) = delayFlows(i) + (1/(miu(r(j),r(j+1))-lambda(r(j),r(j+1))) + d(r(j),r(j+1)));
        delayFlows(i) = delayFlows(i) + (1/(miu(r(j+1),r(j))-lambda(r(j+1), r(j))) + d(r(j+1), r(j)));
        j= j+1;
    end
end

delayFlows = sortrows(delayFlows, -1);
maxDelay = delayFlows(1)