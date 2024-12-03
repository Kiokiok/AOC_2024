package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:math"
import "core:slice"
import "core:time"



main :: proc() 
{
	
	raw_file, ok := os.read_entire_file("data/day3.txt")

	string_file : string = string(raw_file)


	t_start := time.now()


	part_2(&string_file)


	t_dur := time.diff(t_start, time.now())

	fmt.printf("  Time: %v\n", t_dur)	
}


part_1 :: proc(data : ^string) {

	Stage :: enum {
		Begin,
		First_Num_Parse,
		Comma_Parse,
		Second_Num_Parse,
		Closing_Parent_Parse,
		Done
	}

	offset := 0

	total_nums := 0

	input_len := len(data^)

	for {

		if offset + 4 >= input_len { break }
		if data[offset:offset + 4] == "mul(" {

			// offset up to potential first number
			offset += 4

			properly_formed  := 0

			first_num_begin  := 0
			first_num_end    := 0
			first_number     := 0

			second_num_begin := 0
			second_num_end   := 0
			second_number    := 0

			stage : Stage = .Begin


			parse: for {
				switch data[offset] {
					case '0'..='9':
						if stage == .Begin || stage == .First_Num_Parse {
							if first_num_begin == 0 {first_num_begin = offset}
							first_num_end += 1
							offset +=1
							stage = .First_Num_Parse
						}
						else if stage == .Comma_Parse || stage == .Second_Num_Parse {
							if second_num_begin == 0 {second_num_begin = offset}
							second_num_end += 1
							offset +=1
							stage = .Second_Num_Parse
						}
						else
						{
							break parse
						}
						
					
					case ',':
						if stage == .First_Num_Parse {
							first_number = strconv.atoi(data[first_num_begin:first_num_begin + first_num_end])
							//fmt.printfln("first num  : %v", first_number)
							properly_formed +=1
							offset +=1
							stage = .Comma_Parse
						}
						else
						{
							break parse
						}
						
					
					case ')':
						if stage == .Second_Num_Parse {
							second_number = strconv.atoi(data[second_num_begin:second_num_begin + second_num_end])
							//fmt.printfln("second num  : %v", second_number)
							properly_formed +=1
							offset +=1
							stage = .Done
						}
						else
						{
							break parse
						}
						
						
						if stage == .Done {
							total_nums += first_number * second_number
						}

					case:
						break parse
				}
			}
		}
		else
		{
			offset += 1
		}
	}


	fmt.printfln("%v",total_nums)


}

part_2 :: proc(data : ^string) {

	Stage :: enum {
		Begin,
		First_Num_Parse,
		Comma_Parse,
		Second_Num_Parse,
		Closing_Parent_Parse,
		Done
	}

	offset := 0

	total_nums := 0

	input_len := len(data^)

	toggled_on := true

	for {

		if offset + 7 >= input_len { break }
		if data[offset:offset + 4] == "mul(" && toggled_on {

			// offset up to potential first number
			offset += 4

			properly_formed  := 0

			first_num_begin  := 0
			first_num_end    := 0
			first_number     := 0

			second_num_begin := 0
			second_num_end   := 0
			second_number    := 0

			stage : Stage = .Begin


			parse: for {
				switch data[offset] {
					case '0'..='9':
						if stage == .Begin || stage == .First_Num_Parse {
							if first_num_begin == 0 {first_num_begin = offset}
							first_num_end += 1
							offset +=1
							stage = .First_Num_Parse
						}
						else if stage == .Comma_Parse || stage == .Second_Num_Parse {
							if second_num_begin == 0 {second_num_begin = offset}
							second_num_end += 1
							offset +=1
							stage = .Second_Num_Parse
						}
						else
						{
							break parse
						}
						
					
					case ',':
						if stage == .First_Num_Parse {
							first_number = strconv.atoi(data[first_num_begin:first_num_begin + first_num_end])
							//fmt.printfln("first num  : %v", first_number)
							properly_formed +=1
							offset +=1
							stage = .Comma_Parse
						}
						else
						{
							break parse
						}
						
					
					case ')':
						if stage == .Second_Num_Parse {
							second_number = strconv.atoi(data[second_num_begin:second_num_begin + second_num_end])
							//fmt.printfln("second num  : %v", second_number)
							properly_formed +=1
							offset +=1
							stage = .Done
						}
						else
						{
							break parse
						}
						
						
						if stage == .Done {
							total_nums += first_number * second_number
						}

					case:
						break parse
				}
			}
		}
		else if data[offset:offset + 4] == "do()"{
			toggled_on = true
			offset +=1
		}
		else if data[offset:offset + 7] == "don't()"{
			toggled_on = false
			offset +=1
		}
		else
		{
			offset += 1
		}
	}


	fmt.printfln("%v",total_nums)


}
