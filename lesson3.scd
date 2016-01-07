// synth definition

c = {arg freq=440;SinOsc.ar(freq)*0.1}.play;

//changing arguments live
a.set(\freq,440);
a.set(\freq,330);
a.set(\freq,270);


// momentarily turn off synth without "free"ing the synth
a.run(false);
// turn synth back on
a.run;
// "free" the synth
a.free;

(
x = {arg freq=270, speed=1;SinOsc.ar(freq)*SinOsc.kr(1,0,1)}.play;
y = {arg freq=100, speed=1;LFSaw.ar(freq)*SinOsc.kr(speed,0,0.5)}.play;
)

(
a = {arg freq=270, speed=1.3;SinOsc.ar(freq)*SinOsc.kr(1,0,1)}.play;
b = {arg freq=100, speed=2;LFSaw.ar(freq)*SinOsc.kr(speed,0,0.5)}.play;
)

a.set(\freq, 270);
a.set(\speed, 1.3);

b.set(\freq, 120);
b.set(\freq, 100);
b.set(\speed, 2);