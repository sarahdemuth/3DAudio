<CsoundSynthesizer>

<CsOptions>
--env:SSDIR+= "C:/Users/Sarah DeMuth/Documents/GitHub/3DAudio"
-odac ;activates real time sound output
</CsOptions>

<CsInstruments>
;Example by Iain McCurdy

sr = 44100
ksmps = 32
nchnls = 2

  instr 1
kSpeed  init     1      ; playback speed
iSkip   init     0        ; inskip into file (in seconds)
iLoop   init      1       ; looping switch (0=off 1=on)
; read audio from disk using diskin2 opcode
a1,a2    diskin  "heyyoucomeoverhere.wav", kSpeed, iSkip, iLoop
        

; apply binaural 3d processing
kAz            linseg      90, 1, 180 ; break point envelope defines azimuth (one complete circle)
;kAz          linseg      0, 60,   0
kElev          linseg      0, 80,   0; break point envelope defines elevation (held horizontal for 8 seconds then up then down then back to horizontal
aLeft, aRight  hrtfmove2   a1, kAz, kElev, "hrtf-44100-left.dat","hrtf-44100-right.dat"; apply hrtfmove2 opcode to audio source - create stereo ouput
               outs        aLeft, aRight; audio sent to outputs
endin

</CsInstruments>

<CsScore>
i 1 0 80; instr 1 plays a note for 60 seconds
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
