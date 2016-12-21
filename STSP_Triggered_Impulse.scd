//Designing Sounds w/Signal Processing
////Impluse Based Inputs

//Basic Triggered Impulse Template

(
//Using Impulse Ugen
//Using the impulse Ugen you generate a single sample
//impulse at a regular rate determined by the freq argument
//Here the default is 2x per second
SynthDef( \imp_t, {
	arg freq=2;
	var imp, fx;
	imp = Impulse.ar(freq);
	fx = RLPF.ar(imp, 1000);
	Out.ar(0, fx);
}).add;
)
a=Synth(\imp_t);


//You can create a one-shot, triggered impulse
//using the 't_' argument
//Any arg with t_ will be a trigger, like a bang in Max/MSP
(
SynthDef( \imp_tr, {
	arg freq=2, t_tr=0;
	var fx;
	fx = Klank.ar( `[ [380, 500, 770, 1076],[0.1, 0.1, 0.1, 0.1], [3.8, 2.8, 1.8, 0.8] ] , T2A.ar(t_tr) );
	Out.ar(0, fx);
}).add;
)
//You need to use T2A to convert the trigger
//to an audio rate impulse as many DSP
//ugens require an audio rate input
a=Synth(\imp_tr);
a.set(\t_tr,1);

//This is the basic template that we will be using
//for most of our Synthesis Through Sound Processing patches
(
SynthDef( \trtemp, {
	arg t_t1=0;
	var imp, fx1, fx2;
	var env1;
	imp = T2A.ar(t_t1);
	fx1 = Klank.ar( `[ [390, 500, 770, 1328],[0.5, 0.4, 0.3, 0.1], [3.8, 2.8, 1.8, 0.8] ], imp );
	env1 = EnvGen.kr(Env.linen(0.0001, 0.0, 1.0, curve: -10), imp);
	fx2 = MoogLadder.ar( fx1,  env1*1500.0, 0.57);
	Out.ar(0, fx2);
}).add;
)
//Don't worry about all the extra stuff
//I'll talk through the various parts
//in the actual tutorials
a=Synth(\trtemp);
a.set(\t_t1, 1);


(
SynthDef(\sa0253, {|t_tr=0 f1=300 f2=310 f3=377 r1=1 r2=2 r3=0.77|
	Out.ar(0, Mix.ar([
		CombC.ar(t_tr, 0.2, 1.0/f1, r1),
		CombC.ar(t_tr, 0.2, 1.0/f2, r2),
		CombC.ar(t_tr, 0.2, 1.0/f3, r3)
	]))
}).add;

)

a = Synth(\sa0253);
a.set(\t_tr, 1);