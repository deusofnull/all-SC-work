s.reboot;
Server.default.makeGui;
s.plotTree;


// 16 used reverb, distort, and instrument0
// pdefs:  electric_cricket  electric_moose electric_macrophage

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
	\wet, 0.4,
	\size, 0.8,
	\damp, 0.6,
]);
)

~rev.set(\wet, 0.9);
~rev.set(\size, 0.9);
~rev.set(\damp, 0.9);

r.free;


(
SynthDef.new(\distort, {
	arg in, out =0, pregain=40, amp=0.2, gate=1;

	var env, sig;

	sig = In.ar(in,2);

	sig = (sig * pregain).distort * amp;

	env = Linen.kr(gate, 0.05, 1, 0.1, 2);

	Out.ar(out, sig);
}).add;
)

(
d = Synth.new(\distort, [
	\in, 0,
	\pregain, 2,
]);
)
d.set(\pregain, 30); // increase gradually
d.free;


(
SynthDef.new( \instrument0_lpf,
	{
		arg freq = 200, feedback = 0, amp = 0.5,
		atk = 0.005, rel = 0.005, curve = -4,
		lpfhz = 200, rq = 1,
		pan=0;
		var sig, env;

		env = EnvGen.kr(Env.perc(atk, rel, 1, curve) , doneAction:2);

		sig = SinOscFB.ar(freq, feedback);

		sig = Pan2.ar(sig, pan, amp);

		sig = LPF.ar(sig, lpfhz);

		sig = sig * env;

		Out.ar(0, sig);

}).add;
)
(
SynthDef.new( \instrument0,
	{
		arg freq = 200, feedback = 0, amp = 0.5,
		atk = 0.005, rel = 0.005, curve = -4,
		lpfhz = 200, rq = 1,
		pan=0;
		var sig, env;

		env = EnvGen.kr(Env.perc(atk, rel, 1, curve) , doneAction:2);

		sig = SinOscFB.ar(freq, feedback);

		sig = Pan2.ar(sig, pan, amp);

		//sig = LPF.ar(sig, lpfhz);

		sig = sig * env;

		Out.ar(0, sig);

}).add;
)

Env.perc(0.5, 3, 1, 1).plot;

(
Synth.new(\instrument0,
	[
		\atk, 0.5,
		\rel, 0.5,
		\amp, 0.2,
		\feedback, 10
	]
);
)





(
Pdef(
	\electric_cricket,
	Pbind(
		\instrument, \instrument0,
		\dur, Pseq([1/6], inf),
		\stretch, 60/256 * 4,
		//\freq, Pxrand([100, 300, 500, 700, 900], inf).trace,
		\freq, Pexprand(20, 80, inf),
		\atk, 0.5,
		\rel, 0.75,
		\amp, 0.05,
		\curve, Prand([1, 4, 8, -1, -4, -8], inf),
		/*\feedback, Pseq([0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100], inf).trace*/
		\feedback, Pbrown(0, 500, 10, inf),
	)
).stop;
)

(
Pdef(
	\electric_moose,
	Pbind(
		\instrument, \instrument0,
		\dur, 0.5,
		//\freq, Pxrand([100, 300, 500, 700, 900], inf).trace,
		\freq, Pexprand(20, 80, inf),
		\atk, 1,
		\rel, 1.5,
		\amp, 0.01,
		/*\feedback, Pseq([0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100], inf).trace*/
		\feedback, Pbrown(0, 500, 10, inf).trace,
	)
).stop;
)

(
Pdef(
	\electric_macrophage,
	Pbind(
		\instrument, \instrument0,
		\dur, Pseq([1/16], inf),
		\stretch, 60/256 * 4,
		//\freq, Pxrand([50, 100, 300, 500, 700, 900], inf).trace,
		\freq, Pexprand(920, 925, inf),
		\atk, Pexprand(0.03, 0.2, inf),
		\rel, Pexprand(0.3, 1.3, inf),
		\amp, 0.2,
		\curve, Prand([1, 4, 8, -1, -4, -8], inf),
		//\feedback, Pexprand(25, 500, inf).trace,
		\feedback, Pbrown(25, 90, 3,  inf).trace,
		\pan, Pwhite(-1.0, 1.0, inf)
	)
).play;
)

Scale.directory;

// Ill attempt to use degree + mtranspose.degreeToKey(scale, stepsPerOctave)  freq control
(
Pdef(
	\electric_progressions,
	Pbind(
		\instrument, \instrument0,
		\dur, Pwhite(0.06, 0.11, inf),
		\degree, Pseq(
			[
				Pseq([[1, 3, 5]], 4), //  I
				//Pseq([[2, 4, 6]], 4), // ii
				Pseq([[3, 5, 7]], 4), // iii
				Pseq([[4, 6, 8]], 4), //  IV
				//Pseq([[5, 7, 9]], 4), //  V
				//Pseq([[6, 8, 10]], 4), // vi
				//Pseq([[7, 9, 11]], 4), // vii o
			], inf).trace,
		\scale, Scale.minor,
		//\mtranspose, 1,
		\mtranspose, Pwhite(-8,8).stutter(2),
		\atk, Pexprand(0.03, 0.2, inf),
		\rel, Pexprand(0.3, 1.3, inf),
		\amp, 0.1,
		\lpfhz, Pexprand(2000, 4000, inf),
		\rq, 0.05,
		\curve, Prand([1, 4, 8, -1, -4, -8], inf),
		\feedback, Pexprand(2, 1300, inf),
		//\feedback, Pbrown(780, 1000, 5,  inf),
		\pan, Pwhite(-1.0, 1.0, inf)
	)
).play;
)


(
Pdef(
	\electric_progressions,
	Pbind(
		\instrument, \instrument0,
		\dur, Pseq([1/2], inf),
		\stretch, 60/160 * 4,
		\degree, Pxrand(
			[
				Pseq([[5, 7, 9]], 3), //  V
				Pseq([[4, 6, 8]], 2), //  IV
				Pseq([[3, 5, 7]], 1), // iii
				Pseq([[2, 4, 6]], 2), // ii
				Pseq([[1, 3, 5]], 3), //  I
			], inf).trace,
		\scale, Scale.major,
		//\mtranspose, -2,
		\mtranspose, Pwhite(-2,2).stutter(2),
		\atk, 0.5,
		\rel, 1.3,
		\amp, 0.4,
		\lpfhz, 100,
		\lpfhz, Pbrown(1000, 2000, 100, inf).trace,
		\rq, 0.001,
		//\curve, Prand([1, 4, 8, -1, -4, -8], inf),
		//\feedback, Pexprand(400, 500, inf),
		\feedback, Pexprand(30, 90, inf),
		\pan, Pwhite(-1.0, 1.0, inf)
	)
).play;
)

FreqScope.new;