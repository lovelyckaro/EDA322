#restart -f -nowave
#add wave x y cin result cout


force x 16#0#
force y 16#0#
force cin '0'
run 100ns
# result should be 0
# cout should be 0

force x 16#3#
force y 16#5#
run 100ns
# result should be 8
# cout should be 0

force x 16#ff#
force y "0"
force cin '1'
run 100ns
# result should be 0
# cout should be 1
