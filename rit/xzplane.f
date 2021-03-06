c ***********************************************************************
c
c $HeadURL: https://www.mech.kth.se/svn/simson/trunk/rit/xzplane.f $
c $LastChangedDate: 2011-01-27 17:04:51 +0100 (Thu, 27 Jan 2011) $
c $LastChangedBy: pschlatt@MECH.KTH.SE $
c $LastChangedRevision: 1642 $
c
c ***********************************************************************
      subroutine xzplane(plane,mx,mz,mxs,mzs,grid,y,jvar,sym,
     &xr,xl,zl,mxr,w,ur,prex,prez)
c
c     Cuts a plane and calculates a grid in the xz-plane
c     possibly with subsampling
c
      implicit none

      include 'par.f'

      integer mx,mz,mxs,mzs,jvar,y,mxr
      real plane(mx,mz),grid(mx,mz,2),xr,xl,zl
      real pxz(nx+2,nz),w(nx+2,nz)
      complex ur(memnx,memny,memnz,4)
      real prex(nx+15),prez(nz*2+15)
      real sym
c
      integer z,zp,x,xp,xpr
      call getxzp(pxz,y,jvar,ur,sym)
      call vcfftb(pxz,pxz(2,1),w,w(2,1),nz,nx/2,nx+2,2,prez)
      call vrfftb(pxz,pxz(2,1),w,w(2,1),nx,nz,2,nx+2,prex)
      do zp=1,nz,mzs
         z=(zp-1)/mzs+1
         do xp=1,nx,mxs
            xpr=mod(10*nx+xp+mxr-1,nx)+1
            x=(xp-1)/mxs+1
            plane(x,z)=pxz(xpr,zp)
         end do
c
c     Extend periodically in the x-direction
c
         plane(nx/mxs+1,z)=plane(1,z)
      end do
      do x=1,mx+1
         plane(x,mz)=plane(x,1)
      end do
c
c     Make grid
c
      do zp=1,nz+mzs,mzs
         z=(zp-1)/mxs+1
         do xp=1,nx+mxs,mxs
            x=(xp-1)/mxs+1
            grid(x,z,1)=real(xp-nx/2-1)/real(nx)*xl+xr
            grid(x,z,2)=real(2*zp-nz-2)/real(2*nz)*zl
         end do
      end do

      open(unit=29,file='pianoxz.dat')
      do zp=1,nz+1
         do xp=1,nx+1
            write(29,2200)grid(xp,zp,1),grid(xp,zp,2),plane(xp,zp)
         end do
      end do

 2200 format(f18.10,f18.10,'  ',e18.12)
      close(29)

      end subroutine xzplane
