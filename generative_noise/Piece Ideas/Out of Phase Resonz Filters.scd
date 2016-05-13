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
		post("ascPitch:  " ); ascPitch = rrand(200,1000).postln;
		post("descPitch: " ); descPitch = rrand(200,1000).postln;
		~asc.free; ~desc.free;
		// first the descending bandwith filter

		~desc = { Resonz.ar(PinkNoise.ar(0.5),
			[descPitch, descPitch/2],
			XLine.kr(1, 0.001, 8))!2 }.play;

		0.1.wait; // as to become out of phase

		// next the ascending bandwith filter
		~asc = { Resonz.ar(PinkNoise.ar(0.5),
			[ascPitch, ascPitch/2],
			XLine.kr(0.001, 1, 8))!2 }.play;
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