c -*-Fortran-*-

      integer NMXHEP,NEVHEP,NHEP,ISTHEP,IDHEP,
     &     JMOHEP,JDAHEP,
     $     ihiggs
      double precision phep,vhep
      PARAMETER (NMXHEP=4000)
      COMMON/HEPEVT/NEVHEP,NHEP,ISTHEP(NMXHEP),IDHEP(NMXHEP),
     &   JMOHEP(2,NMXHEP),JDAHEP(2,NMXHEP),PHEP(5,NMXHEP),VHEP(4,NMXHEP),
     $   ihiggs
      save /HEPEVT/
