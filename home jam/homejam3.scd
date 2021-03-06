

// Patterns within a task
(  // lydian b7 scale
p = Pxrand([25, 43, 87, 72, 35, 42, 14, 55], inf).asStream;
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



// buffers

e = Synth.new(\playbuf_test, [\buf, ~sb_sounds[2], \rate, -10.midiratio, \loop, 1, \amp, 0.6]);

e.set(\rate, -5.midiratio);
e.set(\rate, -10.midiratio);
e.set(\rate, 10.midiratio);
e.set(\rate, 20.midiratio);
e.set(\rate, 50.midiratio);
e.set(\rate, -50.midiratio);

c = Synth.new(\playbuf_test, [\buf, ~sb_sounds[4], \rate, 1.midiratio, \loop, 1, \amp, 0.6]);
c.set(\rate, -30.midiratio);
