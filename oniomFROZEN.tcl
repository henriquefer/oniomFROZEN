#### Time #####
	proc duration { secs } {
     set timeatoms [ list ]
     if { [ catch {
        foreach div { 86400 3600 60 1 } \
                mod { 0 24 60 60 } \
               name { day hour min sec } {
           set n [ expr {$secs / $div} ]
           if { $mod > 0 } { set n [ expr {$n % $mod} ] }
           if { $n > 1 } {
              lappend timeatoms "$n ${name}s"
           } elseif { $n == 1 } {
             lappend timeatoms "$n ${name}"
           }
        }
     } err ] } {
        return -code error "duration: $err"
     }
     return [ join $timeatoms ]
	}

	proc tempo {time0 time1} {
       ## transformar o tempo num integer
       scan "$time0" "%dh %dm %ds   %s %s %s" h0 m0 s0 mt0 d0 y0
       scan "$time1" "%dh %dm %ds   %s %s %s" h1 m1 s1 mt1 d1 y1
       set time0 [clock scan "$h0:$m0:$s0 $mt0 $d0 $y0"]
       set time1 [clock scan "$h1:$m1:$s1 $mt1 $d1 $y1"]
       ## contas de diferença do tempo
       set timeD [expr abs ($time0-$time1)]
       set timeDiff "1 secs"
       if {$timeD!=0} {set timeDiff [duration $timeD]}
       return $timeDiff
	}


proc rootName {File} {
	global fileName
	set fileName [file rootname $File]
}

proc deleteTmpFiles {fileName} {
  file delete -force "FROZENtmpFiles"
}

#### Read Gaussian Input File ####
	proc readGaussianInputFile {fileName File} {
		exec egrep -m 1 -B 200 {PDBName=} $File > FROZENtmpFiles/header_$fileName.tmp | egrep -v {PDBName=}
		exec egrep {PDBName=} $File > FROZENtmpFiles/coordinates_$fileName.tmp
	}

#### ReadFile of residues ####
	proc readFile {Frozen} {
		global listResiduesUnfrozen
		set frozenFile [open "$Frozen" r]
  		set frozenData [read $frozenFile]
  		set linesFrozen [split $frozenData \n]
  		foreach lineFrozen $linesFrozen {
    		lassign $lineFrozen residuesUnfrozen
    		lappend listResiduesUnfrozen $residuesUnfrozen
 		}
 		close $frozenFile
	}

	proc writtingFileReadFile {fileName listResiduesUnfrozen} {
		set outputFile [open "FROZEN-ReadFile-$fileName.com" w]
		set openFileHeader [open "FROZENtmpFiles/header_$fileName.tmp" r]
		set readFileHeader [read $openFileHeader]
		puts -nonewline $outputFile "$readFileHeader"
		set openFileCoordinates [open "FROZENtmpFiles/coordinates_$fileName.tmp" r]
		set readFileCoordinates [read $openFileCoordinates]
		set lines [split $readFileCoordinates \n]
		foreach line $lines {
			lassign $line allInfo frozenStatus xx yy zz layer borderAtom borderAtomNumber pointOne pointTwo
			set searchResid [regexp {ResNum=(\S+)[)]} $allInfo -> resid]
			if {[lsearch -exact $listResiduesUnfrozen [subst $resid]]==-1} {
				set frozen -1} else {
            	set frozen 0
        		}
        	if {$allInfo != ""} {
            puts -nonewline $outputFile " [format %-60s $allInfo] [format %-4s $frozen] [format "%10s"  [format %-7s $xx]] [format "%10s"  [format %-7s $yy]] [format "%10s"  [format %-7s $zz]] [format %-2s $layer] $borderAtom $borderAtomNumber   $pointOne $pointTwo \n"
			}
		}
		close $openFileCoordinates
		close $openFileHeader
	}


#### Frozen All Atoms ####
	proc writtingFileAllAtomosFrozen {fileName} \
	{
		set outputFile [open "FROZEN-AllFrozen-$fileName.com" w]
		set openFileHeader [open "FROZENtmpFiles/header_$fileName.tmp" r]
		set readFileHeader [read $openFileHeader]
		puts -nonewline $outputFile "$readFileHeader"
		set openFileCoordinates [open "FROZENtmpFiles/coordinates_$fileName.tmp" r]
		set readFileCoordinates [read $openFileCoordinates]
		set lines [split $readFileCoordinates \n]
		foreach line $lines {
			lassign $line allInfo frozenStatus xx yy zz layer borderAtom borderAtomNumber pointOne pointTwo
			set frozen -1
			if {$allInfo != ""} {
	        puts -nonewline $outputFile " [format %-60s $allInfo] [format %-4s $frozen] [format "%10s"  [format %-7s $xx]] [format "%10s"  [format %-7s $yy]] [format "%10s"  [format %-7s $zz]] [format %-2s $layer] $borderAtom $borderAtomNumber   $pointOne $pointTwo \n"
	    	}
		}
		close $openFileCoordinates
		close $openFileHeader	
	}

