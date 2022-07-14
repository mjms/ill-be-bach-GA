function [ melody_score ] = fitness_melody( individual )
%function:fitness_melody 
%INPUT: an invididual (array of notes)
%PROCESSING: score each note based on step-wise progression, and central
%tone distance, as well as if they are part of the Major scale of the
%central tone and if they end in the central tone.
%OUTPUT: fitness score
global is_MScale central_tone maxnotes

%Score accum variables:
central_score = 0; %how near the note is to the central tone. looks at fifths and octaves also.
step_score    = 0; %how near the note is to the previous note.
extra_credit  = 0; %extra credit points. Ends at central tone, uses Major scale notes.

for i=1:maxnotes
    note = individual(i);
    
    %if song starts with the central note, give partial credit
    if i==1 
        if note==central_tone
            extra_credit = extra_credit + 0.5;
        end
    
    %if not the first note:
    else
        %STEP SCORING. 
        %look at the note before it. 
        %what's the difference between notes?
        pnote = individual(i-1);
        step  = abs(note-pnote);
        score = (-1/4)*step +1.25; %arbitraty score function of difference. Punishes for large steps.
        
        step_score = step_score + score;
        
        %CENTRAL TONE SCORING +EXTRA CREDITS
        %same idea but with central tone.
        
        %is note a fifth?
        fifth = is_MScale(5);
        if note==fifth
            extra_credit = extra_credit+1;
        end
        
        %is note an eighth?
        eighth = is_MScale(8);
        if note == eighth
            extra_credit = extra_credit+1;
        end
        
        %is the note above central tone? 
        %the fifth is a dominant (ideal max of the melody, besides
        %occasional eighth). 
        if note>central_tone
            c_dist = note-central_tone;
            score = (1/(central_tone-fifth))*c_dist+1;
            
            central_score = central_score + score;
        
        %is the note below central tone? 
        %the fifth scale degree below is a subdominant (ideal min of the melody). 
        elseif note<central_tone;
            subdominant= central_tone-8;
            c_dist=central_tone-note;
            score = (-1/abs(central_tone-subdominant))*c_dist+1;
            
            central_score = central_score + score;
            
        else
            %central tone
            central_score = central_score + 1;
        end
        
        %if song ends in central tone, add points
        
        if i==maxnotes && note==central_tone
            extra_credit = extra_credit+1;
        end
        
        %if note is part of the central tone's Major scale.
        if any(note==is_MScale)
            extra_credit = extra_credit+1;
        end
        
        %Penalize for same notes in sequence.
        if note==pnote
            extra_credit = extra_credit - 1;
        end
        
    end
end

melody_score= central_score+step_score+extra_credit;

end

