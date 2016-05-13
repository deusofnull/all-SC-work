s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
// from "http://schemawound.com/"
// the full piece
// General notes:
//  CombC is a delay line
// Dust is a random impulse generator from 0 to 1

(
play{
	var dlyLFO = SinOsc.ar(0.01).range(0.03, 0.07);
	var string = CombC.ar(Dust.ar(1), 1, dlyLFO, 30, 1);
	CombC.ar(string, 1, [0.02,0.3], 30, 1, string);
}
)

(
SynthDef.new(\delayNoise,
	{
		arg lfoHZ = 0.01, lfoPhase = 0,
		dustDensity = 1, delayDecay = 30,
		echoPeriodL = 0.2, echoPeriodR = 0.3,
		crossfadeHZ = 0.1, crossfadePitchHz = 99,
		lfoRangeLo=0.001, lfoRangeHi=0.009,
		level=0.6;
		var delayLFO, delay, echo;

		delayLFO = SinOsc.ar(lfoHZ, lfoPhase).range(lfoRangeLo, lfoRangeHi);

		delay = CombC.ar(
			Dust.ar(dustDensity), // in
			1,  // max delay
			delayLFO,  // delaytime
			delayDecay,  // decaytime
			1 // mul
		);
		echo = CombC.ar(
			delay,
			1,
			[echoPeriodL, echoPeriodR],
			delayDecay,
			1,
			delay);
		// crossfade between AM echo and clean echo
		echo = SelectX.ar(
			SinOsc.ar(crossfadeHZ), // which
			[echo, echo * SinOsc.ar(crossfadePitchHz)] // array of inputs
		) / 3;
		echo = Limiter.ar(in:echo, level: level);
		Out.ar(0, echo);
}).add;
)

x = Synth.new(\delayNoise);


x.set("level", 0.5);
x.set("level", 0.01);    // changes the limit of volume (useful for putting synth to sleep)

x.set("dustDensity", 2); // v calm: 0.1, too much > 3
x.set("lfoHZ", 0.5);
x.set("lfoHZ", 100);

x.set("crossfadeHZ", 0.5);      // controls the rate of delay / clean chanel switch
x.set("crossfadePitchHz", 110); // controls the pitch of the crossfade section


x.set("lfoRangeLo", 0.0001);
x.set("lfoRangeHi", 0.009);
x.set("lfoRangeLo", 0.0005);
x.set("lfoRangeHi", 0.005);


x.set("delayDecay", 30, "dustDensity", 1, "lfoHZ", 0.4, "lfoPhase", 0);
x.set("crossfadeHZ", 25);
x.set("echoPeriodL", 0.3, "echoPeriodR", 0.1);

x.free;

s.quit;

(
~freqRoutine = Routine {
	loop {
		~delaySynth.set("crossfadePitchHz", rrand(20, 600));
		5.yield;
	}
	}.play;
)

(
~delayRoutine = Routine {
	arg dustDense=1, lfoHZ=3, crossfadeHZ=3;
	~delaySynth = Synth.new(\delayNoise);
	loop {
		crossfadeHZ = rrand(0.5,20);
		lfoHZ = crossfadeHZ * 0.5;
		postf("crossfadeHZ: " + crossfadeHZ + "\n");
		postf("lfoHZ: " + lfoHZ + "\n");
		~delaySynth.set("dustDensity", 2); // v calm: 0.1, too much > 3
		~delaySynth.set("lfoHZ", lfoHZ);
		~delaySynth.set("crossfadeHZ", crossfadeHZ);
		~delaySynth.set("delayDecay", rrand(15,59)); // v calm: 0.1, too much > 3

		5.0.yield; // re run loop every n seconds
	}
}.play;
)



// Closing notes: This kind of synthesis is super powerful.  Using LFO sines as a delay rate and random impulses creates sweeping grandular sounds with wandering fundamentals and rhythmic qualities.

// I want to create  a pattern that manipulates specifically lfoHZ and crossfadeHZ.  lfoHZ effects the rate of delay rate fluctuation.  crosfadehz controls the rate of selecting between the AM echo and Clean echo.

// I also want to create values to control the range() values which limit the delayLFO sinwave

(
SynthDef.new(\delayNoise,
	{
		arg lfoHZ = 0.01, lfoPhase = 0,
		dustDensity = 1, delayDecay = 30,
		echoPeriodL = 0.2, echoPeriodR = 0.3,
		crossfadeHZ = 0.1;
		var delayLFO, delay, echo;

		delayLFO = SinOsc.ar(lfoHZ, lfoPhase).range(0.001, 0.009);

		delay = CombC.ar(
			Dust.ar(dustDensity), // in
			1,  // max delay
			delayLFO,  // delaytime
			delayDecay,  // decaytime
			1 // mul
		);
		echo = CombC.ar(
			delay,
			1,
			[echoPeriodL, echoPeriodR],
			delayDecay,
			1,
			delay);
		// crossfade between AM echo and clean echo
		echo = SelectX.ar(
			SinOsc.ar(crossfadeHZ), // which
			[echo, echo * SinOsc.ar(099)] // array of inputs
		) / 3;
		Out.ar(0, echo);
}).add;
)

