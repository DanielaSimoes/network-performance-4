function [routes, lambda] = GreedyRandomized()
    Matrizes;
    miu= R*1e9/(8*1000);
    T(:,3:4)= T(:,3:4)*1e6/(8*1000);
    d= L*1e3/2e8;
    nT= size(T,1);
    lambda= zeros(20);
    routes= zeros(nT,20);

    for i=randperm(nT)
        rtd = 1./(miu-lambda) + d;
        origin= T(i,1);
        destination= T(i,2);
        lambda_od= T(i,3);
        lambda_do= T(i,4);
        r= ShortestPathSym(rtd,origin,destination); 
        routes(i,:)= r;
        j= 1;
        while r(j)~= destination
            lambda(r(j),r(j+1))= lambda(r(j),r(j+1)) + lambda_od; 
            lambda(r(j+1),r(j))= lambda(r(j+1),r(j)) + lambda_do; 
            j= j+1;
        end
    end
end
