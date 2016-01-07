s.boot;
s.quit;
s.reboot;
s.meter;
s.plotTree;
// server gui: volume control, recording, CPU usage
Server.default.makeGui;
// osciliscope
FreqScope.new;

(
// fixed band pass filter Sawtooth wave
SynthDef(\bpfsaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, cf=1500, rq=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]), doneAction:2);
	sig = Saw.ar(freq);
	sig = BPF.ar(sig, cf, rq);
	sig = sig * env * amp;

	Out.ar(out, sig);
}).add;
)

Env([0,1,1,0],[2,0,3],[1,0,-1]).plot;

// iteration over midinote numbers
(
[58,65,68,73].midicps.do{
	arg f;
	Synth(
		\bpfsaw,
		[
			\freq, f,
			\amp, 0.25,
			\cf, f * exprand(1,12),
			\rq, exprand(0.01, 0.5),
		]
	);
};
)

(
[40,45,48].midicps.do{
	arg f;
	Synth(
		\bpfsaw,
		[
			\freq, f,
			\amp, 0.25,
			\cf, f * exprand(1,12),
			\rq, exprand(0.01, 0.5),
		]
	);
};
)

// random over frequency
(
4.do{
	Synth(
		\bpfsaw,
		[
			\freq, exprand(100, 1000),
			\amp, 0.25,
			\cf, exprand(200,5000),
			\rq, exprand(0.01, 0.5),
		]
	);
};
)

Scale.major
Scale.minor
Scale.chromatic

// using the Scale Object to set frequency to a note from a natural minor scale starting at middle C, C60
(
(1..6).choose.do{  // play random number of synths between 1 and 6
	Synth(
		\bpfsaw,
		[
			\freq, (Scale.minor.degrees+60).midicps.choose,
			\amp, 0.25,
			\cf, exprand(200,5000),
			\rq, exprand(0.01, 0.5),
		]
	);
};
)


// Original \bpfsaw synth was static in its initial values throughout the duration of the synth
// Now we can create dynamic, controlled random changes to the synth's arguments


(
// mutable band pass filter Sawtooth wave
SynthDef(\bpfsaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]), doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5, detune).midiratio);
	sig = BPF.ar(sig,
		LFNoise1.kr(0.2).exprange(cfmin, cfmax),  // changing center frequency between cfmin..cfmax
		LFNoise1.kr(0.1).exprange(rqmin, rqmax)  // changing quality between rqmin.. rqmax
	);
	sig = sig * env * amp;

	Out.ar(out, sig);
}).add;
)

// high relative quality = more regular bpf saw synth,
(
30.do{
	Synth(\bpfsaw,
		[
			\freq, 4,
			\amp, 0.2,
			\atk, 5,
			\sus, 50,
			\cfmin, 100*2,
			\cfmax, 600*50,
			\rqmin, 0.08,
			\rqmax, 0.1
		],
	);
};
)

// low relative quality = less regular, more harmonic-wandering bpf saw synth

(
10.do{
	Synth(\bpfsaw,
		[
			\freq, 280,
			\amp, 1,
			\atk, 20,
			\sus, 50,
			\cfmin, 280*2,
			\cfmax, 280*50,
			\rqmin, 0.005,
			\rqmax, 0.03
		],
	);
};
)

(
// mutable band pass filter Sawtooth wave
// spatialization, making synth stereo
// multichanel expansion of each noise generator
SynthDef(\bpfsaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2,
	amp=1, out=0, pan=0;

	var sig, env;

	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]), doneAction:2);

	sig = Saw.ar(freq * {LFNoise1.kr(0.5, detune).midiratio}!2);
	sig = BPF.ar(sig,
		{LFNoise1.kr(0.2).exprange(cfmin, cfmax)}!2,  // changing center frequency between cfmin..cfmax
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2  // changing quality between rqmin.. rqmax
	);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

// wandering pan with multichannel noise generator expansion
(
10.do {
	Synth(\bpfsaw,
		[
			\freq, 840,
			\amp, 1,
			\atk, 4,
			\sus, 50,
			\cfmin, 350*2,
			\cfmax, 350*50,
			\rqmin, 0.005,
			\rqmax, 0.03,
			\pan, rrand(-1.0,1.0)  // 0 = center, 1 = right, -1 = left
		],
	);
};
)



