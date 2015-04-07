<CsoundSynthesizer>

<CsOptions>
--env:SSDIR+= "C:/Users/Sarah DeMuth/Documents/GitHub/3DAudio/3DAudioSounds"
-odac ;activates real time sound output
</CsOptions>

<CsInstruments>
;Example by Iain McCurdy

sr = 44100
ksmps = 32
nchnls = 2

giKinectAzimuth ftgen 0,0,10,-2, 0, 0, 90, -90, 90, 0, 90, -90, 90, -90
								;90, 180, -90, 0, 90, 180, -90, 0, 90, 180
								;R, Bck, L, Frnt, R, Bck, L, Frnt
								;0,  4,  8,  12, 16,  20,24,  28
								;Note:  Front sounds like it is coming from the Right.
								
giKinectDistance ftgen 0, 0, 10, -2, 1/2, 1/2, 1/4, 1/8, 1/16, 1/32, 1/64, 1/128


instr 1
 	iDistance 	init 4  
	iAzimuth 	init 45 
	iIndex     	init 0
  
  	loop:

	asnd		rand 1
	asnd, a0	soundin	"heyyoucomeoverhere.wav"

	timout    0, 2, play
	reinit    loop

	play:

	iAzimuth 	table iIndex, giKinectAzimuth
	iDistance 	table iIndex, giKinectDistance
	iDistance = iDistance * 4

	iIndex += 1 
       
kAz            linseg      iAzimuth, 2, iAzimuth 
kElev          linseg      0, 80,   0

aLeft, aRight  hrtfmove2   asnd, kAz, kElev, "hrtf-44100-left.dat","hrtf-44100-right.dat"

	aLeft	*= iDistance
	aRight	*= iDistance

kroomsize    init      0.1        ; room size (range 0 to 1)
kHFDamp      init      0.2          ; high freq. damping (range 0 to 1)
aRvbL,aRvbR  freeverb  aLeft, aRight, kroomsize, kHFDamp
             outs      aRvbL, aRvbR 
          
  endin


</CsInstruments>

<CsScore>
i 1 0 80

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
