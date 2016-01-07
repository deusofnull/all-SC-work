(
s.plotTree;
s.meter;
Server.default.makeGui;
FreqScope.new;)

(
d = Dictionary.new();
d.add(\highs -> PathName.new("/home/deusofnull/null_sounds/Recordings/clipped_audio/highs").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
d.add(\lows -> PathName.new("/home/deusofnull/null_sounds/Recordings/clipped_audio/lows").entries.collect({
	arg sf;
	Buffer.read(s, sf.fullPath);
	});
);
)

d[\tinks].choose.play;
d[\mids].choose.play;
d

(  //synth def for buffer playing
SynthDef.new(\bufplay, {
	arg buf=0, rate=1, amp=1;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = sig * amp;
	Out.ar(0, sig, amp);
}).add;
)


Synth.new(\bufplay, [\buf, d[\mids].choose.bufnum]);

(
SynthDef.new(\sine, {
	arg freq = 440, atk = 0.005, rel=0.3, amp = 0.5, pan = 0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk, rel], [1,-1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0,sig);
}).add;
)

(
SynthDef.new(\saw, {
	arg freq = 220, atk = 0.005, rel=0.3, amp = 0.5, pan = 0;
	var saw, env;
	env = EnvGen.kr(Env.new([0,1,0], [atk, rel], [1,-1]), doneAction:2);
	saw = Saw.ar(freq);
	saw = Pan2.ar(saw, pan, amp);
	Out.ar(0, saw);
}).add;
)

(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),  // 16th notes
		\stretch, 60/128 * 4,   // 1bar at 4/4 lasts 1.875 seconds
		\buf, Pseq(
			[
				Prand(d[\lows], 1),
				Prand(d[\highs]++d[\lows],7),
				Prand(d[\highs], 1),
				Prand(d[\highs]++d[\lows],7),
			], inf
		), //low sound on 1, high on 3
		\rate, 1,
		\amp, Pseq([0.5, Pexprand(0.15,0.3,7)],inf),
	);
).play;
)

(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),  // 16th notes
		\stretch, 1.875,   // 1bar at 4/4 lasts 1.875 seconds
		\buf, Pseq(
			[
				Prand(d[\lows], 1),
				Prand(d[\highs]++d[\lows],7),
				Prand(d[\highs], 1),
				Prand(d[\highs]++d[\lows],7),
			], inf
		), //low sound on 1, high on 3
		\rate, Pexprand(3.5, 6.0, inf),
		\amp, Pseq([0.5, Pexprand(0.15,0.3,7)],inf),
		\pan, Pwhite( -0.8, 0.8, inf),
	);
).quant_(1.875);
)

// and a more melodic sinpat outputting 16th notes at 128 bpm in 4/4
(
Pdef(
	\sawpat,
    Pbind(
	    \instrument, \saw,
	    \dur, Pseq([1/16], inf),  // 16th notes
		\stretch, 1.875,   // 1bar at 4/4 lasts 1.875 seconds
		\note, Pxrand([0,3,5,6,8,10,12,13], inf),  // major key, T T S T T T S,
		\gtranspose, 12,
	    \atk, 0.005,
		\rel, Pexprand(0.01, 0.5, inf),
		\amp, Pexprand(0.05, 0.5, inf),
	    \pan, Pwhite( -0.8, 0.8, inf),
    );
).play(quant:1.875);
)
// edit version with quant_ syntax
// different scales!!! major, minor, harmonic minor
(
Pdef(
	\sinepat,
    Pbind(
	    \instrument, \sine,
	    \dur, Pseq([1/16], inf),  // 16th notes
		\stretch, 1.875,   // 1 4/4 bar at 128bpm lasts 1.875 seconds
		\note, Pseq([0,3,5,6,8,10,12], inf),  // major key, T T S T T T S
		\gtranspose,  -30,   // transposing the notes
	    \atk, 0.005,
		\rel, 0.3,
		\amp, Pexprand(0.05, 0.5, inf),
	    \pan, Pwhite( -0.8, 0.8, inf),
    );
).play(quant:1.875));
)

(
Pdef(
	\sinepat,
    Pbind(
	    \instrument, \sine,
	    \dur, Pseq([1/16], inf),  // 16th notes
		\stretch, 1.875,   // 1 4/4 bar at 128bpm lasts 1.875 seconds
		\note, Pseq([0,1,3,5,6,9,11], inf),  // minor scale, T S T T S T T
		\gtranspose,  -10,   // transposing the notes
	    \atk, 0.005,
		\rel, 0.3,
		\amp, Pexprand(0.05, 0.5, inf),
	    \pan, Pwhite( -0.8, 0.8, inf),
    );
).quant_(1.875);
)

(
Pdef(
	\sinepat,
    Pbind(
	    \instrument, \sine,
	    \dur, Pseq([1/16], inf),  // 16th notes
		\stretch, 1.875,   // 1 4/4 bar at 128bpm lasts 1.875 seconds
		\note, Pxrand([0,1,3,5,6,10,12], inf),  // harmonic minor scale, T S T T S TS T
		\gtranspose,  -5,   // transposing the notes
	    \atk, 0.005,
		\rel, 0.3,
		\amp, Pexprand(0.05, 0.5, inf),
	    \pan, Pwhite( -0.8, 0.8, inf),
    );
).play(quant:1.875);
)

// in 2/4 128 bpm
(
Pdef(
	\sinepat,
    Pbind(
	    \instrument, \sine,
	    \dur, Pseq([1/8], inf),  // 8th notes
		\stretch, 0.9375,   // 1 2/4 note lasts 0.9375 seconds
		\note, Pxrand([0,3,5,6,8,10,12,13], inf),  // major key, T T S T T T S,
		\gtranspose, 0,
	    \atk, 0.005,
		\rel, Pexprand(0.01, 0.5, inf),
		\amp, Pexprand(0.05, 0.5, inf),
	    \pan, Pwhite( -0.8, 0.8, inf),
    );
).play(quant:0.9375);
)

(
Pdef(
	\sinepat,
    Pbind(
	    \instrument, \sine,
	    \dur, Pseq([1/8], inf),  // 8th notes
		\stretch, 0.9375,   // 1 2/4 note lasts 0.9375 seconds
		\note, Pxrand([0,1,3,5,6,10,12], inf),  // harmonic minor scale, T S T T S TS T
		\gtranspose,  0,   // transposing the notes
	    \atk, 0.005,
		\rel, 0.3,
		\amp, Pexprand(0.05, 0.5, inf),
	    \pan, Pwhite( -0.8, 0.8, inf),
    );
).quant_(0.9375);
)