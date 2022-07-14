clear all
close all
clf 

%-------------------------------------------------------------------------%
%MUSIC GENETIC PROGRAM%

%INITIALIZATION
global is_MScale central_tone maxnotes
global nstrings
global p_geneMutation

nstrings=24;
central_tone=1;
maxnotes=24;

is_MScale= MajorScale(central_tone);

N=40; %number of people in the population
G=maxnotes; %number of genes

p_crossover= 0.8;
p_mutate = 0.4;
p_geneMutation = 0.1;
runmax=100; %number of generations

c=0.9; %colors for graphs
r=0;
g=0.29;
b=0.90;

for p_crossover=0:0.1:1
    p_mutate
    p_crossover
   
init_gen_mel= randi([1 nstrings], N, G+1);
init_gen_mel(:,1)=0;

init_gen_har= randi([1 nstrings], N, G+1);
init_gen_har(:,1)=0;

gen_mel=init_gen_mel;
gen_har=init_gen_har;
new_gen_mel=zeros(N, G+1);
new_gen_har=zeros(N, G+1);

sample_mel=zeros(5,G); %this melody gets sent to the piano program.
sample_har=zeros(5,G); %this harmony gets sent to the piano program.
sample_fit=zeros(1,5);

bestSave=zeros(1,runmax);
runSave=zeros(1,runmax);
%START OF MUSIC GP%
for run=1:runmax
%fitness:
    for i=1:N
        mel_fit=fitness_melody(gen_mel(i,2:G+1));
        har_fit=fitness_harmony(gen_har(i,2:G+1),gen_mel(i,2:G+1));
        
        fitness_tot= mel_fit+har_fit;
        
        gen_mel(i,1)= fitness_tot;
        gen_har(i,1)= fitness_tot;
    end
    
    sorted_mel=sortrows(gen_mel);
    sorted_har=sortrows(gen_har);
    best_ind_mel=sorted_mel(N,2:G+1);
    best_ind_har=sorted_har(N,2:G+1);
    
%     figure(1)
%     hold on
%     plot(best_ind_mel,'Color',[c 1 1])
%     plot(best_ind_har,'Color',[1 c 1])
   

    %CROSSOVERS: MELODY
    offspring = 0;
    parent    = N;
    
    while offspring<N
        for cross_times=1:2
            if rand<p_crossover
                %melody cross
                [new_gen_mel(offspring+1,2:G+1), new_gen_mel(offspring+2,2:G+1)]=crossover(sorted_mel(parent, 2:G+1),sorted_mel(parent-1, 2:G+1));
                offspring = offspring+2;
            else
                new_gen_mel(offspring+1,2:G+1) = sorted_mel(parent, 2:G+1);
                new_gen_mel(offspring+2,2:G+1) = sorted_mel(parent-1, 2:G+1);
                offspring= offspring+2;
            end
        end
        parent = parent -2;
    end
    
    %CROSSOVERS: HARMONIES
    offspring = 0;
    parent    = N;
    
    while offspring<N
        for cross_times=1:2
            if rand<p_crossover
                [new_gen_har(offspring+1,2:G+1), new_gen_har(offspring+2,2:G+1)]=crossover(sorted_har(parent, 2:G+1),sorted_har(parent-1, 2:G+1));
                offspring = offspring+2;
            else
                new_gen_har(offspring+1,2:G+1) = sorted_har(parent, 2:G+1);
                new_gen_har(offspring+2,2:G+1) = sorted_har(parent-1, 2:G+1);
                offspring= offspring+2;
            end
        end
        parent = parent -2;
    end
    
    
    %MUTATIONS:MELODY
    for individual=1:N
        if rand<p_mutate
            new_gen_mel(individual,2:G+1)=mutation(new_gen_mel(individual,2:G+1),1, nstrings);
        end
    end
    
    %MUTATIONS:HARMONY
    for individual=1:N
        if rand<p_mutate
            new_gen_har(individual,2:G+1)=mutation(new_gen_har(individual,2:G+1),1, nstrings);
        end
    end    
    
    gen_mel=new_gen_mel;
    gen_har=new_gen_har;
    c= c-(0.5/runmax);

    bestSave(run)=sorted_mel(N,1);
    runSave(run)=run;
end

figure(2)
plot(runSave,bestSave, 'Color', [r g b])
hold on

r= r+0.1;
g= g-0.028;
b= b-0.089;
end