// nested randomness!  control randomness with randomness!

// 8 changes per second in frequency between 200 and 800
a={SinOsc.ar(LFNoise0.kr(8).exprange(200,800), 0, 0.2!2)}.play;
// one level deeper, controlling the rate of change with another Noise Generator
b={SinOsc.ar(LFNoise0.kr(LFNoise0.kr(8).exprange(2,80)).exprange(1000,1500), 0, 0.2!2)}.play;




// nested randomness applied to the BPF SAW Synth's Center Frequency ============================
(
// mutable band pass filter Sawtooth wave
// spatialization, making synth stereo
// multichanel expansion of each noise generator
SynthDef(\bpfsaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
	freq=500, detune=0.2,
	cfmin=500, cfmax=2000, cfhzmin=0.1, cfhzmax=0.3,
	rqmin=0.1, rqmax=0.2,
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
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)
// nested randomness:
//    Changing the rate of change of the center frequency
(
2.do {
	Synth(\bpfsaw,
		[
			\freq, 390,
			\amp, 1,
			\atk, 10,
			\sus, 15,
			\rel, 5,
			\cfmin, 150*2,
			\cfmax, 300*50,
			\cfhzmin, 10,
			\cfhzmax, 15,
			\rqmin, 0.001,
			\rqmax, 0.05,
			\pan, 0  // 0 = center, 1 = right, -1 = left
		],
	);
};
)


// FINAL SYNTH, ready for composite musical gestures and technique
// adding a B Low shelf for low end amplification control

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

// a chord progression
(
Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pseq([   // each chord is its own array
		[23,35,54,63,64],
		[45,52,54,59,61,64],
		[28,40,47,56,59,63],
	],1),
	\detune, 0.08,
	\cfmin, 100,
	\cfmax, 1500,
	\atk, 2,
	\rel, 8,
	\ldb, 6,
	\amp, 0.2,
	\out, 0
).play;
)

// a random progression of a set of chords, no back to back repeats
(
~chords = Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pxrand([   // each chord is its own array
		[23,35,54,63,64],
		[45,52,54,59,61,64],
		[28,40,47,56,59,63],
		[42,52,57,61,63],
	],inf),
	\detune, 0.08,
	\cfmin, 100,
	\cfmax, 1500,
	\atk, 2,
	\rel, 8,
	\ldb, 6,
	\amp, 0.2,
	\out, 0
).play;
)

~chords.stop;


// using more variables for greater dynamics
(
~chords = Pbind(
	\instrument, \bpfsaw,
	\dur, Pwhite(4.5,7.0,inf),
	\midinote, Pxrand([   // each chord is its own array
		[23,35,54,63,64],
		[45,52,54,59,61,64],
		[28,40,47,56,59,63],
		[42,52,57,61,63],
	],inf),
	\detune, Pexprand(0.05,0.2,inf),
	\cfmin, 100,
	\cfmax, 1500,
	\rqmin, Pexprand(0.8,0.95,inf),
	\rqmax, Pexprand(0.95,1.0,inf),
	\atk, Pwhite(2.0,2.5,inf),
	\rel, Pwhite(6.5,10.0,inf),
	\ldb, 6,
	\amp, 0.2,
	\out, 0
).play;
)

~chords.stop;
s.quit;
s.reboot;
s.boot;


// purcussion stuff:
(
Synth.new(
	\bpfsaw,
	[
		\freq, 2,
		\atk, 0,
		// raise filter quality
		\rqmin, 0.005,
		\rqmax, 0.008,
		\cfmin, 440,
		\cfmax, 440,
	]
);
)

(
~marimba = Pbind(
	\instrument, \bpfsaw,
	\dur, Pexprand(0.1,1,inf),
	\freq, Pexprand(0.25,9,inf),
	\detune, 0,
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfmin, Pexprand(150, 1500, inf),
	\cfmax, Pkey(\cfmin),
	\amp, 1,
	\out, 0
).play;
)
~marimba.stop;

// make the marimba play an E major scale
(
~marimba = Pbind(
	\instrument, \bpfsaw,
	\dur, Pexprand(0.1,1,inf),
	\freq, Pexprand(0.25,9,inf),
	\detune, 0,
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfmin, Prand((Scale.major.degrees+64).midicps,inf),
	\cfmax, Pkey(\cfmin),
	\amp, 1,
	\out, 0
).play;
)

