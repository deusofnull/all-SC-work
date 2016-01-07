// monophonic... boooring
a = {SinOsc.ar()}.play;

// polyphonic, biphonic, woooohooo siiiick
b = {[SinOsc.ar(300), SinOsc.ar(500)]}.play;

// simpler
c = {SinOsc.ar([300,440,500])}.play;


(
d = {
	var sig, amp;
	amp = SinOsc.kr([2,3]).range(0,1); // with this amplitude control, I can program time signatures!  kinda
	sig = SinOsc.ar([300,500]);
	sig = sig * amp;

}.play;
)

// using the Mix ugen, you can mix multiple channels down to 1 channel, so even without 5 speakers, you can hear
// 5 channel audio

(
d = {
	var sig, amp;
	amp = SinOsc.kr([2, 3, 1, 4, 8]).range(0,1);
	sig = SinOsc.ar([300,500, 700, 900, 1100]);
	sig = sig * amp;
	Mix.new(sig).dup(2);  // Mix brings signal to 1 channel, .dup(2) duplicates it twice, multichannel expansion

}.play;
)

// Saw version, v cool
(
e = {
	var sig, amp;
	amp = SinOsc.kr([2, 3, 1, 4, 8]).range(0,1);
	sig = LFSaw.ar([300,500, 700, 900, 1100]);
	sig = sig * amp;
	Mix.new(sig).dup(2);  // Mix brings signal to 1 channel, .dup(2) duplicates it twice, multichannel expansion

}.play;
)

// synth def

(
SynthDef.new(\multi, {
	var sig, amp;
	amp = SinOsc.kr([2, 3, 1, 4, 8]).range(0,1);
	sig = SinOsc.ar([300,500, 700, 900, 1100]);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;  // splay puts an array of signals into stereo field quite nicely
	Out.ar(0, sig);
}).add;
)

f = Synth.new(\multi);

rrand(50,1200)!4;  // array of 4 of the same random number
{rrand(50,1200)}!4; // function enclosed, array of 4 random numbers

// multichannel randomness with env to make impersistance

(
SynthDef.new(\multi_sin, {
	arg atk = 10, rel = 10;
	var sig, amp, env;
	env = EnvGen.kr(
		Env.new(
			[0,1,0],
			[atk,rel],
			[1,-1]),
		doneAction:2);
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0,1);
	sig = SinOsc.ar({ExpRand(50,1200)}!8);
	sig = sig * amp * env;
	sig = Splay.ar(sig) * 0.5;  // splay puts an array of signals into stereo field quite nicely
	Out.ar(0, sig);
}).add;
)


// same but saw
(
SynthDef.new(\multi_saw, {
	arg atk = 10, rel = 10,  fund_freq_min = 50, fund_freq_max = 1200;
	var sig, amp, env;
	env = EnvGen.kr(
		Env.new(
			[0,1,0],
			[atk,rel],
			[1,-1]),
		doneAction:2);
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0,1);
	sig = LFSaw.ar({ExpRand(fund_freq_min,fund_freq_max)}!8);
	sig = sig * amp * env;
	sig = Splay.ar(sig) * 0.5;  // splay puts an array of signals into stereo field quite nicely
	Out.ar(0, sig);
}).add;
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
f.free;