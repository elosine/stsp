//Start w/Our Basic Triggered Impulse
(
SynthDef( \cassini, {
	arg t_t1=0, p=60, dur=3, amp=1,
	atk=0.5, rel=1.5, crv= 6;
	var imp, sig,
	var dc1=dur, fq1=p.midicps;
	fq, fqb, r1a, r1b, e1;
	fq = p.midicps;
	fqb = (p+1).midicps;
	imp = T2A.ar(t_t1);
	e1 = EnvGen.ar( Env.linen(atk, 0, rel, 1, crv), imp);
	r1a =  Ringz.ar( imp, fq, dec );
	r1b =  Ringz.ar( imp, fqb, dec );
	sig = Mix.ar([r1a, r1b*e1]);
	Out.ar(0, sig);
}).add;
)


s.sendMsg(\s_new, \cassini, 5000 );
s.sendMsg(\n_set, 5000, \t_t1, 1, \dec, 3, \atk, 0.45, \crv, 4);

Env.linen(0.5, 0, 1.5, 1, 6).plot

(
SynthDef( \roche, {
	arg t_t1=0, p=60, dur=3, amp=1;
	var imp, sig;
	var monics = NamedControl.kr(\monics, #[1,2,3,4,5,6,6.9, 7.83, 8.79, 9.72, 10.65]);
	var monics2 = NamedControl.kr(\monics2, #[1,2,3,4,5,6,6.9, 7.83, 8.79, 9.72, 10.65]);
	var amps = NamedControl.kr(\amps, #[0.05, 0.33, 0.5, 0.5, 0.75, 0.75, 1, 0.9, 0.6, 0.33, 0.2]);
	var s1, dc1=dur, fq1=p.midicps;
	var fq2 = ((p*2)+1).midicps;
	imp = T2A.ar(t_t1);

	//s1 = Ringz.ar(imp, monics2*fq2, 3, amps);
	s1 = Ringz.ar(imp, fq2, 3);

	sig = Ringz.ar( imp, monics*fq1, 3, amps);



	//Out.ar(0, sig);
	Out.ar(0, Mix.ar([sig, s1]));
}).add;
)

s.sendMsg(\s_new, \roche, 5000 );
s.sendMsg(\n_set, 5000, \t_t1, 1, \dec, 3, \atk, 0.45, \crv, 4, \p, 70);

(
//Generate 2 separate spectr within an octave
SynthDef( \janus, {
	arg och=99, t_t1=1, amp=0.5;
	var imp = T2A.ar(t_t1);
	var o1 = SinOsc.kr(0.311).range(0.0, 0.25);
	var o2 = SinOsc.kr(0.07).range(0.0, 0.25);
	var o3 = SinOsc.kr(0.11).range(0.0, 0.25);
	var o4 = SinOsc.kr(0.085).range(0.0, 0.25);
	var o5 = SinOsc.kr(0.23).range(0.0, 0.25);
	var dur = TRand.kr(3.0, 9.0);
	var p1 = TIRand.kr(40, 80, imp);
	var p2 = p1 + TIRand.kr(1, 10, imp);
	var p3 = p1 + TIRand.kr(1, 10, imp);
	var f1 = p1.midicps;
	var f2 = p2.midicps;
	var f3 = p3.midicps;
	var h = [2,3,4,5,6,7,8,9,10,11,12,13,14];
	var j1 = TIRand.kr(0,10);
	var j2 = TIRand.kr(0,10);
	var j3 = TIRand.kr(0,10);
	var h1 = h.scramble.copyRange(3,5).addFirst(1);
	var h2 = h.scramble.copyRange(7,9).addFirst(1);
	var h3 = h.scramble.copyRange(0,2).addFirst(1);
	var s1 = Ringz.ar( imp, f1*h1, dur,[o5, o1, o2, o3] );
	var s2 = Ringz.ar( imp, f2*h2, dur,[o3, o5, o4, o2]);
	var s3 = Ringz.ar( imp, f3*h3, dur,[o2, o1, o5, o3]);
	var fe = EnvGen.ar(Env.perc(0.002, dur+(dur*0.7), 1, 0),imp,doneAction:2);
	var f1b = (p1+1).midicps;
	var s1b = Ringz.ar( imp, f1b, dur,[o5, o1, o2, o3]);
	var f2b = (p2+1).midicps;
	var s2b = Ringz.ar( imp, f2b, dur,[o3, o5, o4, o2]);
	var f3b = (p3+1).midicps;
	var s3b = Ringz.ar( imp, f3b, dur,[o2, o1, o5, o3]);
	s1 = Mix.ar(s1);
	s2 = Mix.ar(s2);
	s3 = Mix.ar(s3);
	//Out.ar(och, Mix.ar([s1*(1.0/6.0), s2*(1.0/6.0), s3*(1.0/6.0), s1b*(1.0/6.0), s2b*(1.0/6.0), s3b*(1.0/6.0)])*fe);
	Out.ar(och, (Mix.ar([s1*0.3, s2*0.3, s3*0.3])*fe) * amp);
	//Out.ar(0, Mix.ar([s1*(1.0/6.0), s1b*(1.0/6.0)])*fe);
}).add;

SynthDef(\pnr, {
	arg ich, och=0;
	var in = In.ar(ich);
	var sig = PanAz.ar(8, in, SinOsc.kr(0.02), 1, 2, 0.5);
	Out.ar(och, sig);
}).add;

//Make Groups
s.sendMsg(\g_new, 2000);
s.sendMsg(\g_new, 2001, 3, 2000);
s.sendMsg(\g_new, 2002, 3, 2001);

i = 0;
)

s.sendMsg(\s_new, \pnr, 5001, 0, 2001, \ich, 99, \och, 0);
s.sendMsg(\s_new, \janus, 5002+i, 0, 2000, \och, 99, \amp, 1 ); i=i+1;s.sendMsg(\n_set, 6000, \t_t1, 1);