// Octave control using multiplication!
// 1 octave lower, the same octave, or 1 or 2 octaves higher!
(
~marimba = Pbind(
	\instrument, \bpfsaw,
	\dur, Prand([0.5,1],inf), // duration
	\freq, Prand([1/2, 2/3, 1, 4/3, 2, 5/2, 3, 4, 6, 8],inf), // rhymthm
	\detune, 0,
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfmin, Prand((Scale.major.degrees+64).midicps,inf) * Prand([0.5,1,2,4],inf),
	\cfmax, Pkey(\cfmin) * Pwhite(1.008, 1.025, inf),
	\amp, 1,
	\out, 0
).play;

~chords = Pbind(
	\instrument, \bpfsaw,
	\dur, Pwhite(4.5,7.0,inf),
	\midinote, Pxrand([   // each chord is its own array
		[23,35,54,63,64],
		[45,52,54,59,61,64],
		[28,40,47,56,59,63],
		[42,52,57,61,63],
	],inf),
	\detune, Pexprand(0.05,0.2,inf),
	\cfmin, 100,
	\cfmax, 1500,
	\rqmin, Pexprand(0.8,0.95,inf),
	\rqmax, Pexprand(0.95,1.0,inf),
	\atk, Pwhite(2.0,2.5,inf),
	\rel, Pwhite(6.5,10.0,inf),
	\ldb, 6,
	\amp, 0.1,
	\out, 0
).play;
)

Synth(\bpfsaw,
		[
			\freq, 7,
			\amp, 1,
			\atk, 0,
			\sus, 15,
			\cfmin, 500*2,
			\cfmax, 800*50,
			\rqmin, 0.005,
			\rqmax, 0.03,
			\pan, rrand(-1.0,1.0)  // 0 = center, 1 = right, -1 = left
		],
	);


/// Could be07

(
~looking = Pbind(
	\instrument, \bpfsaw, \dur, 4,
	\freq, 7,
			\amp, 1,
			\atk, 1,
			\sus, 0,
			\cfmin, 500*2,
			\cfmax, 800*50,
			\rqmin, 0.005,
			\rqmax, 0.03,
			\pan, rrand(-1.0,1.0)  // 0 = center, 1 = right, -1 = left

).play;
)
~looking.stop;

(
~buzzer = Pbind(
	\instrument, \bpfsaw, \dur, 1,
	\freq, 220 * Pexprand(0.5,2.5),
			\amp, 1,
			\atk, 1,
			\sus, 0,
	\cfmin, Pkey(\freq),
			\cfmax, Pkey(\freq) * Pexprand(0.5,2.5) ,
			\rqmin, 0.005,
			\rqmax, 0.03,
			\pan, rrand(-1.0,1.0)  // 0 = center, 1 = right, -1 = left

).play;
)

// make the marimba play an E major scale
(
~marimba = Pbind(
	\instrument, \bpfsaw,
	\dur, Pexprand(0.1,1,inf),
	\freq, Pexprand(0.25,9,inf),
	\detune, 0,
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfmin, Prand((Scale.major.degrees+64).midicps,inf),
	\cfmax, Pkey(\cfmin),
	\amp, 1,
	\out, 0
).play;
)


// high relative quality = more regular bpf saw synth,
(
10.do{
	Synth(\bpfsaw,
		[
			\freq, 7,
			\amp, 0.5,
			\atk, 5,
			\sus, 50,
			\cfmin, 100*2,
			\cfmax, 600*50,
			\rqmin, 0.008,
			\rqmax, 0.01
		],
	);
};
)

// low relative quality = less regular, more harmonic-wandering bpf saw synth

(
10.do{
	Synth(\bpfsaw,
		[
			\freq, 340,
			\amp, 0.5,
			\atk, 20,
			\sus, 50,
			\cfmin, 280*2,
			\cfmax, 280*50,
			\rqmin, 0.005,
			\rqmax, 0.03
		],
	);
};
)

(
[58,65,68,73].midicps.do{
	arg f;
	Synth(
		\bpfsaw,
		[
			\freq, f,
			\amp, 0.25,
			\cf, f * exprand(1,12),
			\rq, exprand(0.01, 0.5),
		]
	);
};
)
