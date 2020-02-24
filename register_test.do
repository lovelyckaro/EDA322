force aresetn 1
force clk 0
force input x"A0"
force load_enable 1
run 100ns
# Here result should be undefined
force clk 1
run 100ns
# Here result should be A0
force input x"FF"
force load_enable 0
force clk 0 
run 100ns
# Result should still be A0
force clk 1
run 100ns
# Result should still be A0
force clk 0
run 100ns
force load_enable 1
force clk 1
run 100ns
# Result should be FF
force aresetn 0
force clk 0
run 100ns
# Result should be 0
