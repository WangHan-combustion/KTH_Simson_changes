# ***********************************************************************
#
# $HeadURL: https://www.mech.kth.se/svn/simson/trunk/pxyst/Makefile $
# $LastChangedDate: 2012-10-10 18:31:16 +0200 (Wed, 10 Oct 2012) $
# $LastChangedBy: taras@MECH.KTH.SE $
# $LastChangedRevision: 1807 $
#
# ***********************************************************************

# compiler flags
#F90   = ifort
#FLAGS = -g -r8 -i4 -O3 -i_dynamic -mcmodel=medium -warn truncated_source -warn unused
##F90   = pgf90
##FLAGS = -r8 -O3
F90   = gfortran
FLAGS = -fdefault-real-8 -cpp -O3 -DLINUX_GFORTRAN

# main program, FFTs and plot routines
main  = pxyst
image = $(main)
fftp  = cvecfft_acc

# classified subroutines.
plot   = plot1.o
sub    = mgrid.o rxys.o meanpl.o correlation.o correlation_old.o
comp   = pvar.o locsc.o rscale.o ddx.o ddy.o
filter = filter.o infilt.o
dep    = $(main).o $(sub) $(comp) $(filter)
idep   = cont5.o pgmr.o wpgmr.o mxpl.o mypl.o icheb.o rdcheb.o chebe2.o $(plot) $(fftp).o
obj    = $(dep) $(idep)

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


