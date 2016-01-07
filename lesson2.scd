// "http://composerprogrammer.com/teaching/supercollider/sctutorial/2.2 Mul and add.html"

{SinOsc.ar(mul:0.1)}.play

//using MouseX mapped freq and MouseY mapped mul
{SinOsc.ar(freq:MouseX.kr(200,5000), mul:MouseY.kr(1.0,0.1))}.play


{SinOsc.ar(mul:0.1, add:MouseY.kr(0.9,-0.9))}.scope		//demo of offsetting

// The mul and add controls help when you need to set one signal as an input to another and need to scale the input signal appropriately to the expected input values required.

({
	//cutoff values need to be sensible frequencies in Hz; here sine output turned from -1 to 1 into 2000+-1700
	var cutoff = 	SinOsc.ar(1,mul:MouseX.kr(0.0,1700.0), add:2000.0);
	//var cutoff = SinOsc.ar(1)*1700.0 + 2000.0;  //same thing
	LPF.ar(WhiteNoise.ar,freq:cutoff);
}.scope)


({SinOsc.ar(MouseX.kr(250,263), 0, Line.kr(0.1,0,0.3))}.play; // C
//{SinOsc.ar(349, mul:0.1)}.play; // F
{SinOsc.ar(392, 0,Line.kr(0.1,0,0.3))}.play; // G
{SinOsc.ar(659, 0, Line.kr(0.1,0,0.3))}.play; // E
{SinOsc.ar(987, 0, Line.kr(0.1,0,0.3))}.play;) // B


// C major 7  -> G dom 7
// fucking zappa shit
({SinOsc.ar(MouseX.kr(250,293), mul:0.1)}.play; // C
//{SinOsc.ar(349, mul:0.1)}.play; // F
{SinOsc.ar(392, mul:0.1)}.play; // G
{SinOsc.ar(MouseX.kr(659,783), mul:0.1)}.play; // E
{SinOsc.ar(987, mul:0.1)}.play;) // B

Env([0,1,0],[1.0,0.5]).plot
Env.linen(0.03,0.5,0.1).plot