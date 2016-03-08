s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)

// granular synth

( // plot example of a two example grains
{
	var singrain1, singrain2;

	singrain1 = SinOsc.ar(440,0,XLine.kr(1.0, 0.0001, 0.05));
	singrain2 = FSinOsc.ar(880, 0.0, Line.kr(1.0,0, 0.05));

	[singrain1, singrain2]
}.plot(0.1,s)
)

(
SynthDef(\singrain,
	{
		arg pan, freq, amp, modFreq, modPhase, modAmp;
		var grain;

		grain = SinOsc.ar(freq * SinOsc.ar(modFreq, modPhase, modAmp), 0, amp) * (XLine.kr(1.001, 0.001, 0.1, doneAction:2) - 0.001 );

		Out.ar(0, Pan2.ar(grain, pan))
	}
).add;
)

Synth(\singrain, [\freq, rrand(100,10000), \amp, exprand(0.05, 0.1), \pan, 1.0.rand2]);

(
{
	50.do{ arg i;
		Synth(\singrain,
			[
				\freq, rrand(20,400),
				\amp, exprand(0.05, 0.1),
				\pan, 1.0.rand2,
				\modFreq, rrand(40,800),
				\modPhase, 0,
				\modAmp, exprand(2, 100),
		]);
		rrand(0.01,0.001).wait;
	};
}.fork;
)
//Over time, we can change the characteristics of the swarm, for example, playing with its density, and control individual parameters of grains within tendency masks or following certain paths

//schedule 200 random grains over time, decreasing the range of allowed random frequencies and lowering the density over time
(
{
200.do{arg i;
var timeprop = (i/199.0)**3;

	Synth(\singrain,[\freq,exprand(100,5000-(20*i)),\amp, exprand(0.05,0.1), \pan, 1.0.rand2]);
	rrand((timeprop*0.1).max(0.01),timeprop*0.3).wait
};
}.fork
)

