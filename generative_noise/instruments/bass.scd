s.boot;
s.meter;
Server.default.makeGui;
s.plotTree;
s.scope;
s.freqscope.new;
(
SynthDef(\bass_adsr, {
	arg freq=220, gate=1, amp=0.5, slideTime=0.17, lpffreq=550, width=0.15,
	detune=1.005, preamp=4;
	var sig, env= Env.adsr(0.01, 0.3, 0.4, 0.1);
	freq = Lag.kr(freq, slideTime);
	sig = Mix(
		VarSaw.ar([freq, freq * detune], 0, width, preamp)
	).distort;
	sig = sig * amp * EnvGen.kr(env, gate, doneAction: 2);
	sig = LPF.ar(sig, lpffreq);
	Out.ar(0, sig ! 2);
}).add;
)
(
SynthDef(\bass_perc, {
	arg freq=220, gate=1, amp=0.5, slideTime=0.17, lpffreq=550, width=0.15,
	detune=1.005, preamp=4,
	atk=0.01, rel=0.03, lvl=0.4, curve=0.1;
	var sig, env= Env.perc(atk, rel, lvl, curve);
	freq = Lag.kr(freq, slideTime);
	sig = Mix(
		VarSaw.ar([freq, freq * detune], 0, width, preamp)
	).distort;
	sig = sig * amp * EnvGen.kr(env, gate, doneAction: 2);
	sig = LPF.ar(sig, lpffreq);
	Out.ar(0, sig ! 2);
}).add;
)


Synth(\bass_adsr);

(
Synth(\bass_perc,
	[
		\atk, 0.5,
		\rel, 0.25,
		\curve, -4,

	]
);
)

