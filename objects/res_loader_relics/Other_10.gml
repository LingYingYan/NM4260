var json_file = file_text_open_read("relics.json");
var json_str = "";
while (!file_text_eof(json_file)) {
    json_str += file_text_read_string(json_file);
    file_text_readln(json_file); // Move to the next line
}

file_text_close(json_file);
self.relic_effects = json_parse(json_str);

// Inherit the parent event
event_inherited();

