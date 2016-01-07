s.boot;
s.plotTree;
s.meter;
Server.default.makeGui;
FreqScope.new;



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

(  //synth def for buffer playing
SynthDef.new(\bufplay, {
	arg buf=0, rate=1, amp=1;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = sig * amp;
	Out.ar(0, sig);
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


// percussion audio buffers in a dictionary
/* ========================== HARD stoP =================

cant move forward with the Pbind tutorial until I do the Buffer tutorial.  This is giving me lots of headaches...

*/



Synth.new(\sine);

(
p = Pbind( // Pbind generates event
	\type, \note, // default event type
	\instrument, \sine,
	\dur, 0.1,  // this is delta time, rate of event generation
).play;
)
p.stop;

(
q = Pbind( // Pbind generates event
	\type, \note, // default event type
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], 4).trace,  // use a sequence pattern to control dur
	\freq, Pseq([330, 247, 370, 220], 2).trace,
).play;
)

q.stop;

(
q = Pbind( // Pbind generates event
	\type, \note, // default event type
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,  // only play sequence 4 times
	\midinote, Pseq([60, 65, 67, 74], inf).trace,  // use inherited arg midinote to use midinote numbers instead of cycle per second frequency
).play;
)

q.stop;


(
r = Pbind( // Pbind generates event
	\type, \note, // default event type
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),  // Pwhite generates random number with linear distribution
	\freq, Pexprand(50,4000, inf).trace,  // Pexprand generate random number exponentially
).play;
)

r.stop;

// controlling other arguments of the synthdef with some randomness

(
a = Pbind( // Pbind generates event
	\type, \note, // default event type
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),  // Pwhite generates random number with linear distribution
	\freq, Pexprand(50,4000, inf).trace,  // Pexprand generate random number exponentially
	\atk, Pwhite(2.0,3.0, inf),  // longer synths
	\rel, Pwhite(5.0,10.0, inf), // longer synths
	\amp, Pexprand(0.01,0.2, inf),  // keep amp low bc of multiple synths, but allow for variations
	\pan, Pwhite( -0.8, 0.8, inf),  // pan the stereo field without going too far left or right
).play;
)

a.stop;


// make frequencies harmnoic

(
t = Pbind( // Pbind generates event
	\type, \note, // default event type
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),  // Pwhite generates random number with linear distribution
	\freq, Pexprand(50,4000, inf).round(21).trace,  // use .round(x) to make harmonic in x hz intervals
	\atk, Pwhite(2.0,3.0, inf),
	\rel, Pwhite(5.0,10.0, inf),
	\amp, Pexprand(0.01,0.2, inf),
	\pan, Pwhite( -0.8, 0.8, inf),
).play;
)

t.stop;

// same but with midinote and harmonic inherited arguments
(
u = Pbind( // Pbind generates event
	\type, \note, // default event type
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),  // Pwhite generates random number with linear distribution
	\midinote, 33,
	\harmonic, Pexprand(1,80, inf).round.trace, // play to harmonic note between 1st and 80th partial harmonic
	\atk, Pwhite(2.0,3.0, inf),
	\rel, Pwhite(5.0,10.0, inf),
	\amp, Pkey(\harmonic).reciprocal * 0.3,  // make the amp = reciprocal of partial number, making higher partials quieter
	\pan, Pwhite( -0.8, 0.8, inf),
).play;
)

u.stop;

// Using Pdef, we can alter the Pbind arguments in real time, allowing for great control and removing the global variable
(
Pdef(
	\sinepat,
    Pbind(
	    \instrument, \sine,
	    \dur, Pwhite(0.05, 0.5, inf),
		\midinote, Pseq([37], inf),
	    \harmonic, Pexprand(1,10, inf).round.trace, // play to harmonic note between 1st and xth partial harmonic
	    \atk, Pwhite(2.0,3.0, inf),
	    \rel, Pwhite(5.0,10.0, inf),
	    \amp, Pkey(\harmonic).reciprocal * 0.1,
	    \pan, Pwhite( -0.8, 0.8, inf),
    );
).play;
)


// in 1/16 notes at 128 bpm, or whatever
(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),  // 16th notes
		\stretch, 60/128 * 4,   // 1bar at 4/4 lasts 1.875 seconds
		\buf, Pxrand(d[\highs]++d[\lows], inf), // Pxrand doesnt choose consequitve values
		\rate, 1,
		\amp, 0.3,
	);
).play;
)

 // creating accents and a 4/4 1,3 beat pattern
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


// quantiziing the pattern
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
		\rate, Pexprand(0.75, 2.25, inf),
		\amp, Pseq([0.5, Pexprand(0.15,0.3,7)],inf),
		\pan, Pwhite( -0.8, 0.8, inf),
	);
).play(quant:1.875);
)

// once you quantize something, you need to use a new argument to ensure its kept quantizing when making changes

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
	\sinepat,
    Pbind(
	    \instrument, \sine,
	    \dur, Pseq([1/16], inf),  // 16th notes
		\stretch, 1.875,   // 1bar at 4/4 lasts 1.875 seconds
		\note, Pxrand([0,3,5,9,12], inf),
	    \atk, 0.005,
		\rel, Pexprand(0.01, 0.5, inf),
		\amp, Pexprand(0.05, 0.5, inf),
	    \pan, Pwhite( -0.8, 0.8, inf),
    );
).play(quant:1.875);
)
// edit version with quant_ syntax
(
Pdef(
	\sinepat,
    Pbind(
	    \instrument, \sine,
	    \dur, Pseq([1/16], inf),  // 16th notes
		\stretch, 1.875,   // 1 4/4 bar at 128bpm lasts 1.875 seconds
		\note, Pxrand([0, 3, 5, 9, 10,11,12], inf),
	    \atk, 0.005,
		\rel, Pexprand(0.01, 0.5, inf),
		\amp, Pexprand(0.05, 0.5, inf),
	    \pan, Pwhite( -0.8, 0.8, inf),
    );
).quant_(1.875);
)

