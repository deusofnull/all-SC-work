// FM bass loop
s.reboot;
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
r=Synth(\fm);
(
//~dur = 0.25;
 ~dur = 0.125;

~notes1 = [22,\rest,25,22,21,\rest];
~notes2 = [19,\rest,18,20,23,   20];
~quant = (~dur * (~notes1.size)) * 4; // timing for updates
~beats = (~notes1.size) * 4; // pattern for all beats in measure, 4 is the number of bars in a measure

Pdef(\fmbind,
	Pbind(
		\instrument, \fm,
		\dur, ~dur,
		//\freq, 26.25 * 2,
		\midinote, Pseq(
			[
				Pseq(~notes1, 3),
				Pseq(~notes2, 1),
			], inf),
		\ctranspose, Pseq(
			[
				Pseq([0], ~beats * 4 ),
				Pseq([2], ~beats * 4),
				Pseq([5], ~beats * 4),
				Pseq([7], ~beats * 4),
				Pseq([1], ~beats * 4),
			], inf),
		\carratio, Pseq(
			[
				Pseq([3], ~beats),
				Pseq([5], ~beats),
				Pseq([4], ~beats),
				Pseq([3], ~beats),
			], inf),
		\modindex, 75,
		// \modindex, Pexprand(500,750,inf).round(25),
		\atk, 0.1,
		\amp, 0.2,
	).trace;
).stop.quant_(~quant);
)
s.reboot;

(
//~dur = 0.25;
// ~dur = 0.125;
~dur = 0.125;

~notes1 = [22,\rest,25,22,21,\rest];
~notes2 = [19,\rest,18,20,23,   20];
~quant = (~dur * (~notes1.size)) * 4; // timing for updates
~beats = (~notes1.size) * 4; // pattern for all beats in measure, 4 is the number of bars in a measure

Pdef(\fmbind,
	Pbind(
		\instrument, \fm,
		\dur, ~dur,
		//\freq, 26.25 * 2,
		\midinote, Pseq(
			[
				Pseq(~notes1, 3),
				Pseq(~notes2, 1),
			], inf),
		\ctranspose, Pseq(
			[
				Pseq([0], ~beats * 4 ),
				Pseq([2], ~beats * 4),
				Pseq([5], ~beats * 4),
				Pseq([7], ~beats * 4),
				Pseq([1], ~beats * 4),
			], inf),
		\carratio, 3,
		\modindex, 75,
		// \modindex, Pexprand(500,750,inf).round(25),
		\atk, 0.1,
		\amp, 0.7,
	).trace;
).stop.quant_(~quant);
)
