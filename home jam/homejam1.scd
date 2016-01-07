(
// mutable band pass filter Sawtooth wave
// spatialization, making synth stereo
// multichanel expansion of each noise generator
SynthDef(\bpfsaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2,
	cfmin=500, cfmax=2000, cfhzmin=0.1, cfhzmax=0.3,
	rqmin=0.1, rqmax=0.2,
	lsf=200, ldb=0,
	amp=1, out=0, pan=0;

	var sig, env;

	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]), doneAction:2);

	sig = Saw.ar(freq * {LFNoise1.kr(0.5, detune).midiratio}!2);

	sig = BPF.ar(sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)
		).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);

	sig = BLowShelf.ar(sig, lsf, 0.5, ldb);

	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\sawBeat , {
	arg atk=1, sus=0, rel=0.5, freq=220,
	amp = 0.6, out=0, pan=0, detune = 0;
	var sig, env;

	env = EnvGen.kr(Env([0,1,1,0], [atk,sus,rel], [1,-1]), doneAction:2);

	sig = Saw.ar(freq * {LFNoise1.kr(0.5, detune).midiratio});

	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\sawBeat , {
	arg atk=1, sus=0, rel=0.5, freq=220,
	amp = 0.6, out=0, pan=0, rezfreq=260;
	var sig, env;

	env = EnvGen.kr(Env([0,1,1,0], [atk,sus,rel], \exp), doneAction:2);

	sig = Saw.ar(freq);

	sig = Resonz.ar(sig, rezfreq, 1);

	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(out, sig);
}).add;
)

(
~beating = Pbind(
	\instrument, \sawBeat,
	\dur, 0.5,
	\midinote, Pseq([
		[48, 50, 52],
		[51, 53, 55]
	], inf),
	\rezfreq, Pexprand(100, 500, inf),
	\atk, 0.1,
	\rel, 0.2,
	\detune, 0.8,
	\amp, 0.3,
	\out, 0
).play;
)

~beating.stop;




(
SynthDef.new(\sine, {
	arg freq = 440, atk = 0.005, rel=0.3, amp = 0.5, pan = 0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk, rel], [1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0,sig);
}).add;
)

(
a = Pbind( // Pbind generates event
	\type, \note, // default event type
	\instrument, \sawBeat,
	\dur, Pwhite(0.05, 0.1, inf),  // Pwhite generates random number with linear distribution
	\midinote, Pxrand([60,72,84], inf),  // Pexprand generate random number exponentially
	\atk, Pwhite(0.1,0.3, inf),  // longer synths
	\rel, Pwhite(1.0,3.0, inf), // longer synths
	\amp, Pexprand(0.01,0.3, inf),  // keep amp low bc of multiple synths, but allow for variations
	\pan, Pwhite( -0.8, 0.8, inf),  // pan the stereo field without going too far left or right
).play;
)

(
b = Pbind( // Pbind generates event
	\type, \note, // default event type
	\instrument, \sawBeat,
	\dur, Pwhite(0.05, 0.1, inf),  // Pwhite generates random number with linear distribution
	\freq, Pexprand(50,4000, inf),  // Pexprand generate random number exponentially
	\atk, Pwhite(2.0,3.0, inf),  // longer synths
	\rel, Pwhite(5.0,10.0, inf), // longer synths
	\amp, Pexprand(0.01,0.5, inf),  // keep amp low bc of multiple synths, but allow for variations
	\pan, Pwhite( -0.8, 0.8, inf),  // pan the stereo field without going too far left or right
).play;
)
