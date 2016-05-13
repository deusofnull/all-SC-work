// from http://composerprogrammer.com/teaching/supercollider/sctutorial/11.1%20Physical%20Modelling.html

//A simple form of physical modelling sound synthesis (related to what we've just heard above) is Karplus-Strong synthesis.

//You start with a noise source in a delay line of length based on the pitch of note you would like. Then you successively filter the delay line until all the sound has decayed. You get a periodic sound because the loop (the delayline) is of fixed length.

Pluck // a prebuilt Karplus-Strong synthesis unit
  // used for physical modeling of sound

(
{Pluck.ar(
	in:WhiteNoise.ar(0.1),
	trig:Impulse.kr(1),
	maxdelaytime:440.reciprocal,
	delaytime:440.reciprocal,
	decaytime:10,
	coef:MouseX.kr(-0.999, 0.999))
	}.play(s)
)

LPZ1

//This can be broken down as individual UGens if you're careful:
(
{var freq,time, ex, delay, filter, local;
freq= 200;

	time= freq.reciprocal;
	ex= WhiteNoise.ar(EnvGen.kr(Env([1.0,1.0,0.0,0.0], [time,0,100])));
	local= LocalIn.ar(1);
	filter= LPZ1.ar(ex+local); //apply filter
	delay= DelayN.ar(filter, time, time-ControlDur.ir);
	ControlDur.ir.poll;
	LocalOut.ar(delay*0.95);
	Out.ar(0, Pan2.ar(filter,0.0))
}.play
)
//I can modulate the length of the delay line to make a vibrato:
(
{
var freq,time, ex, delay, filter, local;
freq= 440;

	time= freq.reciprocal;
	ex= WhiteNoise.ar(EnvGen.kr(Env([1.0,1.0,0.0,0.0], [time,0,100])));
	freq= SinOsc.ar(12, 0, 10, freq);
	time= freq.reciprocal;
	local= LocalIn.ar(1);
	filter= LPZ1.ar(ex+local); //apply filter
	//maximum delay time is 440-10
	delay= DelayN.ar(filter, 430.reciprocal, time-ControlDur.ir);
	LocalOut.ar(delay*0.99);
	Out.ar(0, Pan2.ar(filter,0.0))
}.play
)

// contributions from Thor Magnusson, alternative viewpoint
// we use a noise ugen to generate a burst

(
// let's create a synthdef using Karplus-Strong
// we use Comb delay to create the delay line that creates the tone
SynthDef(\ks_guitar, { arg note, pan, rand, delayTime, noiseType=1;
	var x, y, env;
	env = Env.new(#[1, 1, 0],#[2, 0.001]);
	// A simple exciter x, with some randomness.
	x = Decay.ar(
		in:Impulse.ar(
			freq:0,
			phase:0,
			mul:rand),
		decayTime:0.1+rand,
		mul:WhiteNoise.ar);
	// Note that delayTime is controlling the pitch here. The delay time is reciprocal to the pitch. // 1/100th of a sec is 100Hz, 1/400th of a sec is 400Hz.
 	x = CombL.ar(
		in:x,
		maxdelaytime:0.05,
		delaytime:note.reciprocal,
		decaytime:delayTime,
		mul:EnvGen.ar(env, doneAction:2));
	x = Pan2.ar(x, pan);
	Out.ar(0, LeakDC.ar(x));
}).store;
)

(
{
	20.do({
		Synth(\ks_guitar,
			[
				\note, 220+(400.rand),
				\pan, 1.0.rand2,
				\rand, 0.1+0.1.rand,
				\delayTime, 2+1.0.rand
			]
		);
	  (1.0.rand + 0.5).wait;
	});
}.fork
)

// here using patterns
(
a = Pdef(\kspattern,
	Pbind(
		\instrument, \ks_guitar, // using our sine synthdef
		\note, Pseq.new([60, 61, 63, 66], inf).midicps, // freq arg
		\dur, Pseq.new([0.25, 0.5, 0.25, 1], inf),  // dur arg
		\rand, Prand.new([0.2, 0.15, 0.15, 0.11], inf),  // dur arg
		\pan, 2.0.rand-1,
		\delayTime, 2+1.0.rand;  // envdur arg
		)
).play;
)


// compare using whitenoise and pinknoise as an exciter:


// whitenoise
({
	var burstEnv, att = 0, dec = 0.001;
	var burst, delayTime, delayDecay = 0.5;
	var midiPitch = 69; // A 440
	delayTime = midiPitch.midicps.reciprocal;
	burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
	burst = WhiteNoise.ar(burstEnv);
	CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);
}.play
)
// whitenoise exciters are sharp, steel string, very twangy

