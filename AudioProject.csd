<CsoundSynthesizer>
<CsOptions>
--env:INCDIR+=../SourceMaterials 
--env:SSDIR+=../SourceMaterials/3DAudioSounds
-o C:/3DAudioSounds/TheTestSampleAudio.wav
</CsOptions>
<CsInstruments>

sr      =  44100
ksmps   =  500
nchnls  =  2

;Kinect input: azimuth
giFt2 ftgen 2, 0, -20, -2, 0,90,180,270,360
;Kinect input: distance
giFt3 ftgen 3, 0, -20, -2, 1,1,1,1,1

;4,4,4.5,5,5,4.5,4.25,4.25,4,3.5,3,2.75,2.5,2.25,2.25,2,1.5,1.25,1,1

#include "ambisonics2D_udos.txt"

; distance encoding
; with any distance (includes zero and negative distance)



opcode	ambi2D_enc_dist_n, k, aikk		
asnd,iorder,kaz,kdist	xin
kaz = $M_PI*kaz/180
kaz	=			(kdist < 0 ? kaz + $M_PI : kaz)
kdist =		abs(kdist)+0.0001
kgainW	=		taninv(kdist*1.5707963) / (kdist*1.5708)
kgainHO =	(1 - exp(-kdist)) *kgainW
kk =	iorder
asndW	=	kgainW*asnd
asndHO	=	kgainHO*asndW
c1:
   	zawm	cos(kk*kaz)*asndHO,2*kk-1
   	zawm	sin(kk*kaz)*asndHO,2*kk
kk =		kk-1

if	kk > 0 goto c1
	zawm	asndW,0	
	xout	0
endop



zakinit 17, 1		



instr 1


;This program starts when we press "run".
;First, it reads Kinect azimuth and distance, to lead user to Puzzle 1.

id init 4  ;When user enters the room, Puzzle 1 is 4' from user.
iaz init 45  ;When user enters the room, Puzzle 1 is 45 deg CCW from user.
indx      init      0
idistance init 5
iazimuth init 45

loop:

 ;if (idistance >=1 && iazimuth != 0)  then

asnd	rand		1
asnd, a0	soundin	"heyyoucomeoverhere.wav"

		timout    0, 4, play
        reinit    loop
        
play:

ival      table     indx, 2
iazimuth = ival   ;*3.14/180
ival      table     indx, 3
idistance = ival*10;(4^ival)
;If the following are met, that means the user arrived at Puzzle 1...
;...we goto a different function, because the user no longer needs localization help.
;if	(iazimuth == 0 && idistance <= 1) goto c1
;Otherwise continue to make sound based on user's coordinates from Kinect.

iaz1 = iaz
iaz2 = iazimuth 
iaz = iazimuth
id1 = id
id2 = idistance 
id = idistance
kaz   	line		iaz2,3,iaz2  ;Sound source turns iazimuth degrees in 10s.
kdist	line		id2,3,id2  ;Sound source moves from id1' --> id2' from	user in 10s.	
k0		ambi2D_enc_dist_n		asnd,2,kaz,kdist

indx = indx + 1   

;endif

endin

instr 2

kSpeed  init     1     
iSkip   init     0       
iLoop   init     1        
a1 ,a2     diskin  "horrorsounds.wav", kSpeed  , iSkip, iLoop
asig1 = a1*0.3
asig2 = a2*0.3
        outs      asig1, asig2 
endin


instr 10		
a1,a2 		ambi2D_decode		1,0,0
		outs	a1,a2
		zacl 	0,16		
endin



</CsInstruments>
<CsScore>
f1 0 32768 10 1

i1	0 38
i10 0 38
i2  0 38
</CsScore>
</CsoundSynthesizer>



<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
