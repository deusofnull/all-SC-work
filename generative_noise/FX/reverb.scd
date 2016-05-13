(
SynthDef(\reverb1, {
	|delayTime=0.01, decayTime=1, inBus=0|
	var input;
	var numc, numa, temp;

	input = In.ar(inBus, 2);

	numc = 4; // number of comb delays
	numa = 6; // number of allpass delays

	// reverb predelay time
	temp = DelayN.ar(input, 0.048, 0.048);

	temp = Mix.fill(numc, {
		CombL.ar(
			in:temp,
			maxdelaytime:0.1,
			delaytime:rrand(0.01, 0.1),
			decaytime: 5)
		}
	);

	// chain of 4 allpass delays on each of two channels (8 total)
	numa.do( {
		temp = AllpassN.ar(
			temp,
			maxdelaytime: 0.051,
			delaytime:
			[
				rrand(0.01, 0.05),
				rrand(0.01, 0.05)
			],
			decaytime: 1
		)
	});
	temp = Limiter.ar(temp, 0.9);
	// add original sound to reverb and play
	Out.ar(0, (0.2 * temp));
}).add
)
~reverbGroup = Group.basicNew(s,1);


~reverb1 = Synth.new(\reverb1, addAction:'addToTail');
~reverb1.free;
				