// pinknoise
({
	var burstEnv, att = 0, dec = 0.001;
	var burst, delayTime, delayDecay = 0.5;
	var midiPitch = 69; // A 440
	delayTime = midiPitch.midicps.reciprocal;
	burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
	burst = PinkNoise.ar(burstEnv);
	CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);
}.play)
// Pinknoise exciters are softer, almost like nylon strings

(
SynthDef(\KS_pink, {
	arg midiPitch=69, delayDecay = 1.0;
	var burstEnv, atk = 0, dec= 0.001;
	var signalOut, delayTime;

	// this controls pitch:  input pitch and 1 octave higher aswell
	delayTime = [midiPitch, midiPitch + 12].midicps.reciprocal;
	burstEnv = EnvGen.kr(Env.perc(atk, dec));
	signalOut = PinkNoise.ar(burstEnv); // pinknoise exciter
	signalOut = CombL.ar( // CombL for pitch made by delayTime
		in: signalOut,
		maxdelaytime: delayTime,
		delaytime: delayTime,
		decaytime: delayDecay,
		add: signalOut
	);
	DetectSilence.ar(signalOut, doneAction:2);
	Out.ar(0, signalOut);
	}
).store;

)

(
r = Routine {
	loop{
		Synth(\KS_pink,
			[
				\midiPitch, rrand(30,80), // choosePitch
				\delayDecay, rrand(0.1, 3.0), // chooseDuration
			]
		);
		//Choose a wait time before next event
		//0.5.wait;
		[0.125, 0.125, 0.25].choose.wait;
	}
}.play;
)

// more filter UGens for modelling instrument bodies and oscilators for sources

Klank // For modelling the resonant modes of a struck object----------
{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([0.007, 0.007])) }.play;

Ringz  // for modelling a singular resontant mode of a struck object. one Ringz is equivalent to one component of a Klank----------------------------
// modulate ring
{ Ringz.ar(Impulse.ar(6, 0, 0.3), 2000, XLine.kr(0.04, 4, 8)) }.play

Resonz // resonance at a given frequency

// modulate bandwidth
{ Resonz.ar(WhiteNoise.ar(0.5), 1000, XLine.kr(1, 0.001, 8)) }.play

// modulate bandwidth opposite direction
{ Resonz.ar(WhiteNoise.ar(0.5), 1000, XLine.kr(0.001, 1, 8)) }.play

// Idea for a piece:  Two Resonz filters with changing bandwidth, out of phase with one another.

// Quick and dirty example:
(
r = Routine {
	var ascPitch;
	var descPitch;
	loop{
		post("ascPitch:  " ); ascPitch = rrand(200,2000).postln;
		post("descPitch: " ); descPitch = rrand(200,2000).postln;
		~asc.free; ~desc.free;
		// first the descending bandwith filter
		~desc = { Resonz.ar(WhiteNoise.ar(0.5), descPitch, XLine.kr(1, 0.001, 8)) }.play;
		0.1.wait; // as to become out of phase
		// next the ascending bandwith filter
		~asc = { Resonz.ar(WhiteNoise.ar(0.5), ascPitch, XLine.kr(0.001, 1, 8)) }.play;
		10.wait;
	}
}.play;
)


s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
