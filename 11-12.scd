s.plotTree;

(
x = {
	arg width = 0.5;
	var sig, freq,  env;

	env = XLine.kr(1,0.01,1, doneAction:2);
	sig = Pulse.ar(ExpRand(30,500), width) * env;

}.play;
);

(
y = {
	arg width = 0.5;
	var sig, freq,  env;

	env = XLine.kr(1,0.01,1, doneAction:2);
	freq = XLine.kr(ExpRand(600,800), ExpRand(30,200), 1, doneAction:2);
	sig = Pulse.ar(freq, width) * env;

}.play;
);


// Env Gen

Env.new.plot;

(
z = {
	arg t_gate = 0;
	var sig, env;

	env = EnvGen.kr(Env.new(
		[0,1,0.2,0],
		[0.5,1,2],
		[3,-3,0]), t_gate, doneAction:0);
	sig = Pulse.ar(ExpRand(30,500))  * env;
}.play
)

z.set(\t_gate,1);

Env.new([0,1,0.2,0], [0.5,1,2], [3,-3,0]]).plot;


// adsr

(
a = {
	arg gate = 0, atk = 0.5, dec = 0.5, sus = 1, rel= 0.1;
	var sig, envf, freq;
	freq = EnvGen.kr(Env.adsr(1), gate, 200, 0.1);
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate);
	//sig = Pulse.ar(ExpRand(30,500))  * env;
	sig = VarSaw.ar(SinOsc.kr(freq).range(500,600)) * env;
}.play
)

z.set(\gate,1);