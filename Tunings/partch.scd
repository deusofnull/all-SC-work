t = Tuning.et12;
t.semitones;
t.ratios;
Tuning.directory;




~et53.tuning_(\et53);

~et53.ratios;

s.boot;
Scale.directory;
// et12 minor
e = Scale.partch_o1;
e.size;
e.tuning;
Pbind(\scale, e, \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1).trace, \dur, 0.25).play;

// partch minor
p = Scale.minor;
p.tuning_(\partch);
Pbind(\scale, Pfunc({p}, inf), \degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1).trace, \dur, 0.1).play;