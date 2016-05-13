(
{
	var input, output, fbin, processing, fbout;
	// input sound source
	input = SoundIn.ar(1);

	input = LeakDC.ar(input);

	fbin = LocalIn.ar(1);
	// mix input with feedback loop
	// LeakDC removes DC offset
	// delay time is controlled by speed
	// gain is set to 1.1 (will go crazy, its a constructive delay)
	processing  = input + LeakDC.ar(
		DelayN.ar(
			in: fbin,
			maxdelaytime: 3.5,
			delaytime: 0.2,
			mul: 0.5 // Essentially the Gain
		)
	);

	// end the feedback loop
	fbout = LocalOut.ar(processing);



	// limit the output to prevent explosions
	processing = Limiter.ar(in:processing, level:0.9);

	processing = Pan2.ar(processing, 0, 1);

	Out.ar(0, processing )
}.play;)

// TODO turn into a synthdef.  this has massive potential
// MASSIVE