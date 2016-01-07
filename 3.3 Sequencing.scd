// simple SynthDef to sequence with
(
SynthDef(\event, {arg freq = 440, amp = 0.5, pan = 0.0;
	var env;

	env = EnvGen.ar( Env([0,1,1,0],[0.01,0.1,0.2]), doneAction:2);

	Out.ar(0, Pan2.ar(Blip.ar(freq) * env * amp, pan))
}).add;
)

Synth(\event);

Synth(\event, [\freq,880]);

// scheduling multiple events using Synths
(
{
	Synth(\event, [\freq, 440]);

	1.0.wait;

	Synth(\event, [\freq, 520]);

	1.0.wait;

	Synth(\event, [\freq, 440]);

	1.0.wait;

	Synth(\event, [\freq, 410]);

	0.3.wait;

	Synth(\event, [\freq, 405]);

	0.3.wait;

	Synth(\event, [\freq, 405]);

	0.3.wait;
}.fork;
)

// using encapculation for repeats
({
	4.do {
		Synth(\event);
		0.5.wait;
	};
}.fork;)

// using random frequencies

({
	16.do {
		Synth(\event, [\freq,rrand(440,880)]);
			0.3.wait;
		};
}.fork;)

({
	16.do {
		Synth(\event, [\freq,rrand(120,260)]);
			0.1.wait;
		};
}.fork;)


// and using random spacing
({
	16.do {
		Synth(\event, [\freq,rrand(440,880)]);
		rrand(0.2,0.6).wait;
		};
}.fork;)

({
	16.do {
		Synth(\event, [\freq,rrand(120,260)]);
			0.5.wait;
		};
}.fork;)


// infinite sequencing
({
	inf.do {
		Synth(\event, [\freq,rrand(120,500)]);
		rrand(0.2,0.6).wait;
	}
}.fork;)