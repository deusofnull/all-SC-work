(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)

(
SynthDef.new(\fm_saw, {
	arg pan = 0, amp = 0.5,
	freq=440, modAmp=0.5, modAdd=250,
	atk = 0.01, rel = 1;
	var modSig, outSig, env;

	env = EnvGen.kr(Env.perc(
		atk,
		rel, level:1, curve:-10), doneAction:2);

	// Frequency Modulation
	modSig = SinOsc.ar(freq, mul:modAmp, add:modAdd);
	outSig = Saw.ar(modSig, mul:amp);

	outSig = Pan2.ar(outSig, pan, amp);
	outSig = outSig * env;
	Out.ar(0, outSig);
}).add;
)


(
SynthDef.new(\fm, {
	arg pan = 0, amp = 0.5,
	freq=440, modAmp=0.5, modAdd=250,
	atk = 0.01, rel = 1;
	var modSig, outSig, env;

	env = EnvGen.kr(Env.perc(
		atk,
		rel, level:1, curve:-10), doneAction:2);

	// Frequency Modulation
	modSig = SinOsc.ar(freq, mul:modAmp, add:modAdd);
	outSig = SinOsc.ar(modSig, mul:amp);

	outSig = Pan2.ar(outSig, pan, amp);
	outSig = outSig * env;
	Out.ar(0, outSig);
}).add;
)

s.boot;
Synth.new(\fm, [\freq, 220,  \modAdd, 50]);

(
Pdef(\voice,
	Pbind(
		\instrument, \fm,
		\dur, 0.5,
		//\stretch, 1.25,
		\freq, Pseq([220, 440, 400, 360, 320, 180,400, 200, 100], inf),
		//\freq, Pseq([220, 440, 300], inf),
		\modAmp, Pseq([50, 0.1, 60, 0.1,75, 80, 400, 200, 100, ], inf),
		//\modAmp, Pseq([50, 0.1, 60, 0.1, 700, 0.1, 350, 0.1], inf),
		\modAdd, 75,
		\atk, 0.01,
		\rel, 10,
		\amp, 0.5,
	);
).stop;
)
s.quit;
(
Pdef(\voice2,
	Pbind(
		\instrument, \fm,
		\dur, 0.5 / 3.5,
		//\stretch, 1.25,
		\freq, Pseq([850, 700, 600, 500, 400, 300, 200, 100, 50, 25, 800, 700, 600, \rest], inf),
		\modAmp, Pseq([50, 100, 25], inf),
		\modAdd, Pexprand(50,500, inf),
		\atk, 0.01,
		\rel, 1,
		\amp, 0.5,
	);
).stop;
)


/// DRONE MASACRE

(
Pdef(\voice3,
	Pbind(
		\instrument, \fm_saw,
		\dur, 0.5 / 3.5,
		//\stretch, 1.25,
		\freq, Pseq([100, 110, 100, 110, 100, 110, 220, 200, 190, 190], inf),
		\modAmp, Pseq([75], inf),
		\modAdd, 150, //Pexprand(40,41, inf),
		\atk, 0.1,
		\rel, 2.5,
		\amp, 0.3,
	);
).play;
)
