# ***********************************************************************
#
# $HeadURL: https://www.mech.kth.se/svn/simson/trunk/rit/Makefile $
# $LastChangedDate: 2012-11-10 22:18:13 +0100 (Sat, 10 Nov 2012) $
# $LastChangedBy: pschlatt@MECH.KTH.SE $
# $LastChangedRevision: 1810 $
#
# ***********************************************************************

# compiler flags
#F90   = ifort
#FLAGS = -r8 -i4 -O3 -warn truncated_source -warn unused
#if compiled with gfortran, use -O0 for plot1.f and cont5.f
F90   = gfortran
FLAGS = -fdefault-real-8 -O0

# main program, FFTs and plot routines
main  = rit
image = $(main)
fftp  = cvecfft_acc

# classified subroutines
plot1   = plot1.o
2dsnitt = xyplane.o xzplane.o yzplane.o xzspec.o 
1dsnitt = reschk.o xline.o yline.o yline_spec.o zline.o myline.o \
          twox.o twoz.o blth.o
filter  = cvar.o zwall.o gauss.o scalef.o scaley.o submean.o
read    = rdiscp.o
diffint = rdcheb.o icheb.o
pg      = pgmr.o wpgmr.o
get     = getxzp.o getxyp.o
put     = putxyp.o putxzp.o
plot    = cont5.o
dep     = $(main).o $(1dsnitt) $(2dsnitt) $(read) $(get) $(put) $(filter)
idep    = $(plot) $(diffint) $(pg) $(plot1) $(fftp).o
obj     = $(dep) $(idep)

# compilation rules
%.o: %.f
	 $(F90) $(FLAGS) -c $*.f 

$(image): $(obj) Makefile
	@echo " " ; echo " Link object files into executable image '$(image)'."
	@echo " "
	$(F90) $(FLAGS) -o $@ $(obj)
	@echo " " ; echo " Done!" ; echo " "

$(dep):	par.f

clean:
	@echo " " ; echo " Clean up all object files and '$(image)'."
	@-rm -f *.o *.F *~ $(image) ; echo " "
