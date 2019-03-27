#!/bin/bash

#autoranges unless $2 == "y"

log=$1
range=$2

if [ -f ./pidtowatch ]; then 
  echo Found pidtowatch; 
else 
  echo Making pidtowatch; 
  egrep -o 'can[0|1] .*#' $log | cut -c 6-8 | sort -u > pidtowatch
fi

for i in $(cat pidtowatch) ; do grep $i"#" $log | sed 's/)//g' | sed 's/(//g' > "$i".log ; done
#for i in $(cat pidtowatch) ; do cat $i".log" | sed 's/^.*\#//g' | sed 's/.\{1\}/&,/g' > $i"_parsed.csv"; done - single byte resolution
for i in $(cat pidtowatch) ; do cat $i".log" | sed 's/^.*\#//g' | sed 's/.\{2\}/&,/g' > $i"_parsed.csv"; done
for i in $(cat pidtowatch) ; do gawk -F, '{print strtonum( "0x" $1)","strtonum("0x" $2)","strtonum("0x" $3)","strtonum("0x" $4)","strtonum("0x" $5)","strtonum("0x" $6)","strtonum("0x" $7)","strtonum("0x" $8)}' $i"_parsed.csv" > $i"_converted.csv"; done
for i in $(cat pidtowatch) ; do paste $i".log" $i"_converted.csv" | awk '{print $1,","$4}' | sed 's/ //g' > $i"_indexed.csv" ; done

for i in $(cat pidtowatch) ; do
echo \#!/usr/bin/gnuplot > plotdo
echo >> plotdo
echo set terminal png size 1600,1000 >> plotdo
echo set output \'$i"-0.png"\' >> plotdo
echo set datafile separator \",\" >> plotdo
echo set yrange[0:260] >> plotdo
echo plot \'$i"_indexed.csv"\' using 1:2 title \'byte0\' with lines >> plotdo
chmod 755 plotdo
./plotdo

echo \#!/usr/bin/gnuplot > plotdo
echo >> plotdo
echo set terminal png size 1600,1000 >> plotdo
echo set output \'$i"-1.png"\' >> plotdo
echo set datafile separator \",\" >> plotdo
if [$range = "y"] ; then
	echo set yrange[0:260] >> plotdo
fi
echo plot \'$i"_indexed.csv"\' using 1:3 title \'byte1\' with lines >> plotdo
./plotdo

echo \#!/usr/bin/gnuplot > plotdo
echo >> plotdo
echo set terminal png size 1600,1000 >> plotdo
echo set output \'$i"-2.png"\' >> plotdo
echo set datafile separator \",\" >> plotdo
if [$range = "y"]; then
	echo set yrange[0:260] >> plotdo
fi

echo plot \'$i"_indexed.csv"\' using 1:4 title \'byte2\' with lines >> plotdo
./plotdo

echo \#!/usr/bin/gnuplot > plotdo
echo >> plotdo
echo set terminal png size 1600,1000 >> plotdo
echo set output \'$i"-3.png"\' >> plotdo
echo set datafile separator \",\" >> plotdo
if [$range = "y"]; then
	echo set yrange[0:260] >> plotdo
fi
echo plot \'$i"_indexed.csv"\' using 1:5 title \'byte3\' with lines >> plotdo
./plotdo

echo \#!/usr/bin/gnuplot > plotdo
echo >> plotdo
echo set terminal png size 1600,1000 >> plotdo
echo set output \'$i"-4.png"\' >> plotdo
echo set datafile separator \",\" >> plotdo
if [$range = "y"]; then
	echo set yrange[0:260] >> plotdo
fi
echo plot \'$i"_indexed.csv"\' using 1:6 title \'byte4\' with lines >> plotdo
./plotdo

echo \#!/usr/bin/gnuplot > plotdo
echo >> plotdo
echo set terminal png size 1600,1000 >> plotdo
echo set output \'$i"-5.png"\' >> plotdo
echo set datafile separator \",\" >> plotdo
if [$range = "y"]; then
	echo set yrange[0:260] >> plotdo
fi
echo plot \'$i"_indexed.csv"\' using 1:7 title \'byte5\' with lines >> plotdo
./plotdo

echo \#!/usr/bin/gnuplot > plotdo
echo >> plotdo
echo set terminal png size 1600,1000 >> plotdo
echo set output \'$i"-6.png"\' >> plotdo
echo set datafile separator \",\" >> plotdo
if [$range = "y"]; then
	echo set yrange[0:260] >> plotdo
fi
echo plot \'$i"_indexed.csv"\' using 1:8 title \'byte6\' with lines >> plotdo
./plotdo

echo \#!/usr/bin/gnuplot > plotdo
echo >> plotdo
echo set terminal png size 1600,1000 >> plotdo
echo set output \'$i"-7.png"\' >> plotdo
echo set datafile separator \",\" >> plotdo
if [$range = "y"]; then
	echo set yrange[0:260] >> plotdo
fi
echo plot \'$i"_indexed.csv"\' using 1:9 title \'byte7\' with lines >> plotdo
./plotdo

echo \#!/usr/bin/gnuplot > plotdo
echo >> plotdo
echo set terminal png size 1600,1000 >> plotdo
echo set output \'$i"-all.png"\' >> plotdo
echo set datafile separator \",\" >> plotdo
if [$range = "y"]; then
	echo set yrange[0:260] >> plotdo
fi
echo plot \'$i"_indexed.csv"\' using 1:2 title \'byte0\' with lines, \'$i"_indexed.csv"\' using 1:3 title \'byte1\' with lines, \'$i"_indexed.csv"\' using 1:4 title \'byte2\' with lines,\'$i"_indexed.csv"\' using 1:5 title \'byte3\' with lines,\'$i"_indexed.csv"\' using 1:6 title \'byte4\' with lines,\'$i"_indexed.csv"\' using 1:7 title \'byte5\' with lines,\'$i"_indexed.csv"\' using 1:8 title \'byte6\' with lines,\'$i"_indexed.csv"\' using 1:9 title \'byte7\' with lines >> plotdo
./plotdo

done
