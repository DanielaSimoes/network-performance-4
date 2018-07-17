Counter = 0;
GlobalBest1 = Inf;
GlobalBest2 = Inf;
lambda = 0;
while Counter < 1000
    [CurrentSolution, CurrentSolutionlambda] = GreedyRandomized(); 
    [CurrentObjective1, CurrentObjective2] = Evaluate(CurrentSolution, CurrentSolutionlambda);
    repeat= true;
    while repeat
         NeighbourBest1 = Inf;
         NeighbourBest2 = Inf;
         for i=1:size(CurrentSolution,1)
             [NeighbourSolution, NeighbourSolutionLambda] = BuildNeighbour(CurrentSolution,CurrentSolutionlambda, i); 
             [NeighbourObjective1, NeighbourObjective2] = Evaluate(NeighbourSolution, NeighbourSolutionLambda);
             if NeighbourObjective1 < CurrentObjective1
                 NeighbourBest1 = NeighbourObjective1;
                 NeighbourBest2 = NeighbourObjective2;
                 NeighbourBestSolution = NeighbourSolution;
                 lambda = NeighbourSolutionLambda;
             elseif NeighbourObjective1 == CurrentObjective1
                 if NeighbourObjective2 < NeighbourBest2
                    NeighbourBest1 = NeighbourObjective1;
                    NeighbourBest2 = NeighbourObjective2;
                    NeighbourBestSolution= NeighbourSolution;
                    lambda = NeighbourSolutionLambda;
                 end
             end
         end
         if NeighbourBest1 < CurrentObjective1 || (NeighbourBest1 == CurrentObjective1 && NeighbourObjective2 < CurrentObjective2)
             CurrentObjective1 = NeighbourBest1;
             CurrentObjective2 = NeighbourBest2;
             CurrentSolution = NeighbourBestSolution;
             lambda = NeighbourSolutionLambda;
             
         else
             repeat= false;
         end
     end
     if CurrentObjective1 < GlobalBest1 || (CurrentObjective1 == GlobalBest1 &&   CurrentObjective2 < GlobalBest2) 
         GlobalBestSolution = CurrentSolution;
         GlobalBestSolution_lambda= lambda;
         GlobalBest1 = CurrentObjective1;
         GlobalBest2 = CurrentObjective2;
         Counter = 0;
     else
         Counter = Counter + 1;
     end
end

lambda = GlobalBestSolution_lambda;

Matrizes;
miu= R*1e9/(8*1000);
NumberLinks= sum(sum(R>0));
T(:,3:4)= T(:,3:4)*1e6/(8*1000); 
gama= sum(sum(T(:,3:4)));
d= L*1e3/2e8;
nT= size(T,1);

Load= lambda./miu;
Load(isnan(Load))= 0;
MaximumLoad = max(max(Load)) 
AverageLoad = sum(sum(Load))/NumberLinks 

RTDelay = (lambda./(miu-lambda)+lambda.*d);
RTDelay(isnan(RTDelay)) = 0;
RTDelay = sum(sum(RTDelay))/gama;
format long
RTDelay = RTDelay*2 

delay_flows = zeros(nT,1);

for i=1:nT
    origin= T(i,1);
    destination= T(i,2);
    r = GlobalBestSolution(i,:);
    j=1;
    while r(j)~= destination
        delay_flows(i) = delay_flows(i) + (1/(miu(r(j),r(j+1))-lambda(r(j),r(j+1))) + d(r(j),r(j+1)));
        delay_flows(i) = delay_flows(i) + (1/(miu(r(j+1),r(j))-lambda(r(j+1), r(j))) + d(r(j+1), r(j)));
        j= j+1;
    end
end

delay_flows = sortrows(delay_flows, -1); 
max_delay = delay_flows(1) 

subplot(1,2,1)
plot(delay_flows)
xlim([0 110])
grid on
title('Average packet round-trip delay of each flow') 

subplot(1,2,2)
graph_load = sortrows(Load(:), -1);  
graph_load = graph_load(1:NumberLinks);
plot(graph_load)
xlim([0 65])
grid on
title('Load of each link') 