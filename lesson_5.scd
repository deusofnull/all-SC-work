// Fat Chorus
var heya;

a = {arg freq= 100; Mix(LFSaw.ar([freq + 100,freq + 200,freq + 300],0.1))}.play;

a.set(\freq, 120);

a.set(\freq, 80);


b = {arg freq= 100; Mix(SinOsc.ar([freq + 100,freq + 200,freq + 300],0,Line.kr(0.1,0,1.0)))}.play;
b.set(\freq, 160);

h.free;

{SinOsc.ar(440,0,Line.kr(0.1,0,1,doneAction:2))}.play;
// simple ring modulation with chorus


(
{
	var carrier, modulator, carrfreq, modfreq;

	carrfreq = MouseX.kr(1,3000,'exponential');
	modfreq = MouseY.kr(1, 5200, 'exponential');

	carrier= Mix(LFSaw.ar([modfreq + 100,modfreq + 200,modfreq + 300],0.1));
	modulator= Mix(LFSaw.ar([modfreq + 100, modfreq + 200, modfreq + 300], 0.1));

	carrier*modulator;
}.scope
)

(
{
	var carrier, modulator, carrfreq, modfreq;

	carrfreq = MouseX.kr(100,3000,'exponential');
	modfreq = MouseY.kr(1, 5200, 'exponential');

	carrier= Mix(SinOsc.ar([modfreq + 100,modfreq + 200,modfreq + 300],0.1));
	modulator= Mix(SinOsc.ar([modfreq + 100, modfreq + 200, modfreq + 300], 0.1));

	carrier*modulator;
}.scope;
)
