// |delayTime=0.01, decayTime=1, inBus=0|
~reverbGroup = Group.basicNew(s,1);


~reverb1 = Synth.tail(~reverbGroup, \reverb1);
~reverb1.free;

(
~qrtInJk = Synth.head(~reverbGroup, \quarterInchJerkBuff,
	[
		\bufNum, ~quarterInchJerk,
		\loop, 1,
		\playRate, 1,
		\amp, 0.1,
	]
);
)
~qrtInJk.free;
~qrtInJk.set(\playRate, 0.3);

(
~reverb1.free;
~reverb1 = Synth.tail(~reverbGroup, \reverb1);
~quartJerkRoutine = Routine {
	var start_rate = 0.1, change;
	~qrtInJk.free;
	~qrtInJk = Synth.head(~reverbGroup, \quarterInchJerkBuff,
		[\bufNum, ~quarterInchJerk, \loop, 1,\playRate, 1,\amp, 0.1,]);
	loop {
		change = rrand(5, 15);
		postf("change in " + change + "seconds + \n");
		/*if(start_rate > 0.7,
			{start_rate = 0.1},
			{start_rate = start_rate + 0.1}
		);*/

		~qrtInJk.set(\playRate, rrand(0.1,0.5));
		change.yield;
	}
}.play;
)
~reverb1.set(\delayTime, 10);
~reverb1.set(\decayTime, 4);
~qrtInJk.set(\playRate, 2);

s.quit;`
