c ***********************************************************************
c
c $HeadURL: https://www.mech.kth.se/svn/simson/trunk/rps/frecl.f $
c $LastChangedDate: 2006-11-19 23:43:46 +0100 (Sun, 19 Nov 2006) $
c $LastChangedBy: mattias@MECH.KTH.SE $
c $LastChangedRevision: 342 $
c
c ***********************************************************************
      subroutine frecl(dabyte,darecl)
c
c     Find the record length to accomodate dabyte bytes
c
      implicit none

      integer dabyte,darecl

      integer ilen
      character*1 btst16(16),btst32(32),btst64(64)
c
c     Find number of bytes per unit in recl specifier
c
      open(unit=29,status='scratch',form='unformatted',
     &     access='direct',recl=8)
      ilen=1
      write(29,rec=1,err=1000) btst16
      ilen=2
      write(29,rec=1,err=1000) btst32
      ilen=4
      write(29,rec=1,err=1000) btst64
      ilen=8
 1000 close(29)
c
c     Calculate darecl to host dabyte bytes
c
      darecl=(dabyte+ilen-1)/ilen

      return

      end subroutine frecl
