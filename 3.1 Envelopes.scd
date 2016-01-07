// server gui: volume control, recording, CPU usage
Server.default.makeGui;
// osciliscope
FreqScope.new;

//short
s={SinOsc.ar(210, 0, Line.kr(0.1,0.0,0.3))}.play;
//long
l={SinOsc.ar(115, 0, Line.kr(0.1,0.0,2))}.play;

l.free;
s.free;

// problem with these is the synths remain defined and in memory
// solution is using doneAction

s={SinOsc.ar(330, 0, Line.kr(0.1,0,1,doneAction:2))}.play;


// =====================Basic Envelopes ============================
// first env array is the Y values of the envelope
// second Env array is the X values (time) between the points
Env([1,0,1],[1,1]).plot;

Env([1,2,3,4],[4,4,4,4]).plot;

Env([0,1,0],[1.0,0.5]).plot


// ===================Specialized Envelopes ===========================

//linen has attackTime, sustainTime, releaseTime, level, curve
Env.linen(   0.3,        0.5,         0.1,          1,     1).plot;

//adsr is shaped like a traditional analog attack-decay-sustain-release envelope
  //attackTime, decayTime, sustainLevel, releaseTime, peakLevel, curve
Env.adsr(0.01,  0.5,         0.5,          0.1,        1.0,       0).plot;

// perc is good for percussion sounds:
// perc args attacktime, releaseTime, level, curve
Env.perc(     0.0,        0.01,         1.0,    0.5).plot;


// ================== Enevelopes and Synthesis ==========================
// basic envelope, starts at lvl = 1, takes 1s to get to 0
Env([1,0],[1.0]).plot;

// just runs the envelope as a shape
{EnvGen.ar(Env([1,0],[1.0]))}.scope

// using envelope in a synth to control duration of a sound
{SinOsc.ar(400,0,0.1) * EnvGen.ar(Env([1,2,0],[1,1]),doneAction:2)}.play;

// Using an envelope to control frequency

Env([1000,200,80],[1,1,0]).plot;

{Saw.ar(EnvGen.ar(Env([150,200,80],[10,1,0],doneAction:2)),0.1)}.play;

// Now frequency and amplitude controled by envelopes
Env([100,120],[2]).plot;
Env([0.1,0.1,0],[2,0]).plot;

{Saw.ar(EnvGen.ar(Env([100,120],[2]),doneAction:2), EnvGen.ar(Env([0.1,0.1,0],[2,0]),doneAction:2))}.play;
{Saw.ar(EnvGen.ar(Env([10000,20],[0.5])),EnvGen.ar(Env([0.1,0],[2.0])))}.play;

// same thing, written easier!
({
	Saw.ar(
		EnvGen.kr(Env([10000,20],[0.5]),doneAction:2),  //frequency input
		EnvGen.kr(Env([0.1,0],[2.0]),doneAction:2)      //amplitude input
	)
}.play
)