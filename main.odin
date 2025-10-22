package main

import "core:time/datetime"
import "core:fmt"
import "core:os"
import "core:strings"


get_priority :: proc(line: string) -> string {

	res: string
	priority := make(map[string]Maybe(string))
	defer delete(priority)

	priority["Highest"] = "(A)"
	priority["High"] = "(B)"
	priority["Normal"] = "(C)"
	priority["Low"] = "(D)"
	priority["Lowest"] = "(Z)"
	priority["Undefined"] = nil

	// test
	if strings.contains(line, "(A)") {
		res = "Highest"
	}

	return res
} 


/*Priority := map[string]string{
	 = "(A)",
	"High" = "(B)",
	"Normal" = "(C)",
	"Low" = "(D)",
	"Lowest" = "(Z)",
	"NoPriority" = nil
}*/

Task :: struct {
	completed: bool,
	priority: string,
	completion: datetime.DateTime,
	creation: datetime.DateTime,
	description: string,
	tags: []string,
	tcontext: string,
	project: string,
	due: datetime.DateTime
}

parse_task :: proc(line: string) -> Task {
	task : Task

	if line[0] == 'x' {
		task.completed = true
	} else {
		task.completed = false
	}

	task.priority = get_priority(line)

	return task
} 

read_file_by_lines :: proc(filepath: string) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		fmt.println("Error: could not read file!")
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		fmt.println(parse_task(line))
		fmt.println(line)
	}
}

main :: proc() {
	def_filepath :: "todo.txt"
	filepath := def_filepath

	if len(os.args) > 1 {
		filepath = os.args[1]
	}
	
	read_file_by_lines(filepath)
}