#### Unfrozen All Atoms ####
	proc writtingFileAllAtomosUnfrozen {fileName} \
	{
		set outputFile [open "FROZEN-AllUnfrozen-$fileName.com" w]
		set openFileHeader [open "FROZENtmpFiles/header_$fileName.tmp" r]
		set readFileHeader [read $openFileHeader]
		puts -nonewline $outputFile "$readFileHeader"
		set openFileCoordinates [open "FROZENtmpFiles/coordinates_$fileName.tmp" r]
		set readFileCoordinates [read $openFileCoordinates]
		set lines [split $readFileCoordinates \n]
		foreach line $lines {
			lassign $line allInfo frozenStatus xx yy zz layer borderAtom borderAtomNumber pointOne pointTwo
			set frozen 0
			if {$allInfo != ""} {
	        puts -nonewline $outputFile " [format %-60s $allInfo] [format %-4s $frozen] [format "%10s"  [format %-7s $xx]] [format "%10s"  [format %-7s $yy]] [format "%10s"  [format %-7s $zz]] [format %-2s $layer] $borderAtom $borderAtomNumber   $pointOne $pointTwo \n"
	    	}
		}
		close $openFileCoordinates
		close $openFileHeader	
	}

#### Invert ####
	proc writtingFileInvert {fileName} {
		set outputFile [open "FROZEN-Invert-$fileName.com" w]
		set openFileHeader [open "FROZENtmpFiles/header_$fileName.tmp" r]
		set readFileHeader [read $openFileHeader]
		puts -nonewline $outputFile "$readFileHeader"
		set openFileCoordinates [open "FROZENtmpFiles/coordinates_$fileName.tmp" r]
		set readFileCoordinates [read $openFileCoordinates]
		set lines [split $readFileCoordinates \n]
		foreach line $lines {
			lassign $line allInfo frozenStatus xx yy zz layer borderAtom borderAtomNumber pointOne pointTwo
			if {$frozenStatus ==-1} {
				set frozen 0
				} elseif {$frozenStatus ==0} {
            	set frozen -1
        		}
        	if {$allInfo != ""} {
            puts -nonewline $outputFile " [format %-60s $allInfo] [format %-4s $frozen] [format "%10s"  [format %-7s $xx]] [format "%10s"  [format %-7s $yy]] [format "%10s"  [format %-7s $zz]] [format %-2s $layer] $borderAtom $borderAtomNumber   $pointOne $pointTwo \n"
			}
		}
		close $openFileCoordinates
		close $openFileHeader
	}

#### InvertNoWater ####
	proc writtingFileInvertNoWater {fileName} {
		set outputFile [open "FROZEN-InvertNoWater-$fileName.com" w]
		set openFileHeader [open "FROZENtmpFiles/header_$fileName.tmp" r]
		set readFileHeader [read $openFileHeader]
		puts -nonewline $outputFile "$readFileHeader"
		set openFileCoordinates [open "FROZENtmpFiles/coordinates_$fileName.tmp" r]
		set readFileCoordinates [read $openFileCoordinates]
		set lines [split $readFileCoordinates \n]
		foreach line $lines {
			lassign $line allInfo frozenStatus xx yy zz layer borderAtom borderAtomNumber pointOne pointTwo
			set searchResName [regexp {ResName=(\S+),} $line -> resName]
			if {$resName =="WAT"} {
				set frozen -1
			} elseif {$frozenStatus ==-1} {
				set frozen 0
			} elseif {$frozenStatus ==0} {
            	set frozen -1
        	}
        	if {$allInfo != ""} {
            puts -nonewline $outputFile " [format %-60s $allInfo] [format %-4s $frozen] [format "%10s"  [format %-7s $xx]] [format "%10s"  [format %-7s $yy]] [format "%10s"  [format %-7s $zz]] [format %-2s $layer] $borderAtom $borderAtomNumber   $pointOne $pointTwo \n"
			}
		}
		close $openFileCoordinates
		close $openFileHeader
	}

