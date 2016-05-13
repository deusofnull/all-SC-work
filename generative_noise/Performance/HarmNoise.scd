
(
SynthDef(\harmWave, {
	arg pitch = rrand(200,1000), resonzTime=8,
	atk = 0.01, rel=8, curve=4;
	var noise, resonance, env;

	env = EnvGen.kr(Env.perc(
		atk,
		rel, level:1, curve: curve), doneAction:2);

	post("pitch: "); pitch.postln;
	noise = PinkNoise.ar(1);
	resonance = Resonz.ar(
		in: noise,
		freq: [pitch, pitch/2],
		bwr: XLine.kr(0.5, 0.001, resonzTime)
	);
	resonance = resonance * env;
	Out.ar(0, resonance);
}).add;
)

Synth.new(\harmWave);

(
Pdef(\harmPat1,
	Pbind(
		\instrument, \harmWave,
		\pitch, [700, 350],
		\dur, 8,
		\resonzTime, 8,
		\rel, Pkey(\dur),
		\curve, 6,
	)
).play;
)

(
// Resonance lingers with a wandering harmonic group
Pdef(\harmPatWandering1,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pxrand([
			[700, 350, 135, 1400],
			[150, 300, 600, 1200],
			[200, 400, 800, 1600],
			[100, 150, 200, 250]
		], inf) * Pexprand(0.75, 1.2, inf),
		\dur, 8,
		\resonzTime, 4,
		\rel, Pkey(\dur),
		\curve, 8,
	)
).play;
)

(
// Resonance lingers with a wandering harmonic group
Pdef(\harmPatWandering2,
	Pbind(
		\instrument, \harmWave,
		\pitch, [700, 350, 135, 1400] * Pexprand(0.5, 2, inf),
		\dur, 0.25,
		\resonzTime, Pkey(\dur) / 2,
		\rel, Pkey(\dur),
		\curve, 8,
	)
).play;
)


// harmPat3 is really boring
(
Pdef(\harmPat3,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pxrand([700, 500, 900, 850, 650], inf),
		\dur, 2,
		\time, 2,
	)
).play;
)

(Pdef(\harmBeat2,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pseq([150,300, 550, 720, 350], inf),
		\dur,  Pseq([0.25, 0.125, 0.25, 0.5], inf),
		\time,  Pseq([0.25, 0.125, 0.25,  0.5], inf),
	)
).stop;
)


(
Pdef(\harmBeat,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pseq([700, 600, 150, 400,350], inf) *0.75,
		\dur, Pseq([1, 0.5, 0.25, 0.5, 0.125],inf),
		\resonzTime,  Pseq([1, 0.5, 0.25, 1],inf),
		\rel, Pkey(\dur),
		\curve, 8,
	)
).play;
)

(
Pdef(\harmBeat,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pseq([150, 400,350], inf) *0.4,
		\dur, Pseq([0.25],inf),
		\resonzTime, Pseq([0.25],inf),
		\rel, Pkey(\dur),
		\curve, 8,
	)
).play;
)

// blend harmChord with HarmPatWandering1
// create a lingering resonance chord
(
Pdef(\harmChord,
	Pbind(
		\instrument, \harmWave,

		\detune, Pseq([
			Pseq([2], { rrand(3,7)} ),
			Pxrand([3,4,5,6], { rrand(5, 12)} ),
			Pseq([2.5], { rrand(3,7)} ),
		], inf),
		\pitch, [50.midicps, 53.midicps, 56.midicps] * Pkey(\detune),
		\dur, Pseq([1],inf),
		\resonzTime, Pseq([1],inf),
		\rel, Pkey(\dur) * 2,
	).trace;
).play;
)


(
SynthDef(\harmWaveDetune, {
	arg pitch = rrand(200,1000), time=8, detune=1;
	var noise, resonance;

	post("pitch: "); pitch.postln;
	//pitch = pitch * detune;
	noise = PinkNoise.ar(1);
	resonance = Resonz.ar(
		in: noise,
		freq: [pitch, pitch/2],
		bwr: XLine.kr(0.5, 0.001, time, doneAction:2)
	);
	Out.ar(0, resonance);
}).add;
)



(
SynthDef.new(\reverb, {
	arg in, out =0, wet=0.5, size=0.5, damp=0.2 ;
	var env, sig;
	sig = In.ar(in,2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
}).add;
)

(
~rev = Synth.new(\reverb, [
	\in, 0,
	\wet, 0.1,
	\size, 0.1,
	\damp, 0.1,
], addAction: \addToTail);
)
~rev.set(\wet, 0.9, \size, 0.9, \damp, 0.8);


s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
