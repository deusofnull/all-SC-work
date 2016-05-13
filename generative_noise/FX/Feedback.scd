// feedback systems, Scott Petersen
// https://scacinto.wordpress.com/2010/12/02/fun-with-feedback-and-supercollider/


// elementary demo

({   // BE VERY CAREFUL WITH THE MOUSE ON THE X AXIS!
	var input, fbLoopIn, fbLoopOut, processing;

	// input sound source
	input = PinkNoise.ar(1,0);

	// feed back loop insertion point
	fbLoopIn = LocalIn.ar(1);

	// mix input with feedback loop
	// mouseX controls gain
	// LeakDC removes DC offset
	processing  = input + LeakDC.ar((fbLoopIn * MouseX.kr(0,1.05)));
	// fbLoop out is our feedback loop output point
	fbLoopOut = LocalOut.ar(processing);

	Out.ar([0,1], processing * 0.4)
}.play;)

// Elementary Demo + delayN

({   // BE VERY CAREFUL WITH THE MOUSE ON THE X AXIS!
	var input, fbLoopIn, fbLoopOut, processing;

	// input sound source
	input = Crackle.ar(1.5, 0.5);
	//input = PinkNoise.ar(1,0);

	// feed back loop insertion point
	fbLoopIn = LocalIn.ar(1);

	// mix input with feedback loop
	// mouseX controls gain
	// LeakDC removes DC offset
	processing  = input + LeakDC.ar( (DelayN.ar(fbLoopIn, 0.5, 0.5, * MouseX.kr(0, 1.05))));
	// fbLoop out is our feedback loop output point
	fbLoopOut = LocalOut.ar(processing);

	processing = Limiter.ar(processing, 0.8);
	Out.ar([0,1], processing )
}.play;)


// More complex Demo with Delay, .clip distortion, and a resonant lpf

({
	var input, fbLoopIn, fbLoopOut, processing, speed;

	speed = LFNoise0.kr(0.5, 2, 2.05);

	// input sound source
	input = Crackle.ar(1.5, 0.15);
	//input = PinkNoise.ar(1,0);

	// feed back loop insertion point
	fbLoopIn = LocalIn.ar(1);

	// mix input with feedback loop
	// LeakDC removes DC offset
	// delay time is controlled by speed
	// gain is set to 1.1 (will go crazy, its a constructive delay)
	processing  = input + LeakDC.ar(
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



// Same principal as above, but with microphone input as source signal

({
	var input, fbLoopIn, fbLoopOut, processing, speed;

	speed = LFNoise0.kr(0.5, 2, 2.05);
	// input sound source
	input = SoundIn.ar(1);
	// feed back loop insertion point
	fbLoopIn = LocalIn.ar(1);
	// mix input with feedback loop
	// LeakDC removes DC offset
	// delay time is controlled by speed
	// gain is set to 1.1 (will go crazy, its a constructive delay)
	processing  = input + LeakDC.ar(
		DelayN.ar(
			in: fbLoopIn,
			maxdelaytime: 3.5,
			delaytime: speed,
			mul: 1.1 // Essentially the Gain
		)
	);
	// use a resonant low pass filter that moves at varoius rates
	// determined by speed with frequencies between 400 -1200
	processing = RLPF.ar(processing, LFNoise0.kr(speed, 400, 800), 0.15);

	// fbLoop out is our feedback loop output point
	fbLoopOut = LocalOut.ar(processing);

	// thresh prevents output until a threshold value is reached
	processing = processing.thresh(0.45);

	processing = Limiter.ar(in:processing, level:0.9);

	// adding equal power panning
	processing = Pan2.ar(processing, (speed -2) * 0.5);

	Out.ar(0, processing )
}.play;)


(
{
	var input, output;


	// input sound source
	input = SoundIn.ar(1);

	output = Pan2.ar(input, 0);

	Out.ar(0, output )
}.play;)


s.quit;
s.boot;
(
Server.default.makeGui;
s.meter;
s.plotTree;
s.scope;
FreqScope.new;
)