s.boot;
FreqScope.new;
s.meter;
Server.default.makeGui;

(
SynthDef.new(\pulsaret,
	{
		arg freq = 200, amp = 0.5, pan = 0,
		atk = 0.005, rel = 0.005, silence = 0.005;

		var sig, env;

		env = EnvGen.ar(Env.new([0,1,0.0001,0], [atk, rel, silence], \sine), doneAction: 2);

		sig = SinOsc.ar(freq);

		sig = sig * env;

		sig = sig * amp;

		sig = Pan2.ar(sig, pan);

		Out.ar(0, sig);
	}
).add;
)
Env.new([0,1,0.0001,0], [0.2, 0.5, 3], \sine).plot;


(
Synth.new(\pulsaret, [
		\atk, 0.25,
		\rel, 0.25,
		\silence, 1,
]);
)
\rest!5

(
Pdef(
	\pulsar,
	Pbind(
		\instrument, \pulsaret,
		\dur, 1,
		\atk, 0.2,
		\rel, 0.5,
		\silence, 1,
		\amp, 0.3,
		\midinote, Pseq([50, 40, 73 ], inf),
	)
).play;
)

{Impulse.ar(6 , 0.0, 0.5, 0)}.play;

(
SynthDef.new(\pulsaret2,
	{
		arg freq = 200, amp = 0.5, pan = 0,
		atk = 0.005, rel = 0.005,
		period = 6, length = 0.01;

		var sig, trig, env;

		trig = Impulse.ar(period, 0.0, 0.5, 0);

		env = EnvGen.ar(Env.new([0,1,0], [length / period, length / period], \linear), trig, doneAction:2);

		sig = LFSaw.ar(freq * (env * 2), 0 , 1) * env;

		sig = sig * amp;

		sig = Pan2.ar(sig, pan);

		Out.ar(0, sig);
	}
).add;
)

x = Synth(\pulsaret2);
x.free;
Server.default.makeGui;
(
Pdef(
	\pulsar2,
	Pbind(
		\instrument, \pulsaret2,
		\dur, 0.5,
		\length, 0.1,
		\period, 0.02,
		\amp, 0.0000,
		//\midinote, Pseq([50, 52], inf),
		\degree, Pseq([1, Pxrand([1,2], inf) * Pseq([5,2,3],inf)], inf),
		\mtranspose, -5,
		\scale, Scale.harmonicMinor,

	)
).stop;
)

s.quit;