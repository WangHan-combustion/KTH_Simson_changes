c ***********************************************************************
c
c $HeadURL: https://www.mech.kth.se/svn/simson/trunk/bla/getxy.f $
c $LastChangedDate: 2007-11-12 13:19:01 +0100 (Mon, 12 Nov 2007) $
c $LastChangedBy: mattias@MECH.KTH.SE $
c $LastChangedRevision: 850 $
c
c ***********************************************************************
      subroutine getxy(boxr,boxi,zb,i,ur,ui)
c
c     Get an xy box from ur
c
c     size of xy box:  nx/2 * mbz * nyp (real and imaginary part)
c
      implicit none

      include 'par.f'

      integer zb,i
      real boxr(nx/2,mbz,nyp),boxi(nx/2,mbz,nyp)
      real ur(memnx,memny,memnz,memnxyz),ui(memnx,memny,memnz,memnxyz)

      integer x,y,z

      if (mbz.eq.1) then
         do y=1,nyp
            do x=1,nx/2
               boxr(x,1,y)=ur(x,y,zb,i)
               boxi(x,1,y)=ui(x,y,zb,i)
            end do
         end do
      else
         do z=zb,zb+mbz-1
            do y=1,nyp
               do x=1,nx/2
                  boxr(x,z-zb+1,y)=ur(x,y,z,i)
                  boxi(x,z-zb+1,y)=ui(x,y,z,i)
               end do
            end do
         end do
      end if

      end subroutine getxy
