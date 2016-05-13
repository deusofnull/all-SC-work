//"/home/deusofnull/null_sounds/new_work/samples/loop/quarter_inch_jack_feedback/3.2_seconds_loopable.wav"
~quarterInchJerkFilePath ="/home/deusofnull/null_sounds/new_work/samples/loop/quarter_inch_jack_feedback/3.2_seconds_loopable.wav";

~quarterInchJerk = Buffer.read(s, ~quarterInchJerkFilePath);

(
SynthDef(\quarterInchJerkBuff,
	{ | amp=0.3, out=0, bufNum=0, playRate=1, trigger=1, startPos=0, loop=0, doneAction=2|
		Out.ar(out,
			PlayBuf.ar(
				numChannels: 2, bufnum: bufNum, rate:playRate,
				trigger:trigger, startPos: startPos, loop:loop,
				doneAction:doneAction) * amp
		);
	}
).add;
)

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
~qrtInJk.set(\playRate, 0.2);



~quarterInchJerk.duration();
s.quit;

(
Pdef(\quarterInchJerkPattern,
	Pbind(
		\instrument, \quarterInchJerkBuff,
		\dur, ~quarterInchJerk.duration(),
		\playRate, Pseq([0.25, 0.5, 0.75, 1, 1.25, 1.5], inf),
		\loop, 0,
		\amp, 0.1,
	)
).play.quant_(~quarterInchJerk.duration());
)

(
Pdef(\quarterInchJerkPattern,
	Pbind(
		\instrument, \quarterInchJerkBuff,
		\dur, ~quarterInchJerk.duration() / 3,
		\playRate, Pxrand([0.25, 0.5, 0.75, 1, 1.25, 10], inf),
		\loop, 0,
		\amp, 0.1,
	)
).play.quant_(~quarterInchJerk.duration() / 3);
)

(
Pdef(\quarterInchJerkPattern,
	Pbind(
		\instrument, \quarterInchJerkBuff,
		\dur, ~quarterInchJerk.duration() / 1.5,
		\playRate, Pexprand(0.1, 0.8, inf),
		\loop, 0,
		\amp, 0.1,
	)
).play.quant_(~quarterInchJerk.duration() / 1.5);
)
Pdef('quarterInchJerkPattern').stop;