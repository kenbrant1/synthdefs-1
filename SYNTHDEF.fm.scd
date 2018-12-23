(
SynthDef(\fm7, {
	arg out=0, amp=0.3, spread=0, freq=440, attack=0.01, decay=0.3, sustain=0.5, release=1, gate=1;
	var sig, env, ctls, mods, chans, envs, freqs, amps;
	// frequencies of oscillators are in partials of main frequency, they
	// multiply the base frequency
	freqs = Array.fill(6, { |i|
		freq * ((\freq++i).asSymbol).kr((i+1)) + 0.1.rand2;
	});

	envs = Array.fill(6, { |i|
		EnvGen.kr(
			Env.adsr(
				((\attack++i).asSymbol).kr(0.01),
				((\decay++i).asSymbol).kr(0.3),
				((\sustain++i).asSymbol).kr(1),
				((\release++i).asSymbol).kr(1)
			),
			gate);//((\gate++i).asSymbol).kr(0));
	});

	// freq, phase (initialization only), amp
	ctls = Array.fill(6, { |i| [freqs[i], 0, envs[i]] });

	// mods modulate ctls phases
	// Access them with x.set(\mod[carrier][modulator], value),
	// For example: x.set(\mod01, 0.5) is modulating first oscilator with the signal from
	// the second oscillator  by an amount of 0.5 radians
	mods = Array.fill2D(6, 6, { |r, c|
		((\mod++r++c).asSymbol).kr(0);
	});

	// use this instead if you prefer using a [6][6] array
	//mods = \mods.kr(0!6!6);

	amps = Array.fill(6, { |i|
		((\amp++i).asSymbol).kr((i.mod(6)==0).asInt);
	});

	env = EnvGen.ar(Env.adsr(attack, decay, sustain, release), gate, doneAction:2);

	sig = Splay.ar(FM7.ar(ctls, mods) * amps * env, spread);
	Out.ar(out, sig * amp);
}).store;
)

// a = Synth(\fm7)
// a.set(\freq0, 100)
// a.set(\freq1, 400)
// a.set(\freq2, 50)
// // spread audible signals (0 is all centered, 1 is maximum spread)
// a.set(\spread, 0)
// // mix
// a.set(\amp0, 1); // listen to first oscillator
// a.set(\amp3, 0.5); // listen 4th oscillator at half volume
// // envelopes for every oscillator
// a.set(\envrate0, 0); // if set to 0 while hearing it, it will hold, otherwise it mutes
// a.set(\envrate1, 0.21);
// a.set(\envrate2, 0.211);
// a.set(\attack1, 0.5)
// a.set(\attack2, 0.5)
// a.set(\release0, 1)
// a.set(\release1, 0.5)
// a.set(\release2, 0.05)
// a.set(\decay0, 0.5)
// a.set(\decay1, 0.1)
// a.set(\decay2, 0.8)
// a.free;


/*(
SynthDef(\fm7, {
	arg out=0, amp=0.3, mix = #[1,1,0,0,0,0], spread=0;
    var sig, ctls, mods, chans, envs, freqs;
	freqs = Array.fill(6, { |i|
		((\freq++i).asSymbol).kr((i+1) * 100)
	});
	envs = Array.fill(6, { |i|
		EnvGen.kr(
			Env.adsr(
				((\attack++i).asSymbol).kr(0.01),
				((\decay++i).asSymbol).kr(0.3),
				((\sustain++i).asSymbol).kr(1),
				((\release++i).asSymbol).kr(1)
			),
			LFPulse.kr(((\envrate++i).asSymbol).kr))
	});
	// freq, phase (initialization only), amp
	ctls = Array.fill(6, { |i| [freqs[i], 0, envs[i]] });
	// FM7.ar(ctls, mods).slice(chans) * 0.3;//-12.dbamp; // using "slice" to select specific channels
	sig = Splay.ar(FM7.ar(ctls, mods) * mix, spread);
	Out.ar(out, sig * amp);
}).store//add;
)*/

/*(
a.set(\mods, [
	// modulate ctls phases
	// row: carrier
	// column: modulator
	[0, 2,2,2,0,0],
	[0, 0,1,0,0,0],
	[0, 0,0,0,0,0],
	[0, 0,0,0,0,0],
	[0, 0,0,0,0,0],
	[0, 0,0,0,0,0]
]
)
// set volume for each oscillator (what you want to hear)
a.set(\mix, [1,1,0,0,0,0])
)*/
