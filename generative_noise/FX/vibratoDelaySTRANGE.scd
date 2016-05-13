(
SynthDef(\vibratoDelay, {
	arg vibLfoHzLo=5, vibLfoHzHi=10;

	var input, effect, vibrato;

	input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0
	vibrato = SinOsc.ar(Rand(vibLfoHzLo,vibLfoHzHi),0,1,0);

	effect= DelayC.ar(input, 1, vibrato); //max delay of one second

	Out.ar(0,effect); //adds to bus 0

}).add;
)
~delayFx = Synth.new(\vibratoDelay, [\delaytime,0.5]);

~delayFx.free;

(
~delayRoutine = Routine {
	arg inarg;
	var vibLfoHzLo=5, vibLfoHzHi=10;
	~delayFx.free;
	vibLfoHzLo= rrand(1,25);
	vibLfoHzHi= vibLfoHzLo*2;
	~delayFx = Synth.new(\vibratoDelay, [\delaytime,0.5]);
	loop {
		~delayFx.free;
		~delayFx = Synth.new(\vibratoDelay, [\delaytime,0.5]);
		5.0.yield; // re run loop every n seconds
	}
}.play;
)
~delayRoutine.stop;

s.quit;