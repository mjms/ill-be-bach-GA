function [ harmony_fitness ] = fitness_harmony( harmony, melody )
%function:fitness_harmoney 
%INPUT: an invididual (array of notes), and a melody line (notes to
%harmonize with)
%PROCESSING: score each note based on harmonizing with the melody. Points
%given for being in the Major scale of the central tone, penalized for bad
%harmonies (not in a chord, preferred interval [octaves,triads, etc.])
%OUTPUT: harmony fitness score
global is_MScale maxnotes

%Score accum variables:
harmony_score = 0; %how well this individual is harmonizing with melody


%look at each note and each corresponding melody note:
for i=1:maxnotes
    note=harmony(i);
    mel_note= melody(i);
    
    %if melody is in Major Scale, harmonize:
    if any(mel_note==is_MScale)
        loc_mel = find(is_MScale==mel_note,1);%location of melody note in Major Scale
        if any(note==is_MScale)
            %if note is also in Major scale:
            loc_note= find(is_MScale==note,1);
            
            %is it a good harmony?
            %good harmonies are two or four steps in scale above or below the
            %melody. Or an octave above or below
            
            if loc_note==loc_mel+2 || loc_note==loc_mel-2 ||      ...
                    loc_note==loc_mel+4 || loc_note==loc_mel-4 
                harmony_score = harmony_score +1;
                    
            elseif  loc_note==loc_mel+8 || loc_note==loc_mel-8 || ...
                    loc_note==loc_mel+10|| loc_note==loc_mel-10|| ...
                    loc_note==loc_mel+12|| loc_note==loc_mel-12
               %octave above? 
                harmony_score = harmony_score+1;
             
            elseif note==mel_note
                %no harmony. that's good.
                harmony_score = harmony_score + 1;
            else
                %not a good harmony
                harmony_score = harmony_score -1;
            end
        end
    else
        %if melody is not in major scale, do not harmonize.
        if note==mel_note
            harmony_score = harmony_score +1;
        else
            harmony_score = harmony_score -1;
        end
    end
end

        
 harmony_fitness=harmony_score;       

end

