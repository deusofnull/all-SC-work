// Modulation Synthesis
// carrier * modulator
// In modulation synthesis one wave, the carrier, is influenced (modulated) by a second, the modulator.
// Modulation synthesis is easy to implement, providing computationally efficient shortcuts to complex dynamic spectra. The methods have their own unique sounds too, which can be musically useful.
// nick collins
// "http://composerprogrammer.com/teaching/supercollider/sctutorial/2.4 Modulation Synthesis.html"

// ring modulation
// straight forward

(
{
	var carrier, modulator, carrfreq, modfreq;

	carrfreq = MouseX.kr(440,5000,'exponential');
	modfreq = MouseY.kr(1, 5000, 'exponential');

	carrier=LFSaw.ar(carrfreq,0,0.5);
	modulator=LFSaw.ar(modfreq,0,0.5);

	carrier*modulator;
}.scope
)

{SinOsc.ar(440,0,0.5)}.scope //bipolar, -0.5 to 0.5
{SinOsc.ar(440,0,0.5,0.5)}.scope //unipolar, 0 to 1 (0.5 plus or minus 0.5)

(
{
var carrier, modulator, carrfreq, modfreq;

carrfreq= MouseX.kr(440,5000,'exponential');
modfreq= MouseY.kr(1,5000,'exponential');

carrier= LFSaw.ar(carrfreq,0,0.5);
modulator= LFSaw.ar(modfreq,0,0.25, 0.25);

carrier*modulator;
}.scope
)

{LFSaw.ar(MouseX.kr(60,140),0,1)}.scope;


// Frequency Modulation, Yamaha DX7, most commercially sucessful synth of all time
// FM developed by John Chowning


(
var w, carrfreqslider, modfreqslider, moddepthslider, synth;

w=Window("frequency modulation", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth= {
	arg carrfreq=440, modfreq=1, moddepth=0.01;
	SinOsc.ar(carrfreq + (moddepth*SinOsc.ar(modfreq)),0,0.25)
}.scope;

carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;

modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;
moddepthslider= EZSlider(w, 300@50, "moddepth", ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01), {|ez|  synth.set(\moddepth, ez.value)});

w.front;
)

// frequency modulation via modulation index,
// I = D / M
(
var w, carrfreqslider, modfreqslider, modindexslider, synth;

w=Window("frequency modulation via modulation index", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth= {arg carrfreq=440, modfreq=1, modindex=0;
LFSaw.ar(carrfreq + (modindex*modfreq*LFSaw.ar(modfreq)),0,0.25)
}.scope;

carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});
w.view.decorator.nextLine;

modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});
w.view.decorator.nextLine;
modindexslider= EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 50, 'linear', 0.01, 0.0), {|ez|  synth.set(\modindex, ez.value)});

w.front;
)

// simple mouse control version

(
{ var modfreq, modindex;

	modfreq=MouseX.kr(1,440,'exponential');
	modindex=MouseY.kr(0.0,10.0);

	SinOsc.ar(SinOsc.ar(modfreq,0,modfreq*modindex,440),0,0.25);
}.scope
)

// harmonicity ratio, following Moore Elements of Computer Music

(
{
var carrfreq, modfreq, harmonicity, modindex;

//fc is frequency of carrier
//fm is frequency of modulator

carrfreq= 440; //MouseY.kr(330,550);
harmonicity= MouseX.kr(0,10).round(1);
modindex= MouseY.kr(0.0,10.0); //which is really modulation amplitude/modulation frequency, acts as brightness control as energy distribution changed over components

modfreq= carrfreq*harmonicity; //since harmonicity is an integer,

SinOsc.ar(carrfreq+(SinOsc.ar(modfreq)*modfreq*modindex), 0.0,0.1);

}.play
)


