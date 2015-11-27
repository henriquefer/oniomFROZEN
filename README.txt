                  ██████╗ ███╗   ██╗██╗ ██████╗ ███╗   ███╗ 
                 ██╔═══██╗████╗  ██║██║██╔═══██╗████╗ ████║ 
                 ██║   ██║██╔██╗ ██║██║██║   ██║██╔████╔██║ 
                 ██║   ██║██║╚██╗██║██║██║   ██║██║╚██╔╝██║ 
                 ╚██████╔╝██║ ╚████║██║╚██████╔╝██║ ╚═╝ ██║ 
                  ╚═════╝ ╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝     ╚═╝ 

        ███████╗██████╗  ██████╗ ███████╗███████╗███╗   ██╗
        ██╔════╝██╔══██╗██╔═══██╗╚══███╔╝██╔════╝████╗  ██║
        █████╗  ██████╔╝██║   ██║  ███╔╝ █████╗  ██╔██╗ ██║
        ██╔══╝  ██╔══██╗██║   ██║ ███╔╝  ██╔══╝  ██║╚██╗██║
        ██║     ██║  ██║╚██████╔╝███████╗███████╗██║ ╚████║
        ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═══╝

Script developed by Henrique Silva Fernandes (henrique.fernandes@fc.up.pt | henriquefer11@gmail.com)

oniomFROZEN allows exchange the frozen state of atoms in Gaussian 09 input files (.com).

How to use: 

	Insert follow command in shell:
		> tclsh oniomFROZEN.tcl [A] [B] [C]

	Where:
		[A] is a flag which defines what type of job is going to be perfomed:
			--readfile : residues of file \[C\] will be unfrozen and all others will be frozen
			--frozenall : all atoms will be frozen
			--unfrozenall : all atoms will be unfrozen
			--invert : all previous unfrozen atoms will be frozen and all previous frozen atoms will be unfrozen
			--invertnowater : equal to previous but all water molecules \(ResName=WAT\) will be frozen

		[B] is the Gaussian 09 input file (.com)

		[C] is a file with a list of residues (one number per line) to become unfrozen, frozen all other residues. ONLY works with the --readfile flag.


Todos os direitos reservados. 2015
——————————————————————————————————————————————————————————————————————————————————————————————————————