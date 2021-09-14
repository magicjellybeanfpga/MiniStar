
#Begin clock constraint
define_clock -name {top_ult|clk} {p:top_ult|clk} -period 10.000 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 5.000 -route 0.000 
#End clock constraint

#Begin clock constraint
define_clock -name {div_clk|flag_derived_clock} {n:div_clk|flag_derived_clock} -period 10.000 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 5.000 -route 0.000 
#End clock constraint
