shader_type spatial;



void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
	bool alt_stripe = (int(.2 / .1)) % 2 == 1;
}
