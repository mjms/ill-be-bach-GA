function [ baby1, baby2 ] =crossover( mom, dad )
%input:      mom (array), dad (array)
%processing: picks a node then crosses over (switch nodes) parental
%            chomosomes
%output:     2 offspring (2 arrays)
global maxnotes

node_start=randi([1 maxnotes]);
node_end=randi([node_start, maxnotes]);

temp_mom=mom(node_start:node_end);
temp_dad=dad(node_start:node_end);

mom(node_start:node_end)=temp_dad;
dad(node_start:node_end)=temp_mom;

baby1= mom;
baby2=dad;

end

