~boos = Buffer.read(s,"/home/deusofnull/null_sounds/Recordings/speechbubblebeats/aiff/booos.aiff");
~clock_clap = Buffer.read(s, "/home/deusofnull/null_sounds/Recordings/speechbubblebeats/aiff/clock_clap.aiff");
~drum_solo = Buffer.read(s,"/home/deusofnull/null_sounds/Recordings/speechbubblebeats/aiff/drum_solo.aiff" );
~fuck_yeah = Buffer.read(s, "/home/deusofnull/null_sounds/Recordings/speechbubblebeats/aiff/fuck_yeah.aiff");
~hehaw_birds = Buffer.read(s, "/home/deusofnull/null_sounds/Recordings/speechbubblebeats/aiff/heehaw_birds.aiff");
~rubber_clock1 = Buffer.read(s, "/home/deusofnull/null_sounds/Recordings/speechbubblebeats/aiff/rubberband_clock.aiff");
~rubber_clock2 = Buffer.read(s, "/home/deusofnull/null_sounds/Recordings/speechbubblebeats/aiff/rubberband_clock_2.aiff");


~boos.play;
~clock_clap.play;
~drum_solo.play;
~fuck_yeah.play;
~hehaw_birds.play;
~rubber_clock1.play;
~rubber_clock2.play;

// every buffer has frames which equals length
~boos.numFrames;

// buffer has channels, 2 for stero
~boos.numChannels;

// samples per buffer = numChannels * numFrames

// buffer has duration
~drum_solo.duration;

// buffer has a number, or bufnum
~boos.bufnum;

// buffer sample rate
~boos.sampleRate;

// see it all in one place with .query
~boos.query;


// load files into buffer array

~sb_sounds = Array.new;
~folder = PathName.new("/home/deusofnull/null_sounds/Recordings/speechbubblebeats/aiff");
~folder.entries;

(
~folder.entries.do({
	arg path;
	~sb_sounds = ~sb_sounds.add(Buffer.read(s, path.fullPath));
});
)
~sb_sounds[3].play;

(
4.do({
	arg index;
	~sb_sounds[index].play;
});
)

// controlling buffers with PlayBuf

(
SynthDef.new(\playbuf_test, {
	arg amp = 1, out = 0, buf,
	t_trig = 1, start = 0, loop = 0, da=2, rate=1;
	var sig;
	sig = PlayBuf.ar(2, buf, rate, t_trig, start, loop, doneAction:da);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Synth.new(\playbuf_test, [\buf, ~sb_sounds[1], \rate, 0.7, \amp, 0.8]);
// using PlayBuf's loop argument, doneaction is ignored and the buffer continues playing
d = Synth.new(\playbuf_test, [\buf, ~sb_sounds[2], \rate, 1, \loop, 1, \amp, 0.8]);
d.set(\loop, 0);
d.set(\rate, 1);

s.reboot;
s.quit;
Server.default.makeGui;
// playback rate is not the best choice for achieving chromatic harmonies
// instead use midiratio, which converts a number of semitones into a ratio for playback
12.midiratio;  // one octive up
7.midiratio; // perfect fifth up

e = Synth.new(\playbuf_test, [\buf, ~sb_sounds[2], \rate, -10.midiratio, \loop, 1, \amp, 0.6]);

e.set(\rate, -5.midiratio);
e.set(\rate, -10.midiratio);
e.set(\rate, 10.midiratio);
e.set(\rate, 20.midiratio);
e.set(\rate, 50.midiratio);
e.set(\rate, -50.midiratio);

c = Synth.new(\playbuf_test, [\buf, ~sb_sounds[4], \rate, 1.midiratio, \loop, 1, \amp, 0.6]);



// using Group to control a set of synths simultaneously
g = Group.new;

(
f = Synth.new(\playbuf_test, [\buf, ~sb_sounds[3], \rate, -5.midiratio, \loop, 1, \amp, 0.8], g);
h = Synth.new(\playbuf_test, [\buf, ~sb_sounds[2], \rate, 1, \loop, 1, \amp, 0.8], g);
i = Synth.new(\playbuf_test, [\buf, ~sb_sounds[4], \rate, 1, \loop, 1, \amp, 0.8], g);
)
// control the group
g.set(\rate, 0.midiratio);
// control the individual
h.set(\amp, 0);
f.set(\amp, 0);

h.set(\rate, -10.midiratio);
