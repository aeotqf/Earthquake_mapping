* sismosdata.csv contains the project of earthquakes analytics in honduras

* hnmap0 - hnnmap 14 contains data points to visualize the honduran map

* you need to install the package mapping to use haversine
from linux: sudo apt-get install -y octave-mapping
from octave: pkg install -forge mapping

* or you can use instead of haversine the following code: 
dis = sqrt((sblat - lat)^2 + (sblon - lon)^2);
and there is not need of the package mapping
