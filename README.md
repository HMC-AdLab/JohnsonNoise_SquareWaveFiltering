This is the repository started by Evan Bourke for the Johnson Noise experiment in Adlab on 12/6.

SquareFilter.m is for digital processing of filter gain profiles for the use in measuring Boltzmann's constant from Johnson Noise. 
To use the matlab file, you need to have two csv or txt files (anything that works with the readmatrix function in Matlab). 
One of these files needs to be the voltage vs time data from a square wave. The other file needs to be the voltage vs time data of the output of this same square wave (same amplitude and frequency) inputted into the filter you want to measure.
The input to the function will be the names of both files that are in your Matlab workspace folder and the frequency used for the square waves.
The output of this file will be a Matlab matrix where the first column is frequencies and the second column is the gains for those frequencies.

It is recommended that multiple gain profiles for multiple different frequencies of square waves are combined to characterize the filter for a larger range of frequencies.
Since a pure square wave has frequency contributions from only the odd harmonics of the fundamental frequency, these are the frequencies that are characterized by this function.
