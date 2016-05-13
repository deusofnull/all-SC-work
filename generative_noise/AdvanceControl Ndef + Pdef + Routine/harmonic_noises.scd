s.boot;

(
Ndef(\sound, {
    RHPF.ar(
        \in1.ar([0, 0]) * \in2.ar([0, 0]),
        \freq.kr(6000, 2),
        \rq.kr(0.2)
    ) * 10
}).play;
)

Ndef(\a, { SinOsc.ar(MouseX.kr(300, 1000, 1) * [1, 1.2], \phase.ar([0, 0]) * 0.2) });
Ndef(\b, { LFDNoise3.ar(MouseY.kr(3, 1000, 1) * [1, 1.2]) });
Ndef(\c, { LFTri.ar(MouseY.kr(3, 10, 1) * [1, 1.2]).max(0) });

Ndef(\sound) <<>.in1 Ndef(\a);
Ndef(\sound) <<>.in2 Ndef(\b);
Ndef(\sound) <<>.in2 Ndef(\c);
Ndef(\a) <<>.phase nil;    // unmap
Ndef.clear(3);        // clear all Ndefs

{LFDNoise3.ar(200)}.play;


(
Pdef(\harmnoise, Pbind(
    \instrument, \default,
    \freq, Ndef(\lfo1, {
		arg lfohz = 1, low=300, high=600;
		SinOsc.kr(lfohz).range(low,high)
	}).asMap,
    \dur, 1,
    \amp, 0.1
)).play;
)

// replace on the fly
Ndef(\lfo1, {
	arg lfohz = 1, low=300, high=600;
	SinOsc.kr(lfohz).range(low,high)
}); // replace on the fly

Ndef(\lfo1).set(\lfohz, 3, \high, 1331); // change argument

(// control argument with pattern/pdef
Ndef(\lfo1)[0] = { arg freq = 3; SinOsc.kr(freq).range(330,1331) };
Ndef(\lfo1)[1] = \pset -> Pbind(
    \freq, Pseq([3,5,10],inf)
))
you can also put busses/Ndef in patterns :
\freq, Pseq([ Ndef(\lfo1), Ndef(\lfo2) ],inf),




(
r = Routine {
	var ascPitch;
	var descPitch;
	loop{
		post("ascPitch:  " ); ascPitch = rrand(200,1000).postln;
		post("descPitch: " ); descPitch = rrand(200,1000).postln;
		~asc.free; ~desc.free;
		// first the descending bandwith filter

		~desc = { Resonz.ar(
			in:PinkNoise.ar(1),
			freq:[descPitch, descPitch/2],
			bwr:XLine.kr(0.5, 0.001, 8))!2 }.play;

		0.1.wait; // as to become out of phase

		// next the ascending bandwith filter
		~asc = { Resonz.ar(
			in:PinkNoise.ar(1),
			freq:[ascPitch, ascPitch/2],
			bwr:XLine.kr(0.001, 0.5, 8))!2 }.play;
		10.wait;
	}
}.play;
)

(
Ndef(\harmWave, {
	arg pitch;
	var noise = PinkNoise.ar(1);

	post("pitch:  ");
	pitch = rrand(200,1000).postln;
	Resonz.ar(
			in: noise,
			freq: [pitch, pitch/2],
			bwr: XLine.kr(0.5, 0.001, 8))
}).play;
)

(
SynthDef(\harmWave, {
	arg pitch = rrand(200,1000), time=8;
	var noise, resonance;

	post("pitch: "); pitch.postln;
	noise = PinkNoise.ar(1);
	resonance = Resonz.ar(
		in: noise,
		freq: [pitch, pitch/2],
		bwr: XLine.kr(0.5, 0.001, time, doneAction:2)
	);
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
		\time, 8,
	)
).play;
)

(
Pdef(\harmPat3,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pxrand([700, 500, 900, 850, 650], inf),
		\dur, 2,
		\time, 2,
	)
).stop;
)

(
Pdef(\harmBeat,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pseq([700, 600, 150, 400,350], inf) *0.75,
		\dur, Pseq([1, 0.5, 0.25, 1],inf),
		\time, Pseq([1, 0.5, 0.25, 1],inf),
	)
).stop;
)

(
Pdef(\harmBeat,
	Pbind(
		\instrument, \harmWave,
		\pitch, Pseq([150, 400,350], inf) *0.4,
		\dur, Pseq([0.25],inf),
		\time, Pseq([0.25],inf),
	)
).stop;
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
		\time, Pseq([1],inf),
	).trace;
).play;
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
]);
)
~rev.set(\wet, 0.5, \size, 0.5, \damp, 0.8);



(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
