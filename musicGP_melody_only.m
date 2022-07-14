%{ 
filename: musicGP_melody_only.m

MATLAB program by Marina Sundiang
Introduction to Computer Programming, Spring 2014, NYU
Prof. Charles S. Peskin


This is a genetic program that creates a melody only. 
Please download and run along with all the necessary functions:

MajorScale.m
fitness_harmony.m
crossover.m 
mutation.m

%}
clear all
close all
clf 

%if you want to hear the output type 1, else,0
piano=1;
%-------------------------------------------------------------------------%
%MUSIC GENETIC PROGRAM%

%INITIALIZATION
global is_MScale central_tone maxnotes
global nstrings
global p_geneMutation

nstrings=24;
central_tone=8;
maxnotes=24;

is_MScale= MajorScale(central_tone);

N=200; %number of people in the population
G=maxnotes; %number of genes
init_gen_mel= randi([1 nstrings], N, G+1);
init_gen_mel(:,1)=0;

p_crossover= 0.9;
p_mutate = 0.4;
p_geneMutation = 0.1;
runmax=100; %number of generations
c=0.9; %colors for graphs

gen_mel=init_gen_mel;
new_gen_mel=zeros(N, G+1);

sample_mel=zeros(5,G); %this melody gets sent to the piano program.
sample_fit=zeros(1,5);

%START OF MUSIC GP%
for run=1:runmax
%fitness:
    for i=1:N
       gen_mel(i,1)=fitness_melody(gen_mel(i,2:G+1));
    end
    
    sorted_mel=sortrows(gen_mel);

    best_ind_mel=sorted_mel(N,2:G+1);
    
    figure(1)
    hold on
    plot(best_ind_mel,'Color',[c 1 1])
   
    figure(2)
    plot(run,sorted_mel(N,1),'mo') %either one, they have the same fitness.
    hold on

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
    
    %MUTATIONS:MELODY
    for individual=1:N
        if rand<p_mutate
            new_gen_mel(individual,2:G+1)=mutation(new_gen_mel(individual,2:G+1),1, nstrings);
        end
    end 
    
    gen_mel=new_gen_mel;
    
    c= c-(0.5/runmax);
  
    %Store best here: (every quarter, store result)
    if run==1
        sample_mel(1,:) = best_ind_mel;
        sample_fit(1) = sorted_mel(N,1);
    elseif run==runmax/4
        sample_mel(2,:) = best_ind_mel;
        sample_fit(2) = sorted_mel(N,1);
    elseif run==runmax/2
        sample_mel(3,:) = best_ind_mel;  
        sample_fit(3) = sorted_mel(N,1);
    elseif run==(3*runmax)/4
        sample_mel(4,:) = best_ind_mel; 
        sample_fit(4) = sorted_mel(N,1);
    elseif run==runmax
        sample_mel(5,:) = best_ind_mel; 
        sample_fit(5) = sorted_mel(N,1);
    end
end

figure(1)
plot(best_ind_mel,'r')

if piano
    %-------------------------------------------------------------------------%
    %PIANO PROGRAM%

    %saves the sound matrix for 5 samples. (inital gen, 25%fit, 50%fit, 75%fit,
    %100%fit) NB: 100%fit is the best individual of the last generation
    %100%fit, set sample to 5

    for sample=1:5
    %INITIALIZATION
    L=1;
    xh1=0.1;xh2=0.3;
    M=0.28e-3; 
    f=349.228; % lowest frequency (Hz) F4
    for i=1:nstrings
        T(i)=M*(2*L*f)^2;
        f=f*2^(1/12); 
    end 
    r=0.0001;
    tmax=(maxnotes/2)+1; %(sec)

    J=81;dx=L/(J-1);
    j=2:(J-1);
    j1=1+ceil(xh1/dx);j2=1+floor(xh2/dx);
    jstrike=j1:j2;
    H=zeros(nstrings,J);
    V=zeros(nstrings,J);
    nskip=ceil(f*2*(J-1)/8192);  % set time step based on highest frequency
    dt=1/(8192*nskip);
    clockmax=ceil(tmax/dt);
    countmax=ceil(clockmax/nskip);
    tsave=zeros(1,countmax);
    S=zeros(1,countmax);  % record sound

    nn=maxnotes; % note # (in order by start time, arbitrary order of note that start at same time)
    tnote = [(0:1:nn-1) *(0.5)+0.2, tmax+0.1]; % 100 bpm (sec)  length=nn+1;
    dnote= [ones(1,nn-1), 2]*0.5; % duration (sec)
    Vnote= ones(1,nn)*100;  % volume of note
    tstop=zeros(1, nstrings);

        nn    = 1;
        count = 1;
        S     = zeros(1,countmax);


        inote=sample_mel(sample,:);


        for clock=1:clockmax
        t=clock*dt;

        while(t>tnote(nn))
            V(inote(nn),jstrike)=Vnote(nn);
            tstop(inote(nn))=t+dnote(nn);
            nn=nn+1;
        end

        for i=1:nstrings
            if t>tstop(i)
                V(i,:)=0; H(i,:)=0;
            else 
                V(i,j)=V(i,j)+dt/(dx^2)*(T(i)/M)*(H(i,j+1)-2*H(i,j)+H(i,j-1))-dt*r/M*V(i,j);
                H(i,j)=H(i,j)+dt*V(i,j);
            end
        end
        if mod(clock,nskip)==0
            count=count+1;
            S(count)=sum(H(:,2));
            tsave(count)=t;
        end

        end
        
    save(strcat('melodyOnly_sample',int2str(sample),'.mat'), 'S')
    wavwrite(S,8192, strcat('melodyOnly_samplewav',int2str(sample),'.wav'))
    end
end