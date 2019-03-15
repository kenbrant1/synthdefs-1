(
SynthDef(\fm7, {
    var sig, env;
    var freq = \freq.kr(440);
    var amp = \amp.kr(1);
    var spread = \spread.kr(0.8);
    var out = \out.kr(0);
    var amps = Array.fill(6, { |i| (\amp++(i+1)).asSymbol.kr(0)});
    var ctls, mods;

    ctls = Array.fill(6, { |i|
        [freq * (\freq++(i+1)).asSymbol.kr(i+1), 0, 1];
    });

    mods = Array.fill(6, { |i|
        Array.fill(6, { |n| (\mod++(i+1)++(n+1)).asSymbol.kr(0)});
    });

    sig = FM7.ar(ctls, mods) * amps;
    Out.ar(out, Splay.ar(sig * amp, spread));
}).store;
)

(
SynthDef(\fmx7, {
    var amp = \amp.kr(1);
    var spread = \spread.kr(0.8);
    var out = \out.kr(0);
	var gate = \gate.kr(1);
    var freq = \freq.kr(440);
	var env = EnvGen.ar(Env.adsr(\attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)), gate, doneAction:2);
    var amps = Array.fill(6, { |i| (\amp++(i+1)).asSymbol.kr(0)});
    var freqs = Array.fill(6, { |i| (\freq++(i+1)).asSymbol.kr(i+1)});

    var envs = Array.fill(6, { |i|
		EnvGen.kr(
			Env.new(
				[0]++Array.fill(4, { |n| (\eglevel++(i+1)++(n+1)).asSymbol.kr(1) }),
				Array.fill(4, { |n| (\egrate++(i+1)++(n+1)).asSymbol.kr(n/4) })
			),
			gate,
			doneAction:2
		);
	});

    var ctls = Array.fill(6, { |i|
		[freq * freqs[i], 0, envs[i]];
    });

    var mods = Array.fill(6, { |i|
        Array.fill(6, { |n| (\mod++(i+1)++(n+1)).asSymbol.kr(0)});
    });

    var sig = FM7.ar(ctls, mods) * amps;
    Out.ar(out, Splay.ar(sig * amp * env, spread));
}).store;
)

// fmx7 Pbindef random EXAMPLE
/*(
Pbindef(\a, \instrument, \fmx7).play;
Pbindef(\a, \amp, 1);
6.do { |i|
	6.do { |n|
		Pbindef(\a, (\mod++(i+1)++(n+1)).asSymbol, 1.0.rand);
	};
	4.do { |n|
		Pbindef(\a, (\egrate++(i+1)++(n+1)).asSymbol, rrand(0.0,0.25));
		Pbindef(\a, (\eglevel++(i+1)++(n+1)).asSymbol, 1.0.rand);
	};
	Pbindef(\a, (\amp++(i+1)).asSymbol, 1.0.rand);
	Pbindef(\a, (\freq++(i+1)).asSymbol, ([0.25,0.5]++(1..8)).wchoose((0.2!4)++(0.02!6)).postln);
	Pbindef(\a, \attack, rrand(0.01, 0.2));
	Pbindef(\a, \decay, rrand(0.01, 0.5));
	Pbindef(\a, \sustainLevel, rrand(0.3, 0.95));
	Pbindef(\a, \releaseTime, 1.0.rand);
};
)*/