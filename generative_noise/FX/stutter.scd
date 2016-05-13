// Not super happy with this one...


// code from http://sccode.org/1-50T by user: snappizz
// Source audio: simple sweep
{ Pulse.ar(XLine.kr(100, 1000, 5)) * 0.1!2 }.play;

// All you need is a varying delay.
// In this example, an 0.2s delay is switched on every other 0.2s. So every 0.2s of audio is repeated once.
(
{
    var snd = Pulse.ar(XLine.kr(100, 1000, 5));
    snd = DelayC.ar(snd, 0.2, LFPulse.ar((0.2 * 2).reciprocal) * 0.2);
    snd * 0.1!2;
}.play;
)

// More general version using Stepper instead of LFPulse. You can control the length of the repeat and the number of repeats.
(
{ |fragmentlength = 0.2, numrepeats = 3|
    var trig, reset, del, snd;
    snd = Pulse.ar(XLine.kr(100, 1000, 5));
    trig = Impulse.ar(fragmentlength.reciprocal);
    reset = Impulse.ar(0); // if we don't do this the stepper will start at 1...
    del = Stepper.ar(trig, reset, 0, numrepeats - 1) * fragmentlength;
    snd = DelayC.ar(snd, 10, del);
    snd * 0.1!2;
}.play(args: [\fragmentlength, 0.2, \numrepeats, 2]);
)

// With some enhancements, we can allow the reset counter to be out of sync.
(
{ |holdlength = 0.5, fragmentlength = 0.2|
    var reset, phase, fragment, del, snd;
    snd = Pulse.ar(XLine.kr(100, 1000, 5));

    reset = Impulse.ar(holdlength.reciprocal);
    phase = Sweep.ar(reset);
    // this is the easiest way to make an Impulse resettable? seriously?
    fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / fragmentlength % 1);
    del = Latch.ar(phase, fragment);
    snd = DelayC.ar(snd, 10, del);
    snd * 0.1!2;
}.play;
)

// Many stutter plugins let you play back the audio at a different rate.
// This is a little trickier. Speeding up 2x not as easy as adding a Sweep.ar(fragment) because otherwise you get negative delays.
// So you have to add in an extra delay equal to fragmentlength.
(
{ |holdlength = 0.5, fragmentlength = 0.2, rate = 1.5|
    var reset, phase, fragment, del, snd;
    snd = Pulse.ar(XLine.kr(100, 1000, 5));
    reset = Impulse.ar(holdlength.reciprocal);
    phase = Sweep.ar(reset);
    fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / fragmentlength % 1);
    del = Latch.ar(phase, fragment) + ((fragmentlength - Sweep.ar(fragment)) * (rate - 1));
    snd = DelayC.ar(snd, 10, del);
    snd * 0.1!2;
}.play(args: [\holdlength, 0.5, \fragmentlength, 0.1, \rate, 0.5]);
)

(
SynthDef(\stutterWithRate, {
	|holdLen = 0.5, fragmentLen = 0.2, rate = 1.5,
	inBus=0|
	var input, output, reset, phase, fragment, delay;

	input = In.ar(inBus, 2);
	reset = Impulse.ar(holdLen.reciprocal);
	phase = Sweep.ar(reset);

	// this is the easiest way to make an Impulse resettable? seriously?
	fragment = {|ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / fragmentLen % 1);


	delay = Latch.ar(phase, fragment) + ((fragmentLen - Sweep.ar(fragment)) * (rate - 1 ));

	output = DelayC.ar(input, 10, delay);
	output * 0.01!2;
	Out.ar(0, output);
}).add;
)

~stutterGroup = Group.basicNew(s,1);


(
~stutterWithRate = Synth.tail(~stutterGroup, \stutterWithRate,
	[
		\rate, 0.5,
		\holdLen, 0.1,
		\fregmentLen, 0.05,
	]
	);
)
~stutterWithRate.set(\rate, 1.75);
~stutterWithRate.set(\fregmentLen, 0.01);
~stutterWithRate.set(\holdLen, 0.06);
~stutterWithRate.free;



~bassAdsr = Synth.head(~stutterGroup, \bass_adsr);
~bassAdsr.free;

(
Synth.head(~stutterGroup,\bass_perc,
	[
		\atk, 0.5,
		\rel, 0.25,
		\curve, -4,

	]
);
)



postln("heyeyeye");

(
SynthDef(\stutter, {
	|holdLen = 0.5, fragmentLen = 0.2,inBus=0, amp=0.3|
	var input, output, reset, phase, fragment, delay;

	input = In.ar(inBus, 2);

    reset = Impulse.ar(holdLen.reciprocal);
    phase = Sweep.ar(reset);
    // this is the easiest way to make an Impulse resettable? seriously?
    fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / fragmentLen % 1);
    delay = Latch.ar(phase, fragment);
    output = DelayC.ar(input, 10, delay);
    output = output * amp!2;

	Out.ar(0, output);
}).add;
)


(
~stutter = Synth.tail(~stutterGroup, \stutter,
	[
		\holdLen, 3,
		\fregmentLen, 0.25,
	]
	);
)

~stutter.set(\holdLen, 6);
~stutter.set(\fregmentLen, 1);
~stutter.set(\amp, 0.1);
~stutter.free;



~bassAdsr = Synth.head(~stutterGroup, \bass_adsr);
~bassAdsr.free;
