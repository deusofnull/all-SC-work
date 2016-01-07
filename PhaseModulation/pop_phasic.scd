s.boot;
Server.default.makeGui;
FreqScope.new;
s.plotTree;
(
SynthDef(\pop_phasic,
	{ |phase=0, gate=1, out=0, amp=0.1, freq= 10, hifreq = 10000, dup = 20|
		FreeSelf.kr(1-gate);
		Out.ar(0, Splay.ar(SinOsc.ar({Rand(freq,hifreq)}.dup(dup), phase)) * amp);
}).add;
)

(
Pbind(\instrument, \pop_phasic,
	\dur, Pwhite(0.01, 0.1, inf),
	\phase, 0,
	\legato, 0.1,
	\amp, 0.3).play
)

(
Pdef(\pop_phasic_pat,
	Pbind(\instrument, \pop_phasic,
		\dur, Pwhite(0.1, 0.5, inf),
		\phase, pi/2,
		\legato, Pkey(\dur),
		\freq, 10,
		\hifreq, 500,
		\dup, 20,
		\amp, 0.3)
).play;
)

(
Pbind(\instrument, \pop_phasic,
	\dur, Pwhite(0.1, 0.5, inf),
	\phase, 0,
	\legato, 0.1,
	\amp, 0.3).play
)