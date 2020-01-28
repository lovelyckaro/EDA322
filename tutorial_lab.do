#restart -f -nowave
#add wave clk aresetn a b c d sel output


force clk 0 0, 1 50ns -repeat 100ns
force aresetn 0 0, 1 120ns
force a b"000"
force b b"001"
force c b"111"
force d b"101"
force sel b"11" 
run 300ns
force sel b"10"
run 100ns
force sel b"00"
run 100ns
force sel b"01"
run 100ns
