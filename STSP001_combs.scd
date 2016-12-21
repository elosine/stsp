//Start w/Our Basic Triggered Impulse
(
SynthDef( \sean, {
	arg t_t1=0, del=0.1, dec=1;
	var imp, fx1;
	imp = T2A.ar(t_t1);
	//We'll start with a single comb filter as our effect
	//also making args for delay time and decay time
	fx1 = CombC.ar(imp, 0.2, del, dec);
	Out.ar(0, fx1);
}).add;
)
a=Synth(\sean);
a.set(\t_t1, 1);
//Let's mess around with the delay times
//at higher values you get a cool
//ping pong type delay
a.set(\t_t1, 1, \del, 0.25);
//let's see what happens when we lower the delay time
a.set(\t_t1, 1, \del, 0.03);
//somewhere around a delay of 0.03 or 30 milliseconds
//we start getting a continuous tone, with a cool
//metalic buzz (think transformers)
a.set(\t_t1, 1, \del, 0.008);
//it turns out that the tone frequency is
//inversly proportional to th delay time
//i.e. to play A440 the delay time should be
// 1/440 or 0.0022727272727273
1.0/440;
a.set(\t_t1, 1, \del, 1.0/440.0, \dec, 3);
//it sounds kinda nylon stringy
//So lets tweek our delay time arg
//so that it is pitch frequency instead
//of actual delay time
(
SynthDef( \puffy, {
	//add a freq arg
	arg t_t1=0, freq=300, dec=1;
	//turn the del arg to a var
	var imp, fx1, del;
	del = 1.0/freq; //convert the freq to a delay time
	imp = T2A.ar(t_t1);
	fx1 = CombC.ar(imp, 0.2, del, dec);
	Out.ar(0, fx1);
}).add;
)
a=Synth(\puffy);
a.set(\t_t1, 1);
a.set(\t_t1, 1, \freq, 440);

//Let's make it even more handy and make
//the frequency a midi note number
(
SynthDef( \puffy, {
	//add a freq arg
	arg t_t1=0, pitch=60, dec=1;
	var imp, fx1, del;

	del = 1.0/pitch.midicps; //convert midi note number to freq, then to a delay time
	imp = T2A.ar(t_t1);
	fx1 = CombC.ar(imp, 0.2, del, dec);
	Out.ar(0, fx1);
}).add;
)
a=Synth(\puffy);
a.set(\t_t1, 1);
a.set(\t_t1, 1, \pitch, 67);

//Now I'm gonna add several combs so we can
//have a chord
(
SynthDef( \puffdaddy, {
	//add a freq arg
	arg t_t1=0, p1=60, dc1=1, p2=64, dc2=1, p3=67, dc3=1, p4=71, dc4=1, p5=72, dc5=1;
	var imp, d1, c1, d2, c2, d3, c3, d4, c4, d5, c5, sig;
	imp = T2A.ar(t_t1);
	d1 = 1.0/p1.midicps;
	d2 = 1.0/p2.midicps;
	d3 = 1.0/p3.midicps;
	d4 = 1.0/p4.midicps;
	d5 = 1.0/p5.midicps;
	c1 = CombC.ar(imp, 0.2, d1, dc1);
	c2 = CombC.ar(imp, 0.2, d2, dc2);
	c3 = CombC.ar(imp, 0.2, d3, dc3);
	c4 = CombC.ar(imp, 0.2, d4, dc4);
	c5 = CombC.ar(imp, 0.2, d5, dc5);
	sig = Mix.ar([c1*(1.0/5.0),c2*(1.0/5.0),c3*(1.0/5.0),c4*(1.0/5.0),c5*(1.0/5.0)]);
	Out.ar(0, sig);
}).add;
)
a=Synth(\puffdaddy);
a.set(\t_t1, 1);
a.set(\t_t1, 1, \pitch, 67);
//play with decay times til you have a nice sonorous dominant 7 chord
//strumm
//messiaen modes
//randomize modes


(