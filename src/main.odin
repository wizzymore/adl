package main

import "core:fmt"
import "core:os/os2"
import "core:slice"
import "core:strings"
import "core:time"

/// This program contains memory leaks, but in odin this is not a problem.
/// Because the program is not long-running it means we will never allocate too much memory.
/// And in odin the memory is freed automatically by the default allocator when the program exists.
/// So for small programs like this, it is not a problem and it is faster to not deallocate.

readme_contents := #load("./templates/readme_template.md", string)
adr_contents := #load("./templates/adr_template.md", string)
help_contents := #load("./templates/help.txt", string)
template_readme_contents := #load("./templates/readme_templates_folder.md", string)

read_file_if_exists :: proc(
	filepath: string,
	allocator := context.allocator,
) -> (
	data: string,
	ok: bool,
) {
	bytes, err := os2.read_entire_file_from_path(filepath, allocator)
	if err != nil {
		ok = false
	}
	data = string(bytes)

	return
}

rebuild_readme :: proc(allocator := context.allocator) {
	context.allocator = allocator
	template_contents :=
		read_file_if_exists("./adr/templates/template_read.md") or_else readme_contents

	// If this fails idk
	date := get_http_date()
	output, _ := strings.replace_all(template_contents, "{{timestamp}}", date)

	files := get_all_files_in_adr_dir()

	formatted_files := make([dynamic]string)

	slice.sort(files[:])

	for str in files {
		append(&formatted_files, fmt.aprintf(" - [%s](./%s)", str, str))
	}

	replacement := strings.join(formatted_files[:], "\n")

	with_contents, _ := strings.replace_all(output, "{{contents}}", replacement)

	f, err := os2.open("./adr/README.md", os2.File_Flags{.Create, .Write, .Trunc})
	if err != nil {
		panic(fmt.aprintf("Failed to open adr/README.md for writing: %v", err))
	}
	defer os2.close(f)
	os2.write(f, transmute([]byte)(with_contents))
}

generate_adr :: proc(n: int, name: string, allocator := context.allocator) {
	context.allocator = allocator
	safe_name, _ := strings.replace_all(name, " ", "-")
	padded_nums := fmt.aprintf("%05d", n)
	file_name := fmt.aprintf("./adr/%s-%s.md", padded_nums, safe_name)

	heading := fmt.aprintf("%s - %s", padded_nums, name)
	template_contents :=
		read_file_if_exists("./adr/templates/template_adr.md") or_else adr_contents
	contents, _ := strings.replace_all(template_contents, "{{name}}", heading)

	f, err := os2.open(file_name, os2.File_Flags{.Create, .Trunc, .Write})
	if err != nil {
		panic(fmt.aprintf("Failed to open %s for writing: %v", file_name, err))
	}
	defer os2.close(f)
	os2.write(f, transmute([]byte)(contents))
}

establish_core_files :: proc() {
	if err := os2.make_directory("./adr/assets"); err != nil {
		if err != os2.General_Error.Exist {
			panic("Failed to create adr/assets directory: ")
		}
	}
	if err := os2.make_directory("./adr/templates"); err != nil {
		if err != os2.General_Error.Exist {
			panic("Failed to create adr/templates directory: ")
		}
	}

	f, err := os2.open("./adr/templates/README.md", os2.File_Flags{.Create, .Trunc, .Write})
	if err != nil {
		panic("Failed to create adr/templates/README.md: ")
	}
	defer os2.close(f)
	os2.write(f, transmute([]byte)(template_readme_contents))
}

get_all_files_in_adr_dir :: proc(allocator := context.allocator) -> [dynamic]string {
	files := make([dynamic]string, allocator)
	dir, err := os2.open("./adr")
	if err != nil {
		panic(fmt.aprintf("Failed to open adr directory: %v", err))
	}
	defer os2.close(dir)
	f: []os2.File_Info
	f, err = os2.read_all_directory(dir, allocator)
	if err != nil {
		panic(fmt.aprintf("Failed to read adr directory: %v", err))
	}

	for file_info in f {
		if file_info.name != "README.md" &&
		   file_info.name != "assets" &&
		   file_info.name != "templates" {
			append(&files, file_info.name)
		}
	}

	return files
}

main :: proc() {
	action: string
	if len(os2.args) > 1 {
		action = os2.args[1]
	} else {
		action = ""
	}
	switch action {
	case "create":
		establish_core_files()
		name := strings.join(os2.args[2:], " ")
		if name == "" {
			fmt.eprintln(
				"No name supplied for the ADR. Command should be: adl create Name of ADR here",
			)
			return
		}
		files := get_all_files_in_adr_dir()
		generate_adr(len(files), name)
		rebuild_readme()
	case "regen":
		establish_core_files()
		rebuild_readme()
	case:
		fmt.println(help_contents)
	}
}
