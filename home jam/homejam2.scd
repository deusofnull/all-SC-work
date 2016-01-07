// working with
// "http://www.supercolliderbook.net/wilsondescrivanch3.pdf"

// tilda ~ means environment variable
//   high reusage
~smallbeat = {Pulse.ar(rrand(50,200), 0.2, 0.2 )*EnvGen.ar(Env.perc, doneAction:2)};
~smallbeat.play;

// SCHEDULING

// SystemClock,  global clock for event scheduling
// execute funciton in 1 second
SystemClock.sched(1, {~smallbeat.play});
// if last return in function is a number, function will repeat
// after that many seconds
SystemClock.sched(0.1, {~smallbeat.play; 0.1})

// TempoClock, atomic reproducable clock with BPM control
(
t = TempoClock.new; // new TempoClock
t.sched(0, {~smallbeat.play; 0.3});
)
t.tempo = 2; // twice as fast
t.clear;

// Routine
// funcations that evaluate one piece at a time
(
r = Routine({
	"foo".yield;
	"bar".yield;
});
)
r.value; // prints foo
r.value; // prints bar
r.value; // prints nil

// Routines being funciton like, can be put in a clock with a # as return
// in this way, the routine is rescheduled
(
r = Routine({
	"foo".postln;
	{Pulse.ar(50, 0.2, 0.2) * EnvGen.ar(Env.perc, doneAction:2)}.play;
	1.yield; // resched after 1 sec
	"bar".postln;
	{Pulse.ar(100, 0.2, 0.2) * EnvGen.ar(Env.perc, doneAction:2)}.play;
	1.yield;
	"foobar".postln;
	{Pulse.ar(150, 0.2, 0.2) * EnvGen.ar(Env.perc, doneAction:2)}.play;
});
SystemClock.sched(0, r);
)

// Another musical example of using Routine
// Fermata

(
r = Routine({
	x = Synth(\default, [freq: 76.midicps]);
	1.wait;

	x.release(0.1);

	y = Synth(\default, [freq: 73.midicps]);
	"Waiting.....".postln;
	nil.yield; // fermata

	y.release(0.1);
	z = Synth(\default, [freq: 69.midicps]);
	2.wait;
	z.release;
});
)
// run this and wait for the fermata...
r.play;
// activate the fermata!
r.play;


// using Task's inside a routine
// a task requires a Clock
(
r = Routine({
	c = TempoClock.new;
	// start a wobbly loop
	t = Task({
		loop({
			x.release(0.1);
			x = Synth(\default, [freq:61.midicps, amp: 0.2]);
			0.2.wait;
			x.release(0.1);
			x = Synth(\default, [freq:64.midicps, amp: 0.2]);
			rrand(0.075, 0.25).wait; // random waits, "wobbly"
		});
	}, c); // use the TempoClock c to play this Task
	t.start;
	nil.yield;

	// now add notes
	y = Synth(\default, [freq:66.midicps, amp:0.3]);
	nil.yield;
	y.release(0.1);
	y = Synth(\default, [freq:68.midicps, amp:0.3]);
	c.tempo = 2;
	nil.yield;
	t.stop; y.release(1); x.release(0.1); // end
});
)

r.next;  // start the Routine Task with Loop
r.next; // first note
r.next; // second note, loop goes double time
r.next; // stop loop and fade


// Patterns within a task
(  // lydian b7 scale
p = Pxrand([64, 66, 68, 70, 71, 73, 74, 76], inf).asStream;
// ordered sequence of durations
q = Pseq([1/2, 1, 1/4, 1/4], inf).asStream;
t = Task({
	loop({
		x.release(2);
		x = Synth(\bpfsaw, [freq: (p.value-10).midicps,
		]);
		q.value.wait;
	});
});
t.start;
)
t.stop; x.release(2);

// live control by manipulating p?
p = Pxrand([54, 56, 58,60, 61, 63, 64, 66], inf).asStream;
// dark but musical
p = Pxrand([25, 43, 87, 72, 35, 42, 14, 55], inf).asStream;
// bridge
p = Pxrand([25, 27, 35, 20, 19, 42, 36, 33], inf).asStream;
// popping death
p = Pxrand([11, 12, 14, 16, 17, 19, 21, 23], inf).asStream;

(  // lydian b7 scale
a = Pxrand([64, 66, 68, 70, 71, 73, 74, 76], inf).asStream;
// ordered sequence of durations
y = Pseq([1/2, 1, 1/4, 1/4], inf).asStream;
z = Task({
	loop({
		x.release(2);
		x = Synth(\bpfsaw, [freq: (a.value-10).midicps,
		]);
		q.value.wait;
	});
});
t.start;
)



	