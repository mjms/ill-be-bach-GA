function [ mutant ] = mutation( individual,rangemin, rangemax )
%input: chromosome to be mutated
%process: randomly mutates genes in chromosome
%output: mutated chromosome
global maxnotes p_geneMutation
for i=1:maxnotes
    if rand<p_geneMutation
        individual(i)=randi([rangemin rangemax]);
    end
mutant=individual;
end
end

