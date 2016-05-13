(
SynthDef(\fm, {
	|freq=200, atk=0.01, decay=0.3, sustain=0.4, rel=0.1
	carratio=1,modratio=1, modindex=1,
	amp=0.2, gate=1, outBus=0|
	var env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel), gate, doneAction:2);
	var mod = SinOsc.ar(freq * modratio);
	var car = SinOsc.ar(freq * carratio, (1 + (mod *modindex)), 0) * amp * env;

	Out.ar(0, car ! 2);
}).add;
)

// how to start the synth with inital values
~fmSynth = Synth.new(\fm, [\freq, 220]);
// how to alter a synth in real time
~fmSynth.set(\freq, 260);
// how to liberate the synth
~fmSynth.free;

~notes = [23,33,43];
(
~dur = 0.25;

~notes1 = [23,23,24,22,\rest];
~notes2 = [23,23,26,22,\rest];
~notes3 = [23,23,28,22,\rest];
~notes4 = [23,23,22,22,\rest];
Pdef(\fmbind,
	Pmono(
		\fm,
		\dur, ~dur,
		//\freq, 26.25 * 2,
		\midinote, Pseq(
			[
				Pseq(~notes1, 1),
				Pseq(~notes2, 1),
				Pseq(~notes3, 1),
				Pseq(~notes4, 1)
			],inf),
		/*\ctranspose, Pseq(
			[
				Pseq([3], 4* ~notes1.size),
				Pseq([7], 4* ~notes1.size),
				Pseq([9], 4* ~notes1.size),
				Pseq([6], 4* ~notes1.size),

		],inf),*/
		\carratio, 3,
		\modindex, 50,
		\atk, 0.1,
		\amp, 0.5,
	);
).play.quant_(~dur * ~notes1.size);
)

(
~dur = 0.125;

~notes1 = [23];
~notes2 = [29];
Pdef(\fmbind,
	Pbind(
		\instrument, \fm,
		\dur, ~dur,
		//\freq, 26.25 * 2,
		\midinote, Pseq(
			[
				Pseq(~notes1, 3),
				Pseq(~notes2, 1),
			],inf),
		\ctranspose, Pseq(
			[
				Pseq([1],4*(~notes1.size+~notes2.size)),
				Pseq([3],4*(~notes1.size+~notes2.size)),

		],inf),
		\carratio, 3,
		\modindex, Pexprand(50,2000,inf),
		\atk, 0.1,
		\amp, 0.5,
	);
).play.quant_(~dur * (~notes1.size + ~notes2.size));
)
s.boot;
(
//~dur = 0.25;
 ~dur = 0.125;

~notes1 = [22,\rest,25,22,21,\rest];
~notes2 = [19,\rest,18,20,23,20];

Pdef(\fmbind,
	Pbind(
		\instrument, \fm,
		\dur, ~dur,
		//\freq, 26.25 * 2,
		\midinote, Pseq(
			[
				Pseq(~notes1, 3),
				Pseq(~notes2, 1),
			], inf
		),
		\ctranspose, Pseq([0,6,4,8],inf),
		\carratio, 5,
		\modindex, 75,
		// \modindex, Pexprand(500,750,inf).round(25),
		\atk, 0.1,
		\amp, 0.2,
	);
).play.quant_((~dur * (~notes1.size)) * 4);
)


(
SynthDef(\vibratoDelay, {
	arg vibLfoHzLo=5, vibLfoHzHi=10;

	var input, effect, vibrato;

	input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0
	vibrato = SinOsc.ar(Rand(vibLfoHzLo,vibLfoHzHi),0,1,0);

	effect= DelayC.ar(input, 1, vibrato); //max delay of one second

	Out.ar(0,effect); //adds to bus 0

}).add;
)

(
~delayFx = Synth.new(\vibratoDelay,
	[
		\vibLfoHzLo,0.5,
		\vibLfoHzHi, 2,
	]
);
)


~delayFx.free;

(
~delayRoutine = Routine {
	arg inarg;
	var vibLfoHzLo=5, vibLfoHzHi=10;
	~delayFx.free;
	vibLfoHzLo= rrand(1,25);
	vibLfoHzHi= vibLfoHzLo*2;
	~delayFx = Synth.new(\vibratoDelay, [\delaytime,0.5]);
	loop {
		~delayFx.free;
		~delayFx = Synth.new(\vibratoDelay, [\delaytime,0.5]);
		5.0.yield; // re run loop every n seconds
	}
}.play;
)
~delayRoutine.stop;

s.quit;