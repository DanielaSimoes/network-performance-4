function [CurrentSolution,lambda] = BuildNeighbourLoad(CurrentSolution, lambda, i)
    Matrizes;
    T(:,3:4)= T(:,3:4)*1e6/(8*1000);

    miu= R*1e9/(8*1000);
    origin= T(i,1);
 
    r = CurrentSolution(i,:);
    destination= T(i,2);
    lambda_od= T(i,3);
    lambda_do= T(i,4);
    j=1;
    while r(j)~= destination
        lambda(r(j),r(j+1))= lambda(r(j),r(j+1)) - lambda_od; 
        lambda(r(j+1),r(j))= lambda(r(j+1),r(j)) - lambda_do; 
        j= j+1;
    end
    
    Load= lambda./miu;
    r = ShortestPathSym(Load,origin,destination); 
    CurrentSolution(i,:)= r;
    
    j=1;
    while r(j)~= destination
        lambda(r(j),r(j+1))= lambda(r(j),r(j+1)) + lambda_od; 
        lambda(r(j+1),r(j))= lambda(r(j+1),r(j)) + lambda_do; 
        j= j+1;
    end
end