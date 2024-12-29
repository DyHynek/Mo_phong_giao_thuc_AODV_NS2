set val(chan)           Channel/WirelessChannel    
set val(prop)           Propagation/TwoRayGround   
set val(netif)          Phy/WirelessPhy            
set val(mac)            Mac/802_11                 
set val(ifq)          	Queue/DropTail/PriQueue    
#set val(ifq)           CMUPriQueue    		
set val(ll)             LL                         
set val(ant)            Antenna/OmniAntenna       
set val(ifqlen)         50                         
set val(nn)             12                         
set val(rp)             AODV                       
set val(x)              500                       
set val(y)              400                        
set val(stop)           150                        

set ns          [new Simulator]
set tracefd       [open AODVtrace.tr w]
#set windowVsTime2 [open win.tr w]
set namtrace      [open AODVtrace.nam w]
set Time	[open time.tr w]

#luu gia tri thong luong
set cwnd9 [open cwnd9.tr w]
set cwnd10 [open cwnd10.tr w]

#luu gia tri bang thong
set b9 [open b9.tr w]
set b10 [open b10.tr w]


set xcord(0) 90
set xcord(1) 90
set xcord(2) 410
set xcord(3) 410

set xcord(4) 250
set xcord(5) 250
set xcord(6) 130
set xcord(7) 370
set xcord(8) 250

set xcord(9) 1
set xcord(10) 1
set xcord(11) 499

set ycord(0) 90
set ycord(1) 310
set ycord(2) 90
set ycord(3) 310

set ycord(4) 130
set ycord(5) 270
set ycord(6) 200
set ycord(7) 200
set ycord(8) 200

set ycord(9) 1
set ycord(10) 399
set ycord(11) 200

$ns color 1 Blue
$ns color 2 Red

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

$ns node-config \
     -adhocRouting $val(rp) \
     -llType $val(ll) \
     -macType $val(mac) \
     -ifqType $val(ifq) \
     -ifqLen $val(ifqlen) \
     -antType $val(ant) \
     -propType $val(prop) \
     -phyType $val(netif) \
     -channelType $val(chan) \
     -topoInstance $topo \
     -agentTrace ON \
     -routerTrace ON \
     -macTrace OFF \
     -movementTrace ON

    for {set i 0} {$i < $val(nn) } { incr i } {
        set node_($i) [$ns node]
        $node_($i) set X_ $xcord($i)
        $node_($i) set Y_ $ycord($i)
        $node_($i) set Z_ 0.0
    }
    
$ns at 0 "$node_(9) setdest 499 1 25"
$ns at 0 "$node_(10) setdest 499 399 25"
$ns at 25 "$node_(9) setdest 1 1 25"
$ns at 25 "$node_(10) setdest 1 399 25"
$ns at 50 "$node_(9) setdest 499 1 25"
$ns at 50 "$node_(10) setdest 499 399 25"
$ns at 75 "$node_(9) setdest 1 1 25"
$ns at 75 "$node_(10) setdest 1 399 25"

$ns at 0 "$node_(5) setdest 130 200 3"
$ns at 0 "$node_(6) setdest 250 130 3"
$ns at 0 "$node_(4) setdest 370 200 3"
$ns at 0 "$node_(7) setdest 250 270 3"

$ns at 50 "$node_(5) setdest 250 130 3"
$ns at 50 "$node_(6) setdest 370 200 3"
$ns at 50 "$node_(4) setdest 250 270 3"
$ns at 50 "$node_(7) setdest 130 200 3"

$ns at 0 "$node_(11) setdest 499 399 25"
$ns at 10 "$node_(11) setdest 499 200 25"
$ns at 25 "$node_(11) setdest 499 1 25"
$ns at 35 "$node_(11) setdest 499 200 25"

$ns at 50 "$node_(11) setdest 499 399 25"
$ns at 60 "$node_(11) setdest 499 200 25"
$ns at 75 "$node_(11) setdest 499 1 25"
$ns at 85 "$node_(11) setdest 499 200 25"

$ns at 100 "$node_(11) setdest 499 399 25"
$ns at 110 "$node_(11) setdest 499 200 25"
$ns at 125 "$node_(11) setdest 499 1 25"
$ns at 135 "$node_(11) setdest 499 200 25"

$ns at 100 "$node_(0) setdest 90 310 25"
$ns at 100 "$node_(1) setdest 410 310 25"
$ns at 100 "$node_(2) setdest 90 90 25"
$ns at 100 "$node_(3) setdest 410 90 25"

$ns at 125 "$node_(0) setdest 410 310 25"
$ns at 125 "$node_(1) setdest 410 90 25"
$ns at 125 "$node_(2) setdest 90 310 25"
$ns at 125 "$node_(3) setdest 90 90 25"


set tcp0 [new Agent/TCP/Newreno]
$tcp0 set class_ 2
set sink0 [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp0
$ns attach-agent $node_(11) $sink0
$ns connect $tcp0 $sink0
set ftp [new Application/FTP]
$ftp attach-agent $tcp0
$ns at 0.1 "$ftp start"

set tcp1 [new Agent/TCP/Vegas]
$tcp1 set class_ 1
set sink1 [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp1
$ns attach-agent $node_(11) $sink1
$ns connect $tcp1 $sink1
set ftp [new Application/FTP]
$ftp attach-agent $tcp1
$ns at 0.1 "$ftp start"

#tinh thong luong
proc calcCwnd {tcpSource file} {
	global ns
	set time 1
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "calcCwnd $tcpSource $file"
}

$ns at 0.00 "calcCwnd $tcp0 $cwnd9"
$ns at 0.00 "calcCwnd $tcp1 $cwnd10"

#tinh bang thong
proc calcByte {sink file} {
	global ns
	set time 1
	set bw0 [$sink set bytes_]
	set now [$ns now]
	puts $file " $now [expr {$bw0 / $time * 8 / 1000000}]"
	$sink set bytes_ 0
	$ns at [expr $now + $time] "calcByte $sink $file"
}
$ns at 0.00 "calcByte $sink0 $b9"
$ns at 0.00 "calcByte $sink1 $b10"

for {set i 0} {$i < $val(nn)} { incr i } {
	$ns initial_node_pos $node_($i) 30
}

for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}


$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 150 "puts \"end simulation\" ; $ns halt"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
}

$ns run
