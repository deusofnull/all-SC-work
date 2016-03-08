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
		crossfadeHZ = 0.1;
		var delayLFO, delay, echo;

		delayLFO = SinOsc.ar(lfoHZ, lfoPhase).range(0.001, 0.009);
		delay = CombC.ar(Dust.ar(dustDensity), 1, delayLFO, delayDecay, 1);
		echo = CombC.ar(delay, 1, [echoPeriodL, echoPeriodR], delayDecay, 1, delay);
		// crossfade between AM echo and clean echo
		echo = SelectX.ar(SinOsc.ar(crossfadeHZ), [echo, echo * SinOsc.ar(99)]) / 3;
		Out.ar(0, echo);
}).add;
)

x = Synth.new(\delayNoise);

x.set("delayDecay", 30, "dustDensity", 2, "lfoHZ", 0.4, "lfoPhase", 0);
x.set("crossfadeHZ", 200);
x.set("echoPeriodL", 0.3, "echoPeriodR", 0.04);

x.free;

s.quit;


// Closing notes: This kind of synthesis is super powerful.  Using LFO sines as a delay rate and random impulses creates sweeping grandular sounds with wandering fundamentals and rhythmic qualities.

// I want to create  a pattern that manipulates specifically lfoHZ and crossfadeHZ.  lfoHZ effects the rate of delay rate fluctuation.  crosfadehz controls the rate of selecting between the AM echo and Clean echo.

// I also want to create values to control the range() values which limit the delayLFO sinwave

