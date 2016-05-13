//"/home/deusofnull/null_sounds/new_work/samples/loop/quarter_inch_jack_feedback/reverse_frantic_guitar_3_tritones.wav"


~franticBackwardsGuitarPath = "/home/deusofnull/null_sounds/new_work/samples/loop/quarter_inch_jack_feedback/reverse_frantic_guitar_3_tritones.wav"
// 3 samples of guitar, reverse, pitch shifted in 3 parallel tritones
~franticBackwardsGuitar = Buffer.read(s, ~franticBackwardsGuitarPath);

(
SynthDef(\playBuf,
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
s.reboot;
~reverbGroup = Group.basicNew(s,1);
~reverb1 = Synth.tail(~reverbGroup, \reverb1);


(
~qrtInJk = Synth.head(~reverbGroup, \playBuf,
	[
		\bufNum, ~franticBackwardsGuitar,
		\loop, 1,
		\playRate, 1,
		\amp, 0.1,
	]
);
)
~qrtInJk.free;
~qrtInJk.set(\playRate, 0.5);