(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)
s.quit;

~scaleLenShort = Pfunc({ exprand(2,12).round;}).asStream; // how far up in scale to go
~scaleLen = Pfunc({ exprand(2,24).round;}).asStream; // 2 octaves long

~scaleLen.next();

TempoClock.default.tempo = 1;
TempoClock.default.tempo = 2;

TempoClock.default.tempo = 30; // v fun to go fast
TempoClock.default.tempo = 15; // v fun to go fast

TempoClock.default.tempo = 0.25; // gets heavy AF when you go slow
TempoClock.default.tempo = 120/60; // in bpm format
TempoClock.default.tempo = 80/60; // in bpm format


// as a Pmono, monophonic synth with one voice wavering into  each newly genearted sound
(
~p1 = Pmono(
	\bass,
	\scale, Scale.minor,
	\degree, Pseq([Pseries(0, Prand([1,2],inf), {~scaleLen.next()})] ,inf),
	//\dur, 0.5,
	\dur, Pwrand(
		[0.125,0.25,0.5,1,5],
		[1, 2, 0.5, 0.5, 0.25].normalizeSum,
		inf),
	//\detune, Pexprand(0.1, 1.5,inf),
	\detune, Pexprand(0.75, 1.25,inf),
	\slideTime, Pseries(0.17, 0.01, inf),
	\preamp, 1000,
	\lpffreq, Pexprand(550,750,inf),
	\amp, 0.3,
).trace.play;
)
~p1.stop;

// as a Pbind, events driven by this one are more atomic, separate sound instances
(
~p2 = Pbind(
	\instrument, \bass,
	//\degree, Pseq([Pseries(0, Prand([1,6,12],inf), {~scaleLenShort.next()})] ,inf),
	\scale, Scale.minor,
	//\scale, Scale.melodicMinor,
	\degree, Pxrand([
		[0,3,5],
		[0,4,5],
		[0,3,6],
		[0,4,6],
	],inf).trace,
	\ctranspose, Pwhite(-8.0,5.0,inf).round.trace,
	\slideTime, 0.25,
	\dur, Pexprand(1, 2.5,inf),
	\detune, Pexprand(0.95, 1.05,inf).trace,
	\preamp, 100,
	\lpffreq, Pexprand(550,750,inf),
	\amp, 0.15
).play;
)

~p2.stop;

s.reboot;

(
~kick = Pbind(
	\instrument, \bass,
	\dur, Pseq([0.5,0.5,0.5,2],inf),
	\midinote, Pseq(
	[
		Pseq([25], 15),
		Pseq([23], 1)
	], inf),
	\carratio, 3,
	\modindex, 75,
	// \modindex, Pexprand(500,750,inf).round(25),
	\atk, 0.05,
	/*\decay, 0.1,
	\sus, 0.02,
	\rel, 0.1,*/
	\amp, 0.65,
).play;
)

~kick.stop;

// THINGS LEFT TO DO
/*

  - Could be cool to synce up ~kick, ~p1 and ~p2.
  - Work on Kick more... it's boring rn
  - p2 is really  beautiful, p1 is scary and wrong,
    - either widen that gap and make them complimentary or make them more alike
  - make p2's chord selection more than simple triads that i dont understand
    - haha
  - Definitely think what the Tempoclock should be set at.  a lot of these values are set for when its 0.25...
*/


// synthdefs
(
SynthDef(\bass, {
	arg freq=220, gate=1, amp=0.5, slideTime=0.17, lpffreq=550, width=0.15,
	detune=1.005, preamp=4, atk=0.01, decay=0.3, sus=0.4, rel=0.1 ;
	var sig, env= Env.adsr(atk, decay, sus, rel);
	freq = Lag.kr(freq, slideTime);
	sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
	sig = LPF.ar(sig, lpffreq);
	Out.ar(0, sig ! 2);
}).add;)

Synth(\bass);
