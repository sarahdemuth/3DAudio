<CsoundSynthesizer>

<CsOptions>
--env:SSDIR+=../SourceMaterials
-odac
--opcode-lib=serialOpcodes.dylib 
</CsOptions>


<CsInstruments>

sr 	= 	44100
nchnls 	= 	1	
ksmps = 700 

instr 1
	
	kSpeed  init     1  
	
	iPort	serialBegin	"/COM3", 9600
	kVal	serialRead 	iPort

			printk2  	 kVal
			prints "Hi Sarah!"
		
		
	if (kVal == 1) then
		
		a1      diskin  "dish.wav", kSpeed
        		out      a1    
        		     
	elseif (kVal == 3) then
		
		a1      diskin  "loop.wav", kSpeed
        		out      a1         ; send audio to outputs
    endif
    
  endin

</CsInstruments>
<CsScore>
i 1 0 3600
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
