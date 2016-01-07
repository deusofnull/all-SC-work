({SinOsc.ar(200)}.play;
{SinOsc.ar(300)}.play;
{SinOsc.ar(400)}.play)

abc = {SinOsc.ar(250)}.play;


// Awesome little robo beepboop from Scott Petersen
(
play{a=SinOsc.ar(LFNoise0.kr(5, 300, 800));b=CombC.ar(a,2,LFNoise1.kr(0.5, 0.99, 1)); FreeVerb.ar(a+b)!2}
)

// server gui: volume control, recording, CPU usage
Server.default.makeGui;

// Quarks GUI: managing plugins
Quarks.gui;

// osciliscope
FreqScope.new;

{WhiteNoise.ar(0.1)}.play;


// subtractive synthesis:

//LPF cutoff 1000hz
{LPF.ar(PinkNoise.ar(0.1), 1000)}.play;

// LPR variable cutoff
{LPF.ar(WhiteNoise.ar(0.1),Line.kr(10000, 1000, 1))}.play;

{LPF.ar(Saw.ar(500),Line.kr(10000, 1000, 1))}.play;

{HPF.ar(Saw.ar(500),Line.kr(10000, 1000, 1))}.play;


{LPF.ar(PinkNoise.ar(0.1),Line.kr(500, 1500, 2))}.play;


// funny as fuck
ab={SinOsc.ar(Line.kr(700, 1500, 2), 0.1)}.play;

// duck army wanna bee chorus
({SinOsc.ar(Line.kr(300, 7412, 2), 0.1, Line.kr(0.1,0,0.5))}.play;
{SinOsc.ar(Line.kr(200, 2000, 2), 0.1,Line.kr(0.1,0,0.4))}.play;
{SinOsc.ar(Line.kr(100, 1204, 2), 0.1,Line.kr(0.1,0,0.3))}.play);

t={Resonz.ar(LFNoise0.ar(400),Line.kr(10000,1000,10),0.1)}.play
t.run(false);
b={Resonz.ar(LFNoise0.ar(400),Line.kr(1000,10000,10),0.1)}.play
b.run(false);
