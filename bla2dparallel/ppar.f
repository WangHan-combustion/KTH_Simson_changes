c ***********************************************************************
c
c $HeadURL: https://www.mech.kth.se/svn/simson/branches/bla2dparallel/ppar.f $
c $LastChangedDate: 2008-05-08 15:13:33 +0200 (Thu, 08 May 2008) $
c $LastChangedBy: pschlatt@MECH.KTH.SE $
c $LastChangedRevision: 1190 $
c
c ***********************************************************************
      subroutine ppar(my_node_world,all_nodes_world,
     &     ompnthreads,ompnproc)
c
c     Prints out all static parameters
c     and performs basic sanity check
c
      implicit none

      include 'par.f'
#ifdef MPI
      include 'mpif.h'
      integer ierror
#endif
      character(len=80) current_directory
      character(len=20) hostname,fftstring
      logical end
      integer ntmp,stop_now,my_node_world
      integer all_nodes_world,ompnthreads,ompnproc
c
c     Only processor zero tests the parameters
c
      if (my_node_world.gt.0) goto 9999
c
c     Get the local host name
c
      hostname = 'not known'
      call getenv('HOST',hostname)
      
      current_directory = 'not known'
      call getenv('PWD',current_directory)
      
      write(*,*) 'Name of host machine : ',trim(hostname)
      write(*,*) 'Current directory    : ',trim(current_directory)
c
c     Writing out preprocessor information
c
#ifdef LINUX_INTEL
      write(*,*) 'Compiled on          : Linux (Intel Fortran)'
#endif
#ifdef LINUX_PGI
      write(*,*) 'Compiled on          : Linux (PGI)'
#endif
#ifdef IBM
      write(*,*) 'Compiled on          : IBM (xlf)'
#endif
      
#ifdef OPENMP
      write(*,*) 'Compiled             : with OpenMP'
#else 
      write(*,*) 'Compiled             : without OpenMP'
#endif
#ifdef MPI
      write(*,*) 'Compiled             : with MPI'
#else 
      write(*,*) 'Compiled             : without MPI'
#endif

      call fft_identify(fftstring)
      write(*,*) 'Linked FFT package   : ',fftstring

      write(*,*) 'Compiled for         :',nproc,  ' MPI processors'
      write(*,*) '                      ',nthread,' OMP threads'
      write(*,*) 'Running on           :',all_nodes_world,
     &     ' MPI processors'
      write(*,*) '                      ',ompnthreads,' OMP threads'
      write(*,*) '                      ',ompnproc,
     &     ' OMP processors per node'

     
      include 'latest_revision'
      write(*,*)
      write(*,*)
      write(*,*) '>>>>>>  Parameters read from par.f <<<<<<<'
      write(*,*) '--------------------------------------------'//
     &           '-----------------------'
      write(*,*) '            nx,ny,nz : ',nx,ny,nz
      write(*,*) '      nfxd,nfyd,nfzd : ',nfxd,nfyd,nfzd
      write(*,*) '              nfzsym : ',nfzsym
      write(*,*) '             mby,mbz : ',mby,mbz
      write(*,*) '               nproc : ',nproc
      write(*,*) '              nprocx : ',nprocx
      write(*,*) '              nprocz : ',nprocz
      write(*,*) '             nthread : ',nthread
      write(*,*) '         nxys,nxysth : ',nxys,nxysth
      write(*,*) '    mcorr,mser,msamp : ',mcorr,mser,msamp
      write(*,*) '            pressure : ',pressure
      write(*,*) '              scalar : ',scalar
      write(*,*) '                osnf : ',osnf
      write(*,*) '                mbla : ',mbla
      write(*,*) '         nxp,nyp,nzp : ',nxp,nyp,nzp
      write(*,*) '        nzc,nzd,nzpc : ',nzc,nzd,nzpc
      write(*,*) '             nzd_new : ',nzd_new
      write(*,*) '           nzat,nzst : ',nzat,nzst
      write(*,*) '             nby,nbz : ',nby,nbz
      write(*,*) '   memnx,memny,memnz : ',memnx,memny,memnz
      write(*,*) '             memnxyz : ',memnxyz
      write(*,*) '         mbox2,mbox3 : ',mbox2,mbox3
