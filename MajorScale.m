function [ MScale_array ] = MajorScale( central_tone )
%function:   MajorScale(central_tone)
%input:      central tone
%processing: makes an array of notes that are in the Major scale of the central
%            tone
%
%            The Major scale is made by counting from the central tone in the
%            pattern: Root(central tone)- W- W- H- W- W- W-H
%            where W is a whole skip (2 notes) and H is a half (1 note.)
%
%output:     array of note indexes of the Major Scale notes.


global nstrings
%set up array of notes:
notes = 1:nstrings;
notes = circshift(transpose(notes), [nstrings-central_tone+1 0]);
notes = reshape(notes, 1, nstrings);

scale_ind = 1;
notenow   = 1;
MScale_array(scale_ind)=notes(notenow);
while true
    if notenow<nstrings 
        scale_ind = scale_ind+1;
        notenow = notenow + 2;
        MScale_array(scale_ind)=notes(notenow);  %W
    else
        break
    end
    
    if notenow<nstrings 
        scale_ind = scale_ind+1;
        notenow = notenow + 2;
        MScale_array(scale_ind)=notes(notenow);  %W
    else
        break
    end

    if notenow<nstrings
        scale_ind = scale_ind+1;
        notenow = notenow + 1;
        MScale_array(scale_ind)=notes(notenow);  %H
    else
        break
    end

    if notenow<nstrings 
        scale_ind = scale_ind+1;
        notenow = notenow + 2;
        MScale_array(scale_ind)=notes(notenow);  %W
    else
        break
    end
    
    if notenow<nstrings 
        scale_ind = scale_ind+1;
        notenow = notenow + 2;
        MScale_array(scale_ind)=notes(notenow);  %W
    else
        break
    end

        if notenow<nstrings 
        scale_ind = scale_ind+1;
        notenow = notenow + 2;
        MScale_array(scale_ind)=notes(notenow);  %W
    else
        break
        end
    
    if notenow<nstrings
        scale_ind = scale_ind+1;
        notenow = notenow + 1;
        MScale_array(scale_ind)=notes(notenow);  %H
    else
        break
    end
end
end

