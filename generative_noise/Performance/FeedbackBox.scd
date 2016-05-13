({
	var input, fbLoopIn, fbLoopOut, processing, speed;

	speed = LFNoise0.kr(0.5, 2, 2.05);

	// input sound source
	//input = Crackle.ar(1.5, 0.15);
	//input = PinkNoise.ar(1,0);

	// feed back loop insertion point
	fbLoopIn = In.ar(0);

	// mix input with feedback loop
	// LeakDC removes DC offset
	// delay time is controlled by speed
	// gain is set to 1.1 (will go crazy, its a constructive delay)
	processing  =  LeakDC.ar(
		DelayN.ar(
			in: fbLoopIn,
			maxdelaytime: 3.5,
			delaytime: speed,
			mul: 1.1 // Essentially the Gain
		)
	);

	// use a resonant low pass filter that moves at varoius rates
	// determined by speed with frequencies between 400 -1200
	processing = RLPF.ar(processing, LFNoise0.kr(speed, 400, 800), 0.5);

	// square off the wave to achieve Distortion
	processing = processing.clip;

	// fbLoop out is our feedback loop output point
	fbLoopOut = LocalOut.ar(processing);

	processing = Limiter.ar(processing, 0.9, 0.05);
	Out.ar([0,1], processing )
}.play;)


(SynthDef.new(\feedbackBox,
	{
		arg speed, gain,
	}
).add;)