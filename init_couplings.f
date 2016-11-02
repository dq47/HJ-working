      subroutine init_couplings
      implicit none
      include "coupl.inc"
      include "pwhg_flg.h"
c Avoid multiple calls to this subroutine. The parameter file is opened
c but never closed ...
      logical called
      data called/.false./
      save called
      if(called) then
         return
      else
         called=.true.
      endif

      flg_processid='HJ'

*********************************************************
***********         MADGRAPH                 ************
*********************************************************
c Parameters are read from the MadGraph param_card.dat,
c except the strong coupling constant, which is defined
c somewhere else
      call setpara("param_card.dat",.true.)
c Are these needed?
c$$$      physpar_ml(1)=0.511d-3
c$$$      physpar_ml(2)=0.1057d0
c$$$      physpar_ml(3)=1.777d0
c$$$      physpar_mq(1)=0.33d0     ! up
c$$$      physpar_mq(2)=0.33d0     ! down
c$$$      physpar_mq(3)=0.50d0     ! strange
c$$$      physpar_mq(4)=1.50d0     ! charm
c$$$      physpar_mq(5)=4.80d0     ! bottom
      call madtophys

*********************************************************
***********           MCFM                   ************
*********************************************************
      call i2MCFM_2_POWHEG_IP
!--- Initialise coupling 
      call mcfm_coupling

      call init_couplings_tm

      end


      subroutine lh_readin(param_name)
c overrides the lh_readin subroutine in MODEL/couplings.f;
c to make it work, rename or delete
c the lh_readin routine in MODEL/couplings.f
      implicit none
      character*(*) param_name
      include 'coupl.inc'
      double precision  Two, Four, Rt2, Pi
      parameter( Two = 2.0d0, Four = 4.0d0 )
      parameter( Rt2   = 1.414213562d0 )
      parameter( Pi = 3.14159265358979323846d0 )
      double precision  alpha, gfermi, alfas
      double precision  mtMS,mbMS,mcMS,mtaMS!MSbar masses
      double precision  Vud,Vus             !CKM matrix elements
      common/values/    alpha,gfermi,alfas,   
     &                  mtMS,mbMS,mcMS,mtaMS,
     &                  Vud
      real * 8 powheginput
c the only parameters relevant for this process are set
c via powheginput. All others are needed for the
c madgraph routines not to blow.
      alpha=1/128.9d0
C       alpha=1/1.32506980d+02    ! DQ - commented this out - PDG says alpha(Mz) ~ 1/128 
C       gfermi = 1.16639000d-05   ! I can't find anything more accurate for the moment but I'll keep looking
      gfermi = 1.1663787000d-05 ! DQ - from PDG
!       alfas = 0.119d0
      alfas = 0.11800021884307436 ! DQ - as(Mz) as output by the NNPDF30_nnlo_as_118 PDF set we are using
!       zmass = 9.11880000d+01
		zmass = 9.11876000d+01 ! DQ - value from LHCHXSWG (PDG)
!      tmass = 1.74300000d+02
		tmass = 1.72500000d+02 ! DQ - value from LHCHXSWG (PDG)
      lmass = 0d0
      mcMS = 0d0
      mbMS = 0d0
C       mtMS = 174d0
      mtMAS = 162.7d0 ! DQ - value from LHCHXSWG (PDG)
      mtaMS = 1.777d0
      vud = 1d0
      cmass = 0d0
      bmass = 0d0
      lmass=0d0
      hmass = powheginput('hmass')
C       wmass=sqrt(zmass**2/Two+
C      $     sqrt(zmass**4/Four-Pi/Rt2*alpha/gfermi*zmass**2))
C       wmass=8.04190000d+01
      wmass =80.3850000d+00 ! DQ - value from LHCHXSWG (PDG)
      twidth=1.50833649d+00
      hwidth = powheginput('hwidth')
C       zwidth=2.44140351d+00
      zwidth=2.49520000d+00 ! DQ - value from LHCHXSWG (PDG)
!      wwidth=2.04759951d+00
		wwidth=2.08500000d+00 ! DQ - value from LHCHXSWG (PDG)
      end

      subroutine set_ebe_couplings
      implicit none
      include 'pwhg_st.h'
      include 'pwhg_math.h'
      include "coupl.inc"
c QCD coupling constant
      G=sqrt(st_alpha*4d0*pi)
      GG(1)=-G
      GG(2)=-G

c HEFT coupling
      gh(1) = dcmplx( g**2/4d0/PI/(3d0*PI*V), 0d0)
      gh(2) = dcmplx( 0d0                   , 0d0)
      ga(1) = dcmplx( 0d0                   , 0d0)
      ga(2) = dcmplx( g**2/4d0/PI/(2d0*PI*V), 0d0)
      gh4(1) = G*gh(1)
      gh4(2) = G*gh(2)
      ga4(1) = G*ga(1)
      ga4(2) = G*ga(2)

      return
      end


      subroutine madtophys
      implicit none
      include 'coupl.inc'
      include 'PhysPars.h'
      include 'pwhg_math.h'
      real * 8 e_em,g_weak
      e_em=gal(1)
      ph_alphaem=e_em**2/(4*pi)
      ph_sthw2=1-(wmass/zmass)**2
      ph_sthw=sqrt(ph_sthw2)
      g_weak=e_em/ph_sthw
      ph_gfermi=sqrt(2d0)*g_weak**2/(8*wmass**2)
      end
