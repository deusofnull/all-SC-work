{Saw.ar(EnvGen.ar(Env([150,200,80],[1,1,0],doneAction:2)),0.1)}.play;

// SynthDef is used to store a synth in the uGen memory.
SynthDef(\sine, {Out.ar(0,SinOsc.ar(Rand(440,880),0,0.1))}).add;

//plan an anonymous \sine
Synth(\sine);

//play a named \sine, allowing for control
a=Synth(\sine);
a.free;

//adding arguments to a SynthDef

SynthDef(\sine_arg, {arg freq=440, amp=0.1; Out.ar(0,SinOsc.ar(freq,0,amp))}).add;

b=Synth(\sine_arg);
c=Synth(\sine_arg, [\freq,550, \amp,0.1]);
c.free;
b.free;

// As an exercise of this knowledge, I am going to create a single octave Chromatic scale synth
/* C4 Chromatic
C C# D D# E F F# G G# A A# B C
C4: 261.63
C#4: 277.18
D4: 293.66
D#4: 311.13
E4 329.63
F4: 349.23
F#4: 369.99
G4: 392.00
G#4: 415.30
A4: 440.00
A#4: 466.16
B4: 493.88
C5: 523.25
*/

{SinOsc.ar(EnvGen.ar(Env([261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88, 523.25], [.25]),doneAction:2),0,0.1)}.play


{Saw.ar(EnvGen.ar(Env([100,220],[0.5]),doneAction:2), EnvGen.ar(Env([0.1,0.1,0]


SynthDef(\sine_arg, {arg freq=440, amp=0.1, phase=0.0; Out.ar(0,SinOsc.ar(freq,phase,amp))}).add;

	a=Synth(\sine_arg, [\freq, 230, \amp, 0.1, \phase, 0.5]);
	a.set(\phase,5);
	a.set(\freq,293);
	a.set(\freq,329);
	a.set(\freq,260);