######################################################################################################################################
##########                             STRAT     START     START     START     START     START     START               ###############
######################################################################################################################################
puts \n
puts "                         ██████╗ ███╗   ██╗██╗ ██████╗ ███╗   ███╗ "
puts "                        ██╔═══██╗████╗  ██║██║██╔═══██╗████╗ ████║ "
puts "                        ██║   ██║██╔██╗ ██║██║██║   ██║██╔████╔██║ "
puts "                        ██║   ██║██║╚██╗██║██║██║   ██║██║╚██╔╝██║ "
puts "                        ╚██████╔╝██║ ╚████║██║╚██████╔╝██║ ╚═╝ ██║ "
puts "                         ╚═════╝ ╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝     ╚═╝ "
puts "                                         Version 1.0  ◉ 26 NOV 2015"
puts "                ███████╗██████╗  ██████╗ ███████╗███████╗███╗   ██╗"
puts "                ██╔════╝██╔══██╗██╔═══██╗╚══███╔╝██╔════╝████╗  ██║"
puts "                █████╗  ██████╔╝██║   ██║  ███╔╝ █████╗  ██╔██╗ ██║"
puts "                ██╔══╝  ██╔══██╗██║   ██║ ███╔╝  ██╔══╝  ██║╚██╗██║"
puts "                ██║     ██║  ██║╚██████╔╝███████╗███████╗██║ ╚████║"
puts "                ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═══╝"  
puts "        Developer: Henrique Fernandes (henrique.fernandes@fc.up.pt)"
puts "                    tclsh oniomFROZEN --help for more information"
puts \n

### Load input information fom user ###
		file mkdir FROZENtmpFiles /
		set Options [lindex $argv 0]
		set File [lindex $argv 1]
		set Frozen [lindex $argv 2]

	if {[lindex $argv 0]== "--help" ||  $File=="" || $Options==""} {
		        puts "  Usage:"
		        puts "  runs on the shell \n\t> tclsh oniomANALYSIS.tcl \[A\] \[B\] \[c\]"
		        puts "  \[A\]: insert a flag to define what you want"
		        puts "			--readfile : residues of file \[C\] will be unfrozen and all others will be froz"
		        puts "			--frozenall : all atoms will be frozen"
		        puts "			--unfrozenall : all atoms will be unfrozen"
		        puts "			--invert : all previous unfrozen atoms will be frozen and all previous frozen atoms will be unfrozen"
		        puts "			--invertnowater : equal to previous but all water molecules \(ResName=WAT\) will be frozen"
		        puts "  \[B\]: Gaussian Input File \(.com\)"
		        puts "  \[C\]: file with a list of residues to become unfrozen. ONLY works with the --readfile flag"
		        puts "\n"
		        puts " Developer: Henrique Fernandes   henrique.fernandes@fc.up.pt"
		        puts "\n"
		        exit
		}

#### Define rootName ####
	rootName $File

#### Read Gaussian Input File ####
	readGaussianInputFile $fileName $File

#### ReadFile with atoms to become unfrozen ####
	if {[lindex $argv 0]== "--readfile"} {
		set time0 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]

		readFile $Frozen
		puts "\t All residues will be frozen, except: $listResiduesUnfrozen"
		writtingFileReadFile $fileName $listResiduesUnfrozen

		set time1 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]
		set result [tempo $time0 $time1]
		puts "\t Time spent: $result"
	}

#### All Atomos Frozen ####
	if {[lindex $argv 0]== "--frozenall"} {
		set time0 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]

		puts "\t All atoms will be frozen."
		writtingFileAllAtomosFrozen $fileName

		set time1 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]
		set result [tempo $time0 $time1]
		puts "\t Time spent: $result"
	}

#### All Atomos Unfrozen ####
	if {[lindex $argv 0]== "--unfrozenall"} {
		set time0 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]

		puts "\t All atoms will be unfrozen."
		writtingFileAllAtomosUnfrozen $fileName

		set time1 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]
		set result [tempo $time0 $time1]
		puts "\t Time spent: $result"
	}

#### Invert ####
	if {[lindex $argv 0]== "--invert"} {
		set time0 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]

		puts "\t All previous unfrozen atoms will be frozen and all previous frozen atoms will be unfrozen"
		writtingFileInvert $fileName

		set time1 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]
		set result [tempo $time0 $time1]
		puts "\t Time spent: $result"
	}

#### Invert and not WATER ####
	if {[lindex $argv 0]== "--invertnowater"} {
		set time0 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]

		puts "\t All previous unfrozen atoms will be frozen and all previous frozen atoms will be unfrozen.\n\t BUT all water molecules \(ResName=WAT\) will be frozen"
		writtingFileInvertNoWater $fileName

		set time1 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]
		set result [tempo $time0 $time1]
		puts "\t Time spent: $result"
	}


#### Delete Temporary Files ####
	deleteTmpFiles $fileName

### Jobs were done ###
	puts \n
	puts "\t All jobs were done succesfully. :\)"
	puts \n