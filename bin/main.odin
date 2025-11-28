package main

import "core:time/datetime"
import "core:fmt"
import "core:os"
import "core:strings"

Priority :: enum{Highest, High, Normal, Low, Lowest, NoPriority}

Task :: struct {
	completed: bool,
	priority: Priority,
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