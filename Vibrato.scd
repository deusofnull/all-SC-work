s.boot;

Server.default.makeGui;
FreqScope.new;

9.8. Phase you can hear (as control)
// all phases: 0, .5, 1, 1.5
{SinOsc.ar(400, [0, 0.5pi, pi, 1.5pi])}.plot;
// 0 phase
{SinOsc.ar(SinOsc.ar(0.3, 0, 7, 72).round(1).midicps, 0, 0.7)}.play
// 0.5pi (1/4) phase
{SinOsc.ar(SinOsc.ar(0.3, 0.5pi, 7, 72).round(1).midicps, 0, 0.7)}.play
// 1pi (1/2) phase
{SinOsc.ar(SinOsc.ar(0.3, 1pi, 7, 72).round(1).midicps, 0, 0.7)}.play
// 1.5pi (3/4) phase
{SinOsc.ar(SinOsc.ar(0.3, 1.5pi, 7, 72).round(1).midicps, 0, 0.7)}.play

12.1. VCO, VCA, VCF
{Blip.ar(LFNoise0.kr(10, 500, 700), 7, 0.9)}.play
{Blip.ar(300, 7, LFNoise0.kr(10, 0.5, 0.5))}.play
{Blip.ar(300, LFNoise0.kr(10, 8, 10), 0.9)}.play

// designing vibrato
({
	var vibrato;
	vibrato = SinOsc.ar([5], 0, 5, [440]);
	SinOsc.ar(vibrato, mul:0.5);
}.play;)

({
	var vibrato, depth;
	depth = Line.kr(0,5,3);
	vibrato = SinOsc.ar(MouseX.kr(3, 9),0, depth, 1);
	SinOsc.ar(
		freq: MouseY.kr(50,750, 1, 0.5) * vibrato,
		mul:  0.5 // abs(MouseX.kr(0.02, 1)) // amp
	)
}.play)