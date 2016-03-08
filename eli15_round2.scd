s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
s.quit;

(
SynthDef(\bpfsawDetune,
	{
		arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
		freq=500, detune=0.2,
		cf=1500, rq=0.2, amp=1, out=0;
		var sig, env;

		env = EnvGen.kr(Env([0,1,1,0], [atk,sus,rel], [c1,0,c2]), doneAction:2);

		sig = Saw.ar(freq * LFNoise1.kr(0.5, detune).midiratio);
		sig = BPF.ar(sig, cf, rq);

		sig = sig * env * amp;
		Out.ar(out, sig);
}).add;
)

// aug4 triad
(
[58, 62, 68].midicps.do{
	arg f;
	Synth(
		\bpfsawDetune,
		[
			\detune, 0,
			\freq, f,
			\amp, 0.25,
			\cf, f* exprand(1,12),
			\rq, exprand(0.01, 0.5),
		]
	)
};)

// more random + Noise detune
(
(8..10).choose.do{
	Synth(
		\bpfsawDetune,
		[
			\freq, 50,
			\detune, 10,
			\amp, 0.25,
			\cf, exprand(200, 5000),
			\rq, 0.1,
		]
	)
};)

(
SynthDef(\bpfsawDetuneEnv,
	{
		arg atk=2, sus=0, rel=3, c1=1, c2=(-1),
		freq=500, detunePeak=0.2, detuneStart=1, detuneDur=5,
		cfHz=0.2, cfmin=500, cfmax=2000,
		rqHz=0.1, rqmin=0.1, rqmax=0.2,
		amp=1, out=0;
		var sig, env, ascEnv;

		env = EnvGen.kr(Env([0,1,1,0], [atk,sus,rel], [c1,0,c2]), doneAction:2);

		ascEnv = EnvGen.kr(Env([detuneStart, detunePeak], [detuneDur]));
		sig = Saw.ar(freq * ascEnv);
		// LFO center frequency and reciprocal Q
		sig = BPF.ar(sig,
			LFNoise1.kr(cfHz).exprange(cfmin, cfmax),
			LFNoise1.kr(rqHz).exprange(rqmin, rqmax)
		);
		sig = sig * env * amp;
		sig = Pan2.ar(sig, 0);
		Out.ar(out, sig);
}).add;
)

// more random + Env detune
(
30.do{
	Synth(
		\bpfsawDetuneEnv,
		[
			\freq, [52, 58, 62, 68, 74].choose.midicps,
			\detuneStart, 1,
			\detunePeak, [0.2, 1.8].choose,  // some detune up / down
			\atk, 2,
			\sus, 0,
			\rel, 4,
			\detuneDur, 6,
			\cfHz, 0.5, //frequency of cf wander
			\cfmin, 50,
			\cfmax, 1000,
			\rqHz, 5, // freq of rq wander
			\rqmin, 0.08,
			\rqmax, 0.5,
			\amp, 0.25,
		]
	)
};)
