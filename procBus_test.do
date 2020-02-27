## memory.do

#restart -f    	## Uncomment to restart simulation every time the script is executed
		## or,
#restart -f nowave    	## Uncomment to restart simulation every time the script is executed. nowave: removes all signals from waveform
#view signals wave	## add signals from the simulated top-level (here mem_array) to waveform


#force clk 0 0, 1 50ns -repeat 100ns

force INSTRUCTION x"A"
force DATA x"B"
force ACC x"C"
force EXTDATA x"D"
# Select signaler
force instrSEL 0
force dataSEL 0
force accSEL 0
force extdataSEL 0
run 100ns
# Output undefined
# Err på?

force instrSEL 1
run 100ns
# output should be A
force instrSEL 0
force dataSEL 1
run 100ns
# output should be B
force accSEL 1
run 100ns
# output should be D
# Err should be 1



# etc...
