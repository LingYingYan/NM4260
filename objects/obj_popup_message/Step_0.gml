if (!fading_out) {
    if (alpha < 1) alpha += 0.05;
    else alpha = 1;
}

if (fading_out) {
    if (alpha > 0) alpha -= 0.05;
}

if (!function_ran) {
	function_ran = true;
	
	alarm[0] = visible_time;
}
