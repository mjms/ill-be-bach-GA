# I'll Be Bach : Music and Genetic Algorithms

MATLAB program by Marina Sundiang

Introduction to Computer Simulations, Spring 2014, NYU

Prof. Charles S. Peskin

This is a genetic program that takes a initial population of notes
and evolves it to a simple melody and accompanying harmony. 
It produces sound by using a physics simulation of vibrations of strings in a piano.

Please download and run in folder. Make sure you have all the necessary functions:
fitness_melody.m
fitness_harmony.m
mutation.m
crossover.m
MajorScale.m

You may change the central_tone to change the key of the song. 1 is F4 and it 
goes half steps from that note until the specified number of piano keys (nstrings).
8 is C5. 

NB!!!
Please assure that nstrings ends in an octave and that your population is a multiple
of 4. 
