<CsoundSynthesizer>
<CsOptions> 
--env:SSDIR+=3DAudioSounds
-odac
</CsOptions>
<CsInstruments>
;Hey.
#include "ambisonics2D_udos.txt"

sr      =  44100
ksmps   =  500
nchnls  =  2

; Faked Kinect Azimuth values
giKinectAzimuth ftgen 0, 0, 10, -2, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90

; Faked Kinect Distance values
giKinectDistance ftgen 0, 0, 10, -2, 4, 2, 1, 1/2, 1/4, 1/8, 1/16, 1/32, 1/64, 1/128

; This code was taken from somewhere online
opcode	ambi2D_enc_dist_n, k, aikk		
	asnd,iorder,kaz,kdist	xin
	kaz 	= $M_PI*kaz/180
	kaz		= (kdist < 0 ? kaz + $M_PI : kaz)
	kdist 	= abs(kdist)+0.0001
	kgainW	= taninv(kdist*1.5707963) / (kdist*1.5708)
	kgainHO = (1 - exp(-kdist)) *kgainW
	kk 		= iorder
	asndW	= kgainW*asnd
	asndHO	= kgainHO*asndW

	c1:
   	zawm	cos(kk*kaz)*asndHO,2*kk-1
	zawm	sin(kk*kaz)*asndHO,2*kk
	kk -= 1

	if	kk > 0 goto c1
	
	zawm	asndW,0	
	xout	0
endop

instr 1 ; "Helper" sound
	iDistance 	init 4  ; When user enters the room, Puzzle 1 is 4' from user.
	iAzimuth 	init 45 ; When user enters the room, Puzzle 1 is 45 deg CCW from user.
	iIndex     	init 0	; Start at the 0th item in the table

	loop:

	asnd		rand 1
	asnd, a0	soundin	"heyyoucomeoverhere.wav"

	timout    0, 4, play
	reinit    loop

	play:

	iAzimuth 	table iIndex, giKinectAzimuth
	iDistance 	table iIndex, giKinectDistance
	iDistance = iDistance * 10

	;kAzimuth   line	iAzimuth,   3, iAzimuth  ; Sound source turns iazimuth degrees in 10s.
	;kDistance	line	iDistance,  3, iDistance ; Sound source moves from id1' --> id2' from user in 10s.	
	k0 ambi2D_enc_dist_n asnd, 2, iAzimuth, iDistance

	iIndex += 1 ; Increment the position in the table
endin ; "Helper" Sound


instr 2 ; "Horror" Sounds
	kSpeed  init	1
	iSkip   init	0
	iLoop   init	1
	      
	aLeft, aRight 	diskin "horrorsounds.wav", kSpeed, iSkip, iLoop
	
	aLeft	*= 0.3
	aRight	*= 0.3
	outs	aLeft, aRight 
endin ; "Horror" Sounds


zakinit 17, 1 ; TODO: Figure out what this does
instr 10
	aLeft, aRight	ambi2D_decode	1,0,0
	outs	aLeft, aRight
	zacl 	0,16		
endin
</CsInstruments>

<CsScore>
f1 0 32768 10 1

i1	0 38
i2  0 38
i10 0 38
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
