s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)

s.freeAll;


// SUPER USEFUL ////////////////////////
//http://www.sfu.ca/~truax/fmtut.html
//http://www.sfu.ca/~truax/Frequency_Modulation.html
//////////////////////////////////////////////////


/* key
freq of Modulator: M
freq of Carrier: C

C : M Ratio
  - used to understand sideband frequencies

USB upper sideband: above the carrier
  - C+M C+2M C+3M C+4M C+5M ....
LSM lower sideband: below the carrier
  - C-M C-2M C-3M C-4M C-5M ...
  - if the LSMs become lower than the carrier, carrier no longer
    represents the fundamental freq of the synth
  -

First general rule:
  For the Carrier to be the fundemntal: M must be greater than or equal to twice C, or else by the 1:1 harmonic ratio
    2:5
      lsb 1: 3, greater than C, 2 remains fundamental
    1:3
      lsb 1: 2, greater than C, C is no longer fundamental freq

Second general rule:
    Harmonic N.F. ratios are always of the form 1:N, and inharmonic ones aren't.
    Harmonic Ratios: 1:1 1:2 1:3 1:4 1:5 1:6 1:7 1:8 1:9
    Inharmonic Ratios: 2:9 2:7 3:8 2:5 2:7 4:9


*/

// SRENGTH OF SIDEBANDS = modulation index is the ratio of amp:freq of mod sig
(
SynthDef(\fm, {
	arg freq=200, modratio=1, carratio=1, modindex=1, amp=0.2, gate=1;
	var env = EnvGen.kr(Env.adsr(0.01, 0.3, 0.4, 0.1), gate, doneAction:2);
	var mod = SinOsc.ar(freq * modratio);
	var car = SinOsc.ar(freq * carratio + (1 + (mod *modindex)), 0) * amp * env;

	Out.ar(0, car ! 2);
}).add;
)

(
Pbind(
	\instrument, \fm,
	\dur, 0.125,
	\freq, Pseq([Pseq([440],24),Pseq([220],24),Pseq([110],24),Pseq([55],24)],inf),
	\modratio, Pseq([Pseries(1,1,6)],inf),
	\modindex, 500,
	\amp, 0.2,

).play;)

(
Pbind(
	\instrument, \fm,
	\dur, 0.125,
	\freq, Pseq([Pseq([55],12),Pseq([82.5],6)],inf),
	//\modratio, Pseq([Pseries(1,1,6)],inf),
	\modratio, Pexprand(6,24,inf).round,
	\modindex, 500,
	\amp, 0.6,

).play;)



( // modratio increasing from 1:1 to 1:6
~fm1 = Pbind(
	\instrument, \fm,
	\dur, 0.125,
	\freq, 100,
	\modratio, Pseq([Pseries(1,2,6)],inf),
	\modindex, 1000,
	\amp, 0.3,

).play(quant:1);
 // modratio increasing from 1:1 to 1:6
~fm2 = Pmono(
	\fm,
	\dur, 0.125,
	\freq, 50,
	\modratio, Pseq([Pseries(1,2,6)],inf),
	\modindex, 1000,
	\amp, 0.6,

).play(quant:1);
)

s.boot;

( // carratio increasing from 1:1 to 6:1
Pbind(
	\instrument, \fm,
	\dur, 0.125,
	\freq, 100,
	\carratio, Pseq([Pseries(1,2,6)],inf),
	\modindex, 1000,
	\amp, 0.3,

).play;
 // carratio increasing from 1:1 to 6:1
Pmono(
	\fm,
	\dur, 0.125,
	\freq, 100,
	\carratio, Pseq([Pseries(1,2,6)],inf),
	\modindex, 1000,
	\amp, 0.6,

).play;
)


( // carratio increasing from 1:1 to 6:1
Pbind(
	\instrument, \fm,
	\dur, 0.125,
	\freq, 100,
	\carratio, Pseq([Pseries(1,2,6)],inf),
	\modindex, 1000,
	\amp, 0.3,

).quant_(1);
 // carratio increasing from 1:1 to 6:1
Pmono(
	\fm,
	\dur, 0.25,
	\freq, 50,
	\carratio, Pseq([Pseries(1,2,6)],inf),
	\modindex, 1000,
	\amp, 0.6,

).quant_(1);
)


// fucking breakthrough man.
// quant has to equal dur * pattern completion
// by that i mean
// this pattern "completes" after 4 or 8 cycles
// its dur = 1 or 0.5
// fmbind quant: 4 * 1 = 4
// fmmono quant: 8 * 0.5
// quant = pattern_complete_cycles * dur
(
Pdef(\fmbind,
	Pbind(
		\instrument, \fm,
		\dur, 0.5,
		//\freq, 26.25 * 2,
		\midinote, Pseq([50, 47, 45, 49], inf),
		\carratio, Pseq([Pseries(1,2,4)],inf),
		\modindex, 1000,
		\amp, 0.5,
	).trace;
).play.quant_(2);
Pdef(\fmmono,
	Pmono(
		\fm,
		\dur, 0.25,
		//\freq, 105,
		\midinote, 45,
		\carratio, Pseq([Pseries(1,2,4)],inf),
		\modindex, 1000,
		\amp, 0.6,
	)
).play.quant_(1);
)

(
Pdef(\fmbind,
	Pbind(
		\instrument, \fm,
		\dur, 0.25,
		\freq, Pexprand(100,150,inf),
		\carratio, Pseq([Pseries(1,2,6)],inf),
		\modindex, 1000,
		\amp, 0.3,
	)
).quant_(1);
Pdef(\fmmono,
	Pmono(
		\fm,
		\dur, 0.5,
		\freq, Pseq(
			[
				Pseq([50], 12), // 4
				Pseq([75], 6),  // 2
				Pseq([85], 6),  // 2
				Pseq([65], 6),  // 2
		], inf),
		\carratio, Pseq([Pseries(1,3,3)],inf),
		\modindex, 1000,
		\amp, 0.6,
	)
).quant_(1);
)

s.boot;

s.quit;

TempoClock.default.tempo = 1;
TempoClock.default.tempo = 0.25; // gets heavy AF when you go slow
TempoClock.default.tempo = 70/60; // in bpm format

