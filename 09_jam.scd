(
{SinOsc.ar(110,0,0.3)}.play;
{SinOsc.ar(140,0,0.3)}.play;
{SinOsc.ar(120,0,0.3)}.play;
)


{Pulse.ar(270,)}.play

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


// THIS IS 09
(
Pdef(
	\xrthm,
	Pbind(
		\instrument, \bpfsaw,
		\dur, 0.3,
		\midinote, 22,
		\detune, 0.08,
		\cfmin, 100,
		\cfmax, 500,
		\atk, 0.15,
		\rel, 0.35,
		\ldb, 6,
		\amp, 0.2,
		\out, 0
).play;
)
)

(
Pdef(
	\xminorharmonic,
	Pbind(
		\instrument, \bpfsaw,
		\dur, 0.3,
		\note, Pxrand([0,1,3,5,6,10,12], inf),
		\gtranspose, -5,
		\detune, 0.08,
		\cfmin, 100,
		\cfmax, 500,
		\atk, 0.15,
		\rel, 0.35,
		\ldb, 6,
		\amp, 0.2,
		\out, 0
).play;
)
)
