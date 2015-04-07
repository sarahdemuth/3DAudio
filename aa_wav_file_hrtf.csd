<CsoundSynthesizer>

<CsOptions>
--env:SSDIR+=3DAudioSounds
-odac
</CsOptions>
<CsInstruments>
;Example by Iain McCurdy

sr = 44100
ksmps = 32
nchnls = 2

#define DEST #"/kinect"#
; Use controller number 7 for volume
#define VOL #7#

; Set this to 1 if you're using the Kinect, 0 if not
giUseKinect = 0;

; Skip the OSC intialization if we're not using the Kinect
if(giUseKinect == 0) goto skipOSC
gilisten  OSCinit   7000

gisin	ftgen     1, 0, 16384, 10, 1
givel	ftgen     2, 0, 128, -2, 0
gicc	ftgen     3, 0, 128, -7, 100, 128, 100  ;Default all controllers to 100
								
								;Define scale tuning
giji_12   ftgen     202, 0, 32, -2, 12, 2, 256, 60, 1, 16/15, 9/8, 6/5, 5/4, 4/3, 7/5, \
                               3/2, 8/5, 5/3, 9/5, 15/8, 2

skipOSC:                         	
gkAzimuth	init	0
gkDistance	init    0
gkSwitch	init    0
giIndex		init	0

giKinectAzimuth ftgen 0,0,12,-2, 0, 0, 90, 180, -90, 0, 90, 180, -90, 0, 90, 180
								;0, 0, 90, 180, -90, 0, 90, 180, -90, 0, 90, 180
								;F, F, L, Bck,  R,   F, L,  Bck, R,   F, L,  Bck
								;0,  4,  8,  12, 16,  20,24,  28
								;Note:  Front sounds like it is coming from the Right.
								
giKinectDistance ftgen 0, 0, 12, -2, 2, 2, 1, 1, 1/2, 1/2, 1/4, 1/4, 1, 1, 1/2, 1/2

instr 1
  	loop:
	asnd		rand 1
	asnd, a0	soundin	"heyyoucomeoverhere.wav"

	timout    0, 2, play
	reinit    loop

	play:

	aLeft, aRight  hrtfmove2   asnd, gkAzimuth, 0, "hrtf-44100-left.dat","hrtf-44100-right.dat"

	aDistanceConstant = 3;
	aLeft	/= aDistanceConstant * gkDistance
	aRight	/= aDistanceConstant * gkDistance

	kroomsize    init      0.1			; room size (range 0 to 1)
	kHFDamp      init      0.2          ; high freq. damping (range 0 to 1)
	
	kroomsize = (gkDistance * gkDistance) / 2;
	
	aRvbL,aRvbR  freeverb  aLeft, aRight, kroomsize, kHFDamp
    outs      aRvbL, aRvbR 
endin

instr 1001   ;Necessary for reading in OSC
	if(giUseKinect == 0) goto skipOSCRead
	icps	init      p4
	kvol	table     $VOL, gicc  ;Read MIDI volume from controller table
	kvol =  kvol/127

	aenv     linsegr    0, .003, p5, 0.03, p5 * 0.5, 0.3, 0
	aosc	 oscil     aenv, icps, gisin
	out	      aosc * kvol
	skipOSCRead:
endin

instr 2
	loop:
	if(giUseKinect == 1) goto kinect 
	
	gkAzimuth 	table giIndex, giKinectAzimuth
	gkDistance 	table giIndex, giKinectDistance
	;iDistance = iDistance * 4
	
	giIndex += 1
	timout    0, 2, play
	reinit    loop
	
	goto play

	kinect:
	kk	    OSClisten	gilisten, $DEST, "fff", gkAzimuth, gkDistance, gkSwitch
	timout    0, 2, play
	reinit    loop
	play:
endin

</CsInstruments>

<CsScore>
i 1 0 2000
i 2 0 2000

e
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
