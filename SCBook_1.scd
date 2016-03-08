(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
(
do(3, {
	["C", "D", "E", "F", "G", "A", "B"].at(7.rand).postln;
});
)

(
Task({
	50.do({
		["C", "D", "E", "F", "G", "A", "B"].at(7.rand).postln;
		0.5.wait;
	});
}).play;
)

(
Task({
	a=["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];
	"count, midi, pitch, octave".postln;
	do(inf, {arg count;
		p = rrand(1, 84);
		w = 0.05;
		[count, p, a.wrapAt(p), (p/12).round(1) -1].postln;
		{SinOsc.ar(freq:p.midicps, mul:Line.kr(1,0,w))}.play;
		w.wait;
	})
}).play;
)

// SC Book pg 24
(
SynthDef("PMCrotale", {
	arg midi = 60, tone = 3, art = 1, amp = 0.8, pan=0;
	var env, out, mod, freq;

	freq = midi.midicps;
	env = Env.perc(0, art);
	mod = 5 + (1/IRand(2,6));

	out = PMOsc.ar(freq, mod*freq,
		pmindex: EnvGen.kr(env, timeScale: art, levelScale: tone),
		mul: EnvGen.kr(env, timeScale: art, levelScale: 0.3));

	out = Pan2.ar(out, pan);

	out = out * EnvGen.kr(env,
		timeScale: 1.3*art,
		levelScale: Rand(0.1, 0.5),
		doneAction:2);

	Out.ar(0, out * amp);
}).add;
)

//test PMCrotale synth
(Synth("PMCrotale",
	[
		\midi, rrand(48, 72).round(1),
		\tone, rrand(1, 6)
]))


(
~pmcVoice.stop;
~pmcVoice = Task({
	a=["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];
	do(inf, {arg count;
		p = rrand(24, 60);
		w = 0.125 / 1.5;
		[count, p, a.wrapAt(p), (p/12).round(1) -1].postln;
		~pmc = Synth(\PMCrotale,
			[
				//\midi, (p/12).round(1) -1,  // BASSEY
				\midi, [p, p+6, p+12],
				\tone, rrand(1,6),
				\amp, 0.1,
				\art, 3,
		]);
		w.wait;
	})
}).play;
)


(
~pmcBass.stop;
~count = 0;
~pmcBass = Task({
	do(inf, {
		//p = [[10, 16], [16, 24],[25,30]].choose(1);
		//p = [4, 10, 16, 24].choose(1);
		~midiHi = rrand(12, 15);
		~midiLow = ~midiHi+18;
		p = [
			~midiHi,
			[~midiHi+3, ~midiHi+4].choose(1),
			[~midiHi+7, ~midiHi+ 8].choose(1),

			~midiLow,
			[~midiLow+3, ~midiLow+4 ].choose(1),
			[~midiLow+7, ~midiLow+8].choose(1)
		];
		//w = [1/2, 1/4, 1/8].choose(1);
		w = [rrand(1/8, 1/32)].choose(1);
		~pmc = Synth(\PMCrotale,
			[
				\midi, p.wrapAt(~count),
				\tone, rrand(5,20),
				\art, w * rrand(1,8),
				\amp, 0.8

		]);
		~count = ~count + 1;
		w.wait;
	})
}).play;
)


(
~pmc3.stop;
~count = 0;
~pmc3 = Task({
	do(inf, {
		//p = [[10, 16], [16, 24],[25,30]].choose(1);
		//p = [4, 10, 16, 24].choose(1);
		~midiHi = rrand(42, 54);
		~midiLow = ~midiHi+6;
		p = [
			~midiHi,
			[~midiHi+3, ~midiHi+4].choose(1),
			[~midiHi+7, ~midiHi+ 8].choose(1),

			~midiLow,
			[~midiLow+3, ~midiLow+4 ].choose(1),
			[~midiLow+7, ~midiLow+8].choose(1)
		];
		w = [rrand(1.5,3)].choose(1);
		~pmc = Synth(\PMCrotale,
			[
				\midi, p.wrapAt(~count),
				\tone, rrand(45,80),
				\art, w,
				\amp, 0.0

		]);
		~count = ~count + 1;
		w.wait;
	})
}).play;
)
