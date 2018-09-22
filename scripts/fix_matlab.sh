# Make MATLAB use the current system C++ library
cd /home/enigma/MATLAB/R2018b/sys/os/glnxa64/
mkdir exclude 
mv libstdc++.so.6* exclude

# Make MATLAB use the current system freetype library
cd /home/enigma/MATLAB/R2018b/bin/glnxa64/
mkdir exclude
mv libfreetype* exclude

