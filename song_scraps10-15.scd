
// server gui: volume control, recording, CPU usage
Server.default.makeGui;

// ctrl-m for levels

// osciliscope
FreqScope.new;

// synth definition

c = {arg freq=440;SinOsc.ar(freq)*0.1}.play;
c.free

//changing arguments live
a.set(\freq,180);
a.set(\freq,140);
a.set(\freq,100);


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
x.free;

(
a = {arg freq=270, speed=1.3;SinOsc.ar(freq)*SinOsc.kr(1,0,1)}.play;
b = {arg freq=100, speed=2;LFSaw.ar(freq)*SinOsc.kr(speed,0,0.5)}.play;
)

a.set(\freq, 290);
a.set(\speed, 1.7);

b.set(\freq, 120);
b.set(\freq, 100);
b.set(\speed, 4);

(t={Resonz.ar(LFNoise0.ar(400),Line.kr(10000,1000,10),0.1)}.play;
Trig(t.run(false),10);)
t.run(false);
b={Resonz.ar(LFNoise0.ar(400),Line.kr(1000,10000,10),0.1)}.play
b.run(false);

l=LevelIndicator(w, Rect(10, 10, 20, 160));