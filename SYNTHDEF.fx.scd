(
SynthDef(\echo, { arg in=0, out=0, maxdtime=0.2, dtime=0.2, decay=2, gate=1;
    var env;
    env = Linen.kr(gate, 0.05, 1, 0.1, 2);
    in = In.ar(in, 2);
    XOut.ar(out, env, CombL.ar(in * env, maxdtime, dtime, decay, 1, in));
}, [\ir, \ir, 0.1, 0.1, 0]).add;

SynthDef(\distort, { arg in=0, out=0, pregain=40, amp=0.2, gate=1;
    var env;
	// env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	env = Env.adsr(\attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)).kr(2, gate);
    XOut.ar(out, env, (In.ar(in, 2) * pregain).distort * amp);
}, [\ir, 0.1, 0.1, 0]).add;

SynthDef(\wah, { arg in=0, out=0, gate=1;
    var env;
	// env = Linen.kr(gate, 0.05, 1, 0.4, 2);
	// env = Env.adsr(\attackTime.kr(0.01), \decayTime.kr(0.3), \sustainLevel.kr(0.5), \releaseTime.kr(1)).kr(2, gate);
	env = Env.linen(\attackTime.kr(0.01), \dur.kr(1), \releaseTime.kr(1)).kr(2, gate);
    in = In.ar(in, 2);
    XOut.ar(
		out,
		env,
		RLPF.ar(
			in,
			// LinExp.kr(LFNoise1.kr(0.3), -1, 1, 200, 8000),
			LinExp.kr(env, -1, 1,200,8000).poll,
			0.1
		).softclip * 0.8
	);
}, [\ir, 0]).add;
)