c
c     Make runtime check of parameters
c
      end = .false.
      end = (nfxd.ne.0.and.nfxd.ne.1).or.
     &      (nfyd.ne.0.and.nfyd.ne.1).or.
     &      (nfzd.ne.0.and.nfzd.ne.1).or.
     &      (nfzsym.ne.0.and.nfzsym.ne.1)
      if (end) then 
         write(*,*)'par.f: nfxd, nfyd, nfzd, nfzsym must be 1 or 0'
      end if
      if (mby.lt.1.or.mbz.lt.1.or.nproc.lt.1) then
         write(*,*)'par.f: mby, mbz, nproc must be bigger than 0.'
         end=.true.
      end if
      if (mod(nzc,mbz).ne.0) then
         write(*,*) 'par.f: nzc must divisible by mbz'
         end=.true.
      end if
      if (nz.eq.1.and.nfzd.eq.1) then
         write(*,*) 'par.f: z-dealiazing for 2-d grid is ignored.'
      end if
      if (nz.eq.1.and.nfzsym.eq.1) then
         write(*,*) 'par.f: Do not use z-symmetry for 2-d grid'
         write(*,*) 'par.f: Set nfzsym=0 in par.f and recompile'
         end=.true.
      end if
      if (nz.gt.1) then
         call cnxtmp(ntmp,0.,0.,nz,nfzd+nfzsym)
         if (ntmp.ne.nz) then
            if (nfzsym.eq.1.and.nfzd.eq.1) then
               write(*,*) 'par.f: As nfzsym=1 and nfzd=1'
               write(*,*) 
     &              'nz must divisible by 8 and factorable by 2,3 and 5'
            elseif (nfzsym.eq.1) then
               write(*,*) 'par.f: As nfzsym=1'
               write(*,*) 
     &              'nz must divisible by 4 and factorable by 2,3 and 5'
            elseif (nfzd.eq.1) then
               write(*,*) 'par.f: As nfzd=1'
               write(*,*) 
     &              'nz must divisible by 4 and factorable by 2,3 and 5'
            else
               write(*,*) 
     &              'nz must divisible by 2 and factorable by 2,3 and 5'
            end if
            write(*,*) 'Closest possible nz is',ntmp
            end=.true.
         end if
      end if
      call cnxtmp(ntmp,0.,0.,nx,nfxd)
      if (ntmp.ne.nx) then
         write(*,*) 'par.f: nx must be even and factorable by 2,3 and 5'
         write(*,*) 'Closest possible nx is',ntmp
         end=.true.
      end if
      call cnxtmp(ntmp,0.,0.,ny-1,nfyd)
      if (ntmp.ne.ny-1) then
         write(*,*) 'par.f: ny-1 must be even and '
         write(*,*) 'factorable by 2,3 and 5'
         write(*,*) 'Closest possible ny-1 is',ntmp
         end=.true.
      end if
      if (mod(nx,2+2*nfxd).ne.0.or.mod(ny-1,2+2*nfyd).ne.0) then
         write(*,*)
     &        'par.f: nx or ny-1 must be divisible '
         write(*,*) 'by 2+2*nfxd or 2+2*nfyd.'
         end=.true.
      end if
      
      if (mod(nx/2,nprocx).ne.0) then
         write(*,*) 'par.f: nx/2 must be a multiple of nprocx.'
         end=.true.
      end if
      if (mod(nz,nprocz).ne.0) then
         write(*,*) 'par.f: nz must be a multiple of nprocz.'
         end=.true.
      end if
c
c     The present implementation does not allow for
c     boxes with size greater than 1. This can however be fixed for
c     runs on vector machines.
c
      if (mby.ne.1) then
         write(*,*) 'par.f: mby must be 1.'
         end=.true.
      end if
      if (mbz.ne.1) then
         write(*,*) 'par.f: mbz must be 1.'
         end=.true.
      end if

      if (scalar.lt.0) then
         write(*,*) 'par.f: scalar must be positive.'
         end=.true.
      end if
      if (pressure.lt.0.or.pressure.gt.1) then
         write(*,*) 'par.f: pressure must be 1 or 0'
         end=.true.
      end if
      if (nfzsym.ne.0) then
         write(*,*) 'par.f: Symmetry not tested yet (nfzsym.ne.0)'
         end=.true.
      end if

      if (nproc.ne.all_nodes_world) then
         write(*,*) 'par.f: Mismatch nproc in par.f and MPI nodes:'
         write(*,*) 'Compiled for : ',nproc,' MPI processors'
         write(*,*) 'Running on   : ',all_nodes_world,' MPI processors'
         end = .true.
      end if

      if (nthread.lt.ompnthreads) then
         write(*,*) 'par.f: Increase nthreads:'
         write(*,*) 'Compiler for max.: ',nthread,' OMP threads'
         write(*,*) 'Running on       : ',ompnthreads,' OMP threads'
         end = .true.
      end if


      stop_now = 0
      if (end) then
         stop_now = 1
      end if
      
 9999 continue

#ifdef MPI
c     
c     Communicate break criterion
c     
      if (nproc.gt.1) then
         call mpi_bcast(stop_now,1,mpi_integer4,0,mpi_comm_world,
     &        ierror)
      end if
#endif
      if (stop_now.eq.1) then 
         call stopnow(3)
      end if

      end subroutine ppar
