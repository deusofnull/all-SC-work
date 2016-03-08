s.boot;
s.quit;

MIDIClient.init;

MIDIIn.connectAll;

// these functions output an array of values:
// [ 0, 2, 0, 1310720 ]
//  control val, intra-channel, midi channel, xxx???


MIDIFunc.cc({arg ...args; args.postln}, 0); // slider cc0
MIDIFunc.cc({arg ...args; args.postln}, 7); // slider cc7

MIDIdef.cc(\slide1, {arg ...args; args.postln}, 1) // slider cc1


MIDIdef.cc(\slide1, {arg ...args; args.postln}, 2, 0) // slider cc1


// Eli Fieldsteel NanoKontrol 2 Code reference

~nkResp.remove;

(
~nkResp = CCResponder({
	|src, chan, num, val|
	var row, column;
	(
		Synth.new(\FM [\freq, val]);
	);
});
)

~nkResp.remove;

(
~nkResp = CCResponder({
	|...args|
	var row, column;
	~midi_val = args[3];
	(
		Pdef(\voice,
			Pbind(
				\instrument, \FM,
				\dur, 0.125,
				\modAdd, Pseq([~midi_val] * 50 + 100, inf),
				\atk, Pkey(\dur) / 2,
				\rel, Pkey(\dur) / 2,
				\amp, 0.3,
			);
		).play;
	)
});
)

Server.default.makeGui;
s.reboot;
Synth.new(\FM ,[\freq, 2500]);

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
	\pregain, 10,
	\amp, 0.05
]);
)

d.set(\pregain, 100);

(
Pdef(\voice,
	Pbind(
		\instrument, \FM,
		\dur, 0.125,
		\freq,  Pseq([60, 2000], inf),
		\modAmp,  Pseq([800, 400, 200], inf),
		//\modAdd, Pseq([180, 230, 280, 200, 250, 300, \rest, \rest],inf) * Pexprand(0.9, 1.1, inf),
		//\modAdd, Pseq([180, 200, 180, 185, 205, 185, \rest, \rest],inf),
		\modAdd, Pseq([800, 400, 1600], inf),
		\atk, Pkey(\dur) / 2,
		\rel, Pkey(\dur) / 2,
		\amp, 0.3,
	);
).play;
)


// basic FM to play with MIDI on
(
SynthDef.new(\FM, {
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

