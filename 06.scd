// This is 06
(
SynthDef.new(\multi_sin, {
	arg atk = 10, rel = 10, sus = 5,  fund_freq_min = 50, fund_freq_max = 1200;
	var sig, amp, env;
	env = EnvGen.kr(
		Env.new(
			[0,1,1,0],
			[atk,sus,rel],
			[1,-1]),
		doneAction:2);
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0,1);
	sig = SinOsc.ar({ExpRand(fund_freq_min,fund_freq_max)}!8);
	sig = sig * amp * env;
	sig = Splay.ar(sig) * 0.5;  // splay puts an array of signals into stereo field quite nicely
	Out.ar(0, sig);
}).add;
)


// same but saw
(
SynthDef.new(\multi_saw, {
	arg atk = 10, rel = 10, sus=5, fund_freq_min = 50, fund_freq_max = 1200;
	var sig, amp, env;
	env = EnvGen.kr(
		Env.new(
			[0,1,1,0],
			[atk,sus,rel],
			[1,-1]),
		doneAction:2);
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0,1);
	sig = LFSaw.ar({ExpRand(fund_freq_min,fund_freq_max)}!8);
	sig = sig * amp * env;
	sig = Splay.ar(sig) * 0.2;  // splay puts an array of signals into stereo field quite nicely
	Out.ar(0, sig);
}).add;
)

{ExpRand(100,200)}

(
h = Synth.new(\multi_saw, [
	\atk, 0.5,
	\sus, 1,
	\rel,3,
	\fund_freq_min, Pexprand.new(220,440),
	\fund_freq_max, Pexprand.new(660,880)]);
)

(
j = Synth.new(\multi_saw, [
	\atk, 0.2,
	\sus, 0.1,
	\rel,0.3,
	\fund_freq_min, Pexprand.new(1,10),
	\fund_freq_max, Pkey(\fund_freq_min)]);
)

(
i = Synth.new(\multi_sin, [
	\atk, 2,
	\sus, 30,
	\rel,3,
	\fund_freq_min, Pexprand.new(220,440),
	\fund_freq_max, Pexprand.new(660,880)]);
)




// all together now
(
f = Synth.new(\multi_sin, [
	\atk, 1,
	\rel,3]);

g = Synth.new(\multi_saw, [
	\atk, 0,
	\rel,0.6]